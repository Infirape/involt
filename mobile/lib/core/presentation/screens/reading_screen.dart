import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/database.dart';
import '../../data/repositories/drift_reading_repository.dart';
import '../../data/services/photo_store.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/numeric_keypad.dart';
import '../providers/app_state_provider.dart';

class ReadingScreen extends StatefulWidget {
  final Customer customer;
  final AppDatabase db;

  const ReadingScreen({super.key, required this.customer, required this.db});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final TextEditingController _kwhController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  File? _image;
  // Photo saved with the existing reading (device path or server path), and whether the
  // user took a new one since.
  String? _savedPhotoUrl;
  bool _newPhoto = false;
  final _photos = PhotoStore.appDocuments();
  Position? _currentPosition;
  bool _isSaving = false;
  double _previousValue = 0;
  bool _isAlreadyRegistered = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;
    final repo = DriftReadingRepository(widget.db);
    
    // 1. Get all readings for this customer
    final allReadings = await repo.getReadingsForCustomer(widget.customer.id);
    
    // 2. Check if we are EDITING an existing reading for this period
    Reading? existingReading;
    try {
      existingReading = allReadings.firstWhere((r) => r.period == selectedPeriod);
    } catch (_) {}

    if (existingReading != null) {
      // If editing, the previous value is already stored in the reading
      // unless it's zero and we have a better one in history
      _previousValue = existingReading.previousValue;
      
      // Safety check: if stored previous is same as current, it's a corrupted record
      if (_previousValue == existingReading.currentValue) {
        final lastBefore = allReadings
            .where((r) => r.period.compareTo(selectedPeriod) < 0)
            .toList();
        if (lastBefore.isNotEmpty) {
          lastBefore.sort((a, b) => b.period.compareTo(a.period));
          _previousValue = lastBefore.first.currentValue;
        } else {
          _previousValue = widget.customer.initialReading;
        }
      }
    } else {
      // 3. If NEW reading, look for the latest from PREVIOUS periods
      final previousReadings = allReadings
          .where((r) => r.period.compareTo(selectedPeriod) < 0)
          .toList();
      
      if (previousReadings.isNotEmpty) {
        previousReadings.sort((a, b) => b.period.compareTo(a.period));
        _previousValue = previousReadings.first.currentValue;
      } else {
        // Fallback to initial reading (last_reading_value now calculated from readings table)
        _previousValue = widget.customer.initialReading;
      }
    }
    
    _determinePosition();

    // Proactive duplicate checK
    final readings = await repo.getReadingsForCustomer(widget.customer.id);

    try {
      final existingReading = readings.firstWhere(
        (r) => r.period == selectedPeriod,
        orElse: () => throw Exception('Not found'),
      );

      if (mounted) {
        setState(() {
          _isAlreadyRegistered = true;
          _kwhController.text = existingReading.currentValue.toStringAsFixed(1);
          _commentController.text = existingReading.comment ?? '';
          _savedPhotoUrl = existingReading.photoUrl;
          if (PhotoStore.isLocal(_savedPhotoUrl) &&
              File(_savedPhotoUrl!).existsSync()) {
            _image = File(_savedPhotoUrl!);
          }
          _showDuplicateEntryWarning();
        });
      }
    } catch (e) {
      // No reading found for period, no action needed
    }
  }

  void _showDuplicateEntryWarning() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.onyx,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber),
              SizedBox(width: 10),
              Text('Atención', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            'Ya existe un registro previo para este cliente en el periodo actual. Al guardar, se actualizará la información existente.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ENTENDIDO',
                style: TextStyle(color: AppColors.cyan),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _determinePosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint('GPS Error: $e');
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      // Enough to read a meter, ~300 KB instead of a full-size camera photo.
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _newPhoto = true;
      });
    }
  }

  double get _currentValue => double.tryParse(_kwhController.text) ?? 0;
  double get _consumption =>
      _currentValue > _previousValue ? _currentValue - _previousValue : 0;

  Future<void> _saveReading() async {
    if (_kwhController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese la lectura')));
      return;
    }

    if (_currentValue < _previousValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('ERROR: La lectura no puede ser menor a la anterior.'),
        ),
      );
      return;
    }

    if (_isAlreadyRegistered) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.onyx,
          title: const Text(
            'Sobrescribir Registro',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Ya existe una lectura para este período. ¿Desea actualizarla?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'ACTUALIZAR',
                style: TextStyle(color: AppColors.volt),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _isSaving = true);
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;

    try {
      final repo = DriftReadingRepository(widget.db);
      final readingId = 'read-${widget.customer.id}-$selectedPeriod';
      final photoUrl = await _photoToSave(readingId);
      final reading = Reading(
        id: readingId,
        customerId: widget.customer.id,
        period: selectedPeriod,
        previousValue: _previousValue,
        currentValue: _currentValue,
        consumptionKwh: _consumption,
        photoUrl: photoUrl,
        timestamp: DateTime.now(),
        latitude: _currentPosition?.latitude ?? 0,
        longitude: _currentPosition?.longitude ?? 0,
        cargoFijo: 0,
        alumbradoPublico: 0,
        saldoRedondeo: 0,
        totalToPay: 0,
        isSynced: false,
        comment: _commentController.text,
      );

      await repo.saveReading(reading);
      if (_newPhoto) await _photos.discard(_savedPhotoUrl); // replaced
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// A new photo is copied out of the camera cache; otherwise the saved one is kept.
  Future<String?> _photoToSave(String readingId) async {
    if (!_newPhoto || _image == null) return _savedPhotoUrl;
    final kept = await _photos.keep(_image!.path, readingId);
    try {
      await _image!.delete(); // the camera cache copy
    } catch (_) {}
    return kept;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onyx,
      appBar: AppBar(
        title: Text(
          widget.customer.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // PROACTIVE WARNING BADGE
          if (_isAlreadyRegistered)
            Container(
              width: double.infinity,
              color: Colors.amber.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ATENCIÓN: YA EXISTE UN REGISTRO PARA ESTE PERÍODO',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildPreviousReadingLabel(),
                  const SizedBox(height: 10),
                  _buildReadingInput(),
                  const SizedBox(height: 15),
                  _buildDifferenceLabel(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildActionArea(),
        ],
      ),
    );
  }

  Widget _buildPreviousReadingLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.history, color: Colors.white24, size: 14),
        const SizedBox(width: 6),
        Text(
          'LECTURA ANTERIOR: ${_previousValue.toStringAsFixed(1)} kWh',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReadingInput() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          _kwhController.text.isEmpty ? '0.0' : _kwhController.text,
          style: const TextStyle(
            color: AppColors.cyan,
            fontSize: 54,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildDifferenceLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'CONSUMO: ${_consumption.toStringAsFixed(1)} kWh',
        style: const TextStyle(
          color: AppColors.cyan,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumericKeypad(
              controller: _kwhController,
              onChanged: () => setState(() {}),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildPhotoThumbnail(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Observaciones (opcional)...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                  border: InputBorder.none,
                  icon: const Icon(Icons.edit, color: Colors.white12, size: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveReading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.volt,
                    foregroundColor: Colors.black, // High contrast text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          _isAlreadyRegistered
                              ? 'ACTUALIZAR LECTURA'
                              : 'GUARDAR LECTURA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail() {
    return GestureDetector(
      onTap: _takePhoto,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          image: _image != null
              ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
              : null,
        ),
        child: _image == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: AppColors.volt, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    // An uploaded photo is only on the server.
                    (_savedPhotoUrl ?? '').isNotEmpty
                        ? 'FOTO ENVIADA · TOCAR PARA CAMBIAR'
                        : 'AÑADIR FOTO (OPCIONAL)',
                    style: const TextStyle(
                      color: AppColors.volt,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
