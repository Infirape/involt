import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:involt/core/data/database.dart';
import 'package:involt/core/data/services/photo_store.dart';
import 'package:involt/core/data/services/sync_service.dart';
import 'package:involt/core/presentation/providers/photo_sync_provider.dart';
import 'package:involt/core/presentation/providers/storage_provider.dart';
import 'package:involt/core/presentation/widgets/status_bar.dart';
import 'package:provider/provider.dart';

class _FakeSync extends SyncService {
  _FakeSync(AppDatabase db, this.photos) : super(db: db);

  final List<PendingPhoto> photos;
  int uploads = 0;

  @override
  Future<List<PendingPhoto>> pendingPhotos() async => photos;

  @override
  Future<int> uploadPhotos() async {
    uploads++;
    photos.clear();
    return 0;
  }
}

void main() {
  const channel = MethodChannel('involt/storage');
  late AppDatabase db;

  setUp(() => db = AppDatabase.withExecutor(NativeDatabase.memory()));
  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await db.close();
  });

  Future<(StorageProvider, PhotoSyncProvider)> pumpBar(
    WidgetTester tester, {
    required int freeMb,
    required _FakeSync sync,
  }) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => freeMb * 1024 * 1024);
    final storage = StorageProvider();
    final photos = PhotoSyncProvider(db, serviceFor: (_) => sync);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: storage),
          ChangeNotifierProvider.value(value: photos),
        ],
        child: const MaterialApp(home: Scaffold(body: StatusBar())),
      ),
    );
    await tester.runAsync(() async {
      await storage.refresh();
      await photos.refresh();
    });
    await tester.pump();
    return (storage, photos);
  }

  testWidgets('warns about low storage and photos waiting', (tester) async {
    final sync = _FakeSync(db, [
      const PendingPhoto('read-1', '/a.jpg'),
      const PendingPhoto('read-2', '/b.jpg'),
    ]);
    await pumpBar(tester, freeMb: 300, sync: sync);

    expect(
      find.textContaining('Poco almacenamiento: quedan 300 MB'),
      findsOneWidget,
    );
    expect(find.textContaining('2 fotos por subir'), findsOneWidget);
  });

  testWidgets('shows nothing when there is room and no photos left', (
    tester,
  ) async {
    final sync = _FakeSync(db, [const PendingPhoto('read-1', '/a.jpg')]);
    final (_, photos) = await pumpBar(tester, freeMb: 4000, sync: sync);
    expect(find.textContaining('Poco almacenamiento'), findsNothing);

    await tester.runAsync(() => photos.upload('token'));
    await tester.pump();

    expect(sync.uploads, 1);
    expect(find.byType(Text), findsNothing);
  });
}
