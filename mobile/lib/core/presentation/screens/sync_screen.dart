import 'dart:async';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../data/database.dart';
import '../../data/services/sync_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/photo_sync_provider.dart';

class SyncScreen extends StatefulWidget {
  final AppDatabase db;
  const SyncScreen({super.key, required this.db});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final db = widget.db;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Sincronización',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sync Status Summary
            StreamBuilder<List<Reading>>(
              stream: db.select(db.readings).watch(),
              builder: (context, snapshot) {
                final readings = snapshot.data ?? [];
                final unsynced = readings.where((r) => !r.isSynced).length;
                final synced = readings.length - unsynced;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusCard(
                            'Pendientes',
                            unsynced.toString(),
                            AppColors.volt,
                            Icons.cloud_upload_outlined,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatusCard(
                            'Sincronizados',
                            synced.toString(),
                            AppColors.cyan,
                            Icons.cloud_done_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const NetworkStatusCard(),
                    const SizedBox(height: 20),
                    // Sync Progress / Action
                    GlassCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: (unsynced > 0 && !_isProcessing)
                                        ? () => _handleSync(context)
                                        : null,
                                    icon: Icon(
                                      _isProcessing
                                          ? Icons.hourglass_empty
                                          : Icons.cloud_upload_outlined,
                                    ),
                                    label: Text(
                                      _isProcessing
                                          ? 'PROCESANDO...'
                                          : 'SUBIR MEDIDAS',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.volt,
                                      foregroundColor: Colors.black,
                                      disabledBackgroundColor: Colors.white10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white54,
                                ),
                                onPressed: () => _showInfo(
                                  context,
                                  'Envía todas las lecturas guardadas localmente al servidor central de Infira.',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: _isProcessing
                                        ? null
                                        : () => _handleUpdateCatalogs(context),
                                    icon: Icon(
                                      _isProcessing
                                          ? Icons.hourglass_empty
                                          : Icons.cloud_download_outlined,
                                    ),
                                    label: Text(
                                      _isProcessing
                                          ? 'PROCESANDO...'
                                          : 'ACTUALIZAR DATOS',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _isProcessing
                                          ? Colors.grey
                                          : AppColors.cyan,
                                      side: BorderSide(
                                        color: _isProcessing
                                            ? Colors.grey
                                            : AppColors.cyan,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white54,
                                ),
                                onPressed: () => _showInfo(
                                  context,
                                  'Descarga la lista actualizada de clientes, sectores y zonas desde el servidor.',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),
            const Text(
              'Actividad Reciente',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Recent Activity List
            Expanded(
              child: StreamBuilder<List<drift.TypedResult>>(
                stream:
                    (db.select(db.readings).join([
                          drift.innerJoin(
                            db.customers,
                            db.customers.id.equalsExp(db.readings.customerId),
                          ),
                        ])..orderBy([
                          drift.OrderingTerm.desc(db.readings.timestamp),
                        ]))
                        .watch(),
                builder: (context, snapshot) {
                  final rows = snapshot.data ?? [];
                  if (rows.isEmpty) {
                    return Center(
                      child: Text(
                        'Sin lecturas registradas',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final reading = row.readTable(db.readings);
                      final customer = row.readTable(db.customers);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: reading.isSynced
                                      ? AppColors.cyan.withOpacity(0.1)
                                      : AppColors.volt.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  reading.isSynced ? Icons.check : Icons.sync,
                                  color: reading.isSynced
                                      ? AppColors.cyan
                                      : AppColors.volt,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Lectura: ${reading.currentValue} kWh',
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.cyan),
            SizedBox(width: 10),
            Text('Información', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ENTENDIDO',
              style: TextStyle(
                color: AppColors.volt,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<SyncService> _syncServiceForCurrentSession(
    BuildContext context,
  ) async {
    final appState = context.read<AppStateProvider>();
    if (appState.authToken.isEmpty) {
      await appState.loadPeriod();
    }

    if (!context.mounted) {
      throw StateError('La pantalla ya no está activa');
    }

    final refreshedState = context.read<AppStateProvider>();
    if (refreshedState.authToken.isEmpty) {
      throw StateError('No hay una sesión activa. Inicia sesión nuevamente.');
    }

    return SyncService(db: widget.db, authToken: refreshedState.authToken);
  }

  Future<void> _handleUpdateCatalogs(BuildContext context) async {
    setState(() => _isProcessing = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Actualizando clientes y sectores...'),
        backgroundColor: AppColors.cyan,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final syncService = await _syncServiceForCurrentSession(context);
      await syncService.pullMetadata();

      if (context.mounted) {
        await context.read<AppStateProvider>().loadPeriod();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Datos actualizados con éxito'),
            backgroundColor: AppColors.cyan,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al actualizar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleSync(BuildContext context) async {
    setState(() => _isProcessing = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sincronizando con el servidor de Infira...',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.volt,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final syncService = await _syncServiceForCurrentSession(context);
      // 1. Push captured readings; their photos follow in the background
      await syncService.pushReadings();
      if (context.mounted) {
        unawaited(
          context.read<PhotoSyncProvider>().upload(syncService.authToken ?? ''),
        );
      }

      // 2. Pull latest metadata (master data)
      await syncService.pullMetadata();

      if (context.mounted) {
        await context.read<AppStateProvider>().loadPeriod();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sincronización completada con éxito'),
            backgroundColor: AppColors.cyan,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error de sincronización: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

class NetworkStatusCard extends StatefulWidget {
  const NetworkStatusCard({super.key});

  @override
  State<NetworkStatusCard> createState() => _NetworkStatusCardState();
}

class _NetworkStatusCardState extends State<NetworkStatusCard> {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  String? _wifiName;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      return;
    }
    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (result == ConnectivityResult.wifi) {
      try {
        final wifiName = await _networkInfo.getWifiName();
        setState(() {
          _wifiName = wifiName;
        });
      } catch (e) {
        debugPrint('❌ Error al obtener SSID: $e');
        setState(() {
          _wifiName = 'Wi-Fi Conectado';
        });
      }
    } else {
      setState(() {
        _wifiName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOffline = _connectionStatus == ConnectivityResult.none;
    final bool isWifi = _connectionStatus == ConnectivityResult.wifi;
    final bool isMobile = _connectionStatus == ConnectivityResult.mobile;

    String statusText = 'Desconectado';
    IconData statusIcon = Icons.wifi_off;
    Color statusColor = Colors.redAccent;

    if (isWifi) {
      statusText = _wifiName ?? 'Conectado a Wi-Fi';
      statusIcon = Icons.wifi;
      statusColor = AppColors.cyan;
    } else if (isMobile) {
      statusText = 'Datos Móviles';
      statusIcon = Icons.signal_cellular_alt;
      statusColor = AppColors.volt;
    }

    return GlassCard(
      child: Column(
        children: [
          const Text(
            'Estado de la conexión',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, color: statusColor, size: 16),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isOffline) ...[
            const SizedBox(height: 8),
            const Text(
              'Se requiere conexión para sincronizar',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
