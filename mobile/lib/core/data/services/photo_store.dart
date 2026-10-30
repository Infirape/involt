import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Keeps reading photos in the app's own folder (not the camera cache, which Android may
/// clear) until they are uploaded.
class PhotoStore {
  PhotoStore(this._folder);

  /// The store under the app documents directory.
  factory PhotoStore.appDocuments() => PhotoStore(() async {
    final docs = await getApplicationDocumentsDirectory();
    return io.Directory(p.join(docs.path, 'reading_photos'));
  });

  final Future<io.Directory> Function() _folder;

  /// Whether [photoUrl] is a photo still on the device (an absolute path); uploaded photos
  /// carry the server path instead.
  static bool isLocal(String? photoUrl) =>
      photoUrl != null && photoUrl.startsWith('/');

  /// Copies a picked photo into the store for [readingId] and returns its new path.
  Future<String> keep(String sourcePath, String readingId) async {
    final folder = await _folder();
    await folder.create(recursive: true);
    final name = '$readingId-${DateTime.now().microsecondsSinceEpoch}.jpg';
    final copy = await io.File(sourcePath).copy(p.join(folder.path, name));
    return copy.path;
  }

  /// Deletes a photo from the device; server paths and missing files are ignored.
  Future<void> discard(String? photoUrl) async {
    if (!isLocal(photoUrl)) return;
    final file = io.File(photoUrl!);
    if (await file.exists()) await file.delete();
  }
}

/// A photo still on the device whose reading is already on the server.
class PendingPhoto {
  const PendingPhoto(this.readingId, this.path);

  final String readingId;
  final String path;
}

/// Uploads pending photos one by one, after their readings were synced. [upload] returns the
/// server path, or null when it failed (the photo stays pending for the next run);
/// [uploaded] records the result, with '' when the file is gone so it is not retried.
/// Returns how many photos are still pending.
Future<int> uploadPendingPhotos(
  List<PendingPhoto> photos, {
  required Future<String?> Function(PendingPhoto photo) upload,
  required Future<void> Function(PendingPhoto photo, String url) uploaded,
}) async {
  var pending = 0;
  for (final photo in photos) {
    if (!await io.File(photo.path).exists()) {
      await uploaded(photo, '');
      continue;
    }
    final url = await upload(photo);
    if (url == null || url.isEmpty) {
      pending++;
    } else {
      await uploaded(photo, url);
    }
  }
  return pending;
}
