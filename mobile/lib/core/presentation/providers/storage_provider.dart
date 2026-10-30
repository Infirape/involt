import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Below this much free space the app warns: photos need room until they are uploaded.
const lowStorageBytes = 500 * 1024 * 1024;

bool isLowStorage(int? freeBytes) =>
    freeBytes != null && freeBytes < lowStorageBytes;

String formatBytes(int bytes) {
  const mb = 1024 * 1024;
  const gb = 1024 * mb;
  if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(1)} GB';
  return '${bytes ~/ mb} MB';
}

/// Free space on the phone, read from the platform (MainActivity / AppDelegate).
class StorageProvider extends ChangeNotifier {
  static const _channel = MethodChannel('involt/storage');

  int? _freeBytes;

  /// Null until known (or when the platform can't tell).
  int? get freeBytes => _freeBytes;
  bool get isLow => isLowStorage(_freeBytes);

  Future<void> refresh() async {
    int? free;
    try {
      free = await _channel.invokeMethod<int>('freeBytes');
    } on PlatformException catch (e) {
      debugPrint('💾 Free space unavailable: $e');
    } on MissingPluginException {
      // Platform without the channel (tests, desktop).
    }
    if (free == _freeBytes) return;
    _freeBytes = free;
    notifyListeners();
  }
}
