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

  group('preparePhoto', () {
    test('uploads a device photo', () async {
      final kept = await store.keep(await picked(), 'read-1');
      final result = await preparePhoto(kept, (_) async => 'uploads/1_x.jpg');

      expect(result.url, 'uploads/1_x.jpg');
      expect(result.uploaded, isTrue);
      expect(result.retry, isFalse);
    });

    test('asks to retry when the upload fails', () async {
      final kept = await store.keep(await picked(), 'read-1');
      final result = await preparePhoto(kept, (_) async => null);

      expect(result.retry, isTrue);
    });

    test('does not upload photos already on the server, or none', () async {
      var calls = 0;
      Future<String?> upload(io.File _) async {
        calls++;
        return 'x';
      }

      expect(
        (await preparePhoto('uploads/1_x.jpg', upload)).url,
        'uploads/1_x.jpg',
      );
      expect((await preparePhoto(null, upload)).url, '');
      expect(calls, 0);
    });

    test('pushes without the photo when the file is gone', () async {
      final result = await preparePhoto(
        '${tmp.path}/gone.jpg',
        (_) async => 'x',
      );

      expect(result.url, '');
      expect(result.retry, isFalse);
    });
  });
}
