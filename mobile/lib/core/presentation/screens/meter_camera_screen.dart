import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Takes the meter photo inside the app, so it never reaches the phone's gallery: the
/// system camera app of many phones keeps its own copy of every photo it takes.
/// Pops with the path of the photo (in the app's private cache), or null if cancelled.
class MeterCameraScreen extends StatefulWidget {
  const MeterCameraScreen({super.key});

  @override
  State<MeterCameraScreen> createState() => _MeterCameraScreenState();
}

class _MeterCameraScreenState extends State<MeterCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  String? _error;
  bool _taking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  // The camera must be released while the app is in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller = null;
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _start();
    }
  }

  Future<void> _start() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw CameraException('NoCamera', null);
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      // 720p is enough to read a meter and keeps photos small.
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _error = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.code.contains('AccessDenied')
            ? 'Sin permiso para usar la cámara. Actívalo en los ajustes del teléfono.'
            : 'No se pudo abrir la cámara.';
      });
    }
  }

  Future<void> _takePhoto() async {
    final controller = _controller;
    if (controller == null || _taking) return;
    setState(() => _taking = true);
    try {
      final photo = await controller.takePicture();
      if (mounted) Navigator.pop(context, photo.path);
    } on CameraException {
      if (mounted) setState(() => _taking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Foto del medidor', style: TextStyle(fontSize: 16)),
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            )
          : controller == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.volt),
            )
          : Column(
              children: [
                Expanded(child: Center(child: CameraPreview(controller))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: IconButton.filled(
                    iconSize: 40,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.volt,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _taking ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
    );
  }
}
