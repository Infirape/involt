import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:involt/core/data/services/photo_store.dart';

void main() {
  late io.Directory tmp;
  late PhotoStore store;

  setUp(() async {
    tmp = await io.Directory.systemTemp.createTemp('photo_store_test');
    store = PhotoStore(() async => io.Directory('${tmp.path}/photos'));
  });

  tearDown(() => tmp.delete(recursive: true));

  Future<String> picked() async {
    final file = io.File('${tmp.path}/cache_photo.jpg');
    await file.writeAsBytes([1, 2, 3]);
    return file.path;
  }

  test('keeps a copy of the picked photo in its own folder', () async {
    final source = await picked();
    final kept = await store.keep(source, 'read-1');

    expect(kept, startsWith('${tmp.path}/photos/read-1-'));
    expect(await io.File(kept).readAsBytes(), [1, 2, 3]);
  });

  test('discards device photos and ignores server paths', () async {
    final kept = await store.keep(await picked(), 'read-1');

    await store.discard(kept);
    await store.discard('uploads/123_photo.jpg');
    await store.discard(null);
    await store.discard('${tmp.path}/missing.jpg');

    expect(await io.File(kept).exists(), isFalse);
  });

  group('uploadPendingPhotos', () {
    test('uploads each photo and records its server path', () async {
      final a = await store.keep(await picked(), 'read-a');
      final b = await store.keep(await picked(), 'read-b');
      final done = <String, String>{};

      final left = await uploadPendingPhotos(
        [PendingPhoto('read-a', a), PendingPhoto('read-b', b)],
        upload: (p) async => 'uploads/${p.readingId}.jpg',
        uploaded: (p, url) async => done[p.readingId] = url,
      );

      expect(left, 0);
      expect(done, {
        'read-a': 'uploads/read-a.jpg',
        'read-b': 'uploads/read-b.jpg',
      });
    });

    test('keeps failed uploads pending and goes on with the rest', () async {
      final a = await store.keep(await picked(), 'read-a');
      final b = await store.keep(await picked(), 'read-b');
      final done = <String>[];

      final left = await uploadPendingPhotos(
        [PendingPhoto('read-a', a), PendingPhoto('read-b', b)],
        upload: (p) async => p.readingId == 'read-a' ? null : 'uploads/b.jpg',
        uploaded: (p, url) async => done.add(p.readingId),
      );

      expect(left, 1);
      expect(done, ['read-b']);
    });

    test(
      'drops photos whose file is gone instead of retrying forever',
      () async {
        final done = <String, String>{};
        var uploads = 0;

        final left = await uploadPendingPhotos(
          [PendingPhoto('read-a', '${tmp.path}/gone.jpg')],
          upload: (_) async {
            uploads++;
            return 'x';
          },
          uploaded: (p, url) async => done[p.readingId] = url,
        );

        expect(left, 0);
        expect(uploads, 0);
        expect(done, {'read-a': ''});
      },
    );
  });
}
