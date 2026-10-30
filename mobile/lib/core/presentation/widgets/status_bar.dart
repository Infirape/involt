import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/photo_sync_provider.dart';
import '../providers/storage_provider.dart';
import '../theme/app_colors.dart';

/// Thin bar over the main screens: low storage on the phone and photos still uploading.
/// Shows nothing when all is well.
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageProvider>();
    final photos = context.watch<PhotoSyncProvider>();

    final rows = <Widget>[
      if (storage.isLow)
        _StatusRow(
          icon: Icons.sd_card_alert,
          color: AppColors.amber,
          text:
              'Poco almacenamiento: quedan ${formatBytes(storage.freeBytes!)}. '
              'Sincroniza para liberar las fotos o libera espacio en el teléfono.',
        ),
      if (photos.pending > 0)
        _StatusRow(
          icon: photos.uploading ? Icons.cloud_upload : Icons.cloud_queue,
          color: AppColors.cyan,
          text: photos.uploading
              ? 'Subiendo fotos en segundo plano: ${_photos(photos.pending)} pendientes'
              : '${_photos(photos.pending)} por subir; se enviarán con conexión',
        ),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      bottom: false,
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }

  static String _photos(int n) => n == 1 ? '1 foto' : '$n fotos';
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withOpacity(0.15),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
