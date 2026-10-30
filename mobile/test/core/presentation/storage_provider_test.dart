import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:involt/core/presentation/providers/storage_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('involt/storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('low below 500 MB, unknown is not low', () {
    expect(isLowStorage(499 * 1024 * 1024), isTrue);
    expect(isLowStorage(500 * 1024 * 1024), isFalse);
    expect(isLowStorage(null), isFalse);
  });

  test('formats free space in MB or GB', () {
    expect(formatBytes(320 * 1024 * 1024), '320 MB');
    expect(formatBytes(3 * 1024 * 1024 * 1024 ~/ 2), '1.5 GB');
  });

  test('reads the free space from the platform', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'freeBytes');
      return 100 * 1024 * 1024;
    });
    final storage = StorageProvider();

    await storage.refresh();

    expect(storage.freeBytes, 100 * 1024 * 1024);
    expect(storage.isLow, isTrue);
  });

  test('stays unknown when the platform has no channel', () async {
    final storage = StorageProvider();
    await storage.refresh();
    expect(storage.freeBytes, isNull);
    expect(storage.isLow, isFalse);
  });
}
