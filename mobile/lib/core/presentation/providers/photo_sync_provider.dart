import 'package:flutter/foundation.dart';

import '../../data/database.dart';
import '../../data/services/sync_service.dart';

/// Uploads reading photos in the background, after their readings are synced, and keeps
/// count of the ones left for the status bar. Photos are only for later review, so they
/// never hold back a sync.
class PhotoSyncProvider extends ChangeNotifier {
  PhotoSyncProvider(this.db, {SyncService Function(String token)? serviceFor})
    : _serviceFor =
          serviceFor ?? ((token) => SyncService(db: db, authToken: token));

  final AppDatabase db;
  final SyncService Function(String token) _serviceFor;

  int _pending = 0;
  bool _uploading = false;

  /// Photos still on the device, waiting to be uploaded.
  int get pending => _pending;
  bool get uploading => _uploading;

  /// Recounts the pending photos (e.g. after saving a reading or a sync).
  Future<void> refresh() async {
    _pending = (await _serviceFor('').pendingPhotos()).length;
    notifyListeners();
  }

  /// Uploads the pending photos; does nothing while an upload is already running.
  Future<void> upload(String token) async {
    if (_uploading || token.isEmpty) return;
    _uploading = true;
    notifyListeners();
    try {
      _pending = await _serviceFor(token).uploadPhotos();
    } catch (e) {
      debugPrint('📸 Photo upload stopped: $e');
      await refresh();
    } finally {
      _uploading = false;
      notifyListeners();
    }
  }
}
