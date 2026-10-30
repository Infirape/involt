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

/// Outcome of preparing a reading's photo for a push.
class PhotoUpload {
  const PhotoUpload._(this.url, {required this.uploaded, required this.retry});

  /// The photo is on the server (or there is none): push the reading with [url].
  const PhotoUpload.ready(String url, {bool uploaded = false})
    : this._(url, uploaded: uploaded, retry: false);

  /// The upload failed: keep the reading unsynced and try again on the next sync.
  const PhotoUpload.later() : this._('', uploaded: false, retry: true);

  final String url;

  /// True when this push uploaded the photo (so the device copy can go).
  final bool uploaded;
  final bool retry;
}

/// Uploads the reading photo when it is still on the device.
Future<PhotoUpload> preparePhoto(
  String? photoUrl,
  Future<String?> Function(io.File photo) upload,
) async {
  if (!PhotoStore.isLocal(photoUrl)) return PhotoUpload.ready(photoUrl ?? '');
  final file = io.File(photoUrl!);
  // The file is gone (e.g. app data cleared): push the reading without its photo.
  if (!await file.exists()) return const PhotoUpload.ready('');
  final remote = await upload(file);
  if (remote == null || remote.isEmpty) return const PhotoUpload.later();
  return PhotoUpload.ready(remote, uploaded: true);
}
