import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'package:connectrpc/connect.dart' hide Transport;
import 'package:connectrpc/io.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:drift/drift.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import '../../gen/proto/involt/v1/sync.pb.dart' as pb;
import '../../gen/proto/involt/v1/models.pb.dart' as models;
import '../database.dart';
import 'photo_store.dart';

import '../../config/app_config.dart';

class SyncService {
  final AppDatabase db;
  final String baseUrl;
  final String? authToken;
  final PhotoStore _photos;

  SyncService({
    required this.db,
    this.baseUrl = AppConfig.baseUrl,
    this.authToken,
    PhotoStore? photos,
  }) : _photos = photos ?? PhotoStore.appDocuments();

  protocol.Transport _getTransport() {
    final client = io.HttpClient();
    return protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(client),
    );
  }

  CallOptions _authOptions() {
    final token = authToken;
    if (token == null || token.isEmpty) {
      throw StateError('No hay una sesión activa para sincronizar');
    }

    final headers = Headers();
    headers['Authorization'] = 'Bearer $token';
    return CallOptions(headers: headers);
  }

  DateTime _parseReadingTimestamp(models.Reading reading) {
    final raw = reading.timestamp.trim();
    if (raw.isEmpty) {
      final periodStart = DateTime.tryParse(reading.periodStart.trim());
      return periodStart ?? DateTime.now();
    }

    final numeric = int.tryParse(raw);
    if (numeric != null) {
      final isMilliseconds = raw.length > 10;
      return DateTime.fromMillisecondsSinceEpoch(
        isMilliseconds ? numeric : numeric * 1000,
      );
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return parsed;
    }

    throw FormatException('Fecha inválida en lectura ${reading.id}: "$raw"');
  }

  String _periodForReading(models.Reading reading, DateTime timestamp) {
    // 1. Check ID for explicit date suffix (e.g. hist-...-2026-04)
    final periodFromId = _periodFromReadingId(reading.id);
    if (periodFromId != null) {
      return periodFromId;
    }

    // 2. For historical records (starting with 'hist-'), trust the server's period field
    // even if the ID doesn't have the date suffix.
    if (reading.id.startsWith('hist-') && reading.period.trim().isNotEmpty) {
      return reading.period.trim();
    }

    // 3. Use explicit period if provided
    if (reading.period.trim().isNotEmpty) {
      return reading.period.trim();
    }

    // 4. Fallback to periodStart
    final periodStart = DateTime.tryParse(reading.periodStart.trim());
    if (periodStart != null) {
      return '${periodStart.year}-${periodStart.month.toString().padLeft(2, '0')}';
    }

    // 4. Ultimate fallback to timestamp
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}';
  }

  String? _periodFromReadingId(String id) {
    return RegExp(r'(\d{4}-\d{2})$').firstMatch(id)?.group(1);
  }

  Future<void> _normalizeLocalReadingPeriodsFromIds() async {
    final localReadings = await db.select(db.readings).get();

    await db.batch((batch) {
      var updatedCount = 0;
      for (final reading in localReadings) {
        final periodFromId = _periodFromReadingId(reading.id);
        if (periodFromId == null || periodFromId == reading.period) {
          continue;
        }

        updatedCount++;
        batch.update(
          db.readings,
          ReadingsCompanion(period: Value(periodFromId)),
          where: (tbl) => tbl.id.equals(reading.id),
        );
      }

      if (updatedCount > 0) {
        print('🧹 Sync: Normalized $updatedCount local reading periods');
      }
    });
  }

  Future<void> pullMetadata() async {
    final transport = _getTransport();

    try {
      debugPrint('🔄 Sync: Starting PullMetadata...');
      debugPrint('🌐 Sync: Pointing to $baseUrl');
      
      // Manual Unary Call using the correct Spec class and factories
      final response = await transport
          .unary<pb.PullMetadataRequest, pb.PullMetadataResponse>(
            Spec(
              '/involt.v1.SyncService/PullMetadata',
              StreamType.unary,
              () => pb.PullMetadataRequest(),
              () => pb.PullMetadataResponse(),
            ),
            pb.PullMetadataRequest(),
            _authOptions(),
          );

      debugPrint(
        '✅ Sync: Received ${response.message.sectors.length} sectors, '
        '${response.message.customers.length} customers, and '
        '${response.message.readings.length} readings',
      );

      if (response.message.readings.isNotEmpty) {
        final first = response.message.readings.first;
        debugPrint('📝 Sync: First reading ID: ${first.id}');
        debugPrint('📝 Sync: First reading Period: ${first.period}');
        debugPrint('📝 Sync: First reading PeriodStart: ${first.periodStart}');
      }

      // Clean up old metadata that is no longer assigned to this user
      // Order matters due to foreign key constraints!
      final customerIds = response.message.customers.map((c) => c.id).toList();
      await (db.delete(db.customers)..where((t) => t.id.isNotIn(customerIds))).go();

      final sectorIds = response.message.sectors.map((s) => s.id).toList();
      await (db.delete(db.sectors)..where((t) => t.id.isNotIn(sectorIds))).go();

      final communityIds = response.message.communities.map((c) => c.id).toList();
      await (db.delete(db.communities)..where((t) => t.id.isNotIn(communityIds))).go();

      // Update local database
      await db.batch((batch) {
        // 1. Communities
        for (final comm in response.message.communities) {
          batch.insert(
            db.communities,
            CommunitiesCompanion.insert(id: comm.id, name: comm.name),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 2. Sectors
        for (final sector in response.message.sectors) {
          batch.insert(
            db.sectors,
            SectorsCompanion.insert(
              id: sector.id,
              communityId: sector.communityId,
              name: sector.name,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 3. Customers
        for (final cust in response.message.customers) {
          batch.insert(
            db.customers,
            CustomersCompanion.insert(
              id: cust.id,
              code: cust.code,
              name: cust.name,
              communityId: cust.communityId,
              sectorId: cust.sectorId,
              connectionType: cust.connectionType.value,
              tariff: cust.tariff,
              meterNumber: cust.meterNumber,
              latitude: Value(cust.latitude),
              longitude: Value(cust.longitude),
              initialReading: Value(cust.initialReading),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 4. Config
        if (response.message.hasConfig()) {
          final config = response.message.config;
          if (config.mapUrlTemplate.isNotEmpty) {
            batch.insert(
              db.settings,
              SettingsCompanion.insert(
                key: 'map_url_template',
                value: config.mapUrlTemplate,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
          if (config.mapUserAgent.isNotEmpty) {
            batch.insert(
              db.settings,
              SettingsCompanion.insert(
                key: 'map_user_agent',
                value: config.mapUserAgent,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // Current Period
        if (response.message.hasCurrentPeriod()) {
          final currentPeriodId = response.message.currentPeriod.id;
          batch.insert(
            db.settings,
            SettingsCompanion.insert(
              key: 'current_period',
              value: currentPeriodId,
            ),
            mode: InsertMode.insertOrReplace,
          );
          batch.insert(
            db.settings,
            SettingsCompanion.insert(
              key: 'enabled_periods',
              value: currentPeriodId,
            ),
            mode: InsertMode.insertOrReplace,
          );
          debugPrint('📅 Sync: Enabled period set to $currentPeriodId');
        }

        // 5. Operators (for offline login)
        for (final op in response.message.operators) {
          batch.insert(
            db.operators,
            OperatorsCompanion.insert(
              id: op.id,
              email: op.email,
              passwordHash: op.passwordHash,
              role: op.role,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 6. Readings (Historical)
        var readingCount = 0;
        for (final r in response.message.readings) {
          try {
            final timestamp = _parseReadingTimestamp(r);
            batch.insert(
              db.readings,
              ReadingsCompanion.insert(
                id: r.id,
                customerId: r.customerId,
                previousValue: r.previousValue,
                currentValue: r.currentValue,
                consumptionKwh: r.consumption,
                photoUrl: Value(r.photoUrl),
                timestamp: timestamp,
                latitude: r.latitude,
                longitude: r.longitude,
                cargoFijo: r.cargoFijo,
                alumbradoPublico: r.alumbradoPublico,
                saldoRedondeo: r.saldoRedondeo,
                totalToPay: r.totalToPay,
                isSynced: const Value(true),
                period: Value(_periodForReading(r, timestamp)),
              ),
              mode: InsertMode.insertOrReplace,
            );
            readingCount++;
          } catch (e) {
            debugPrint('⚠️ Sync: Error mapping reading ${r.id}: $e');
          }
        }
        debugPrint('📝 Sync: Prepared $readingCount readings for insertion');
      });
      await _normalizeLocalReadingPeriodsFromIds();
      debugPrint('✅ Sync: Metadata updated (including config)');
    } catch (e) {
      debugPrint('❌ Sync Error (Pull): $e');
      rethrow;
    }
  }

  Future<void> hardReset() async {
    print('🚨 Sync: Performing HARD RESET...');
    await db.transaction(() async {
      await db.delete(db.readings).go();
      await db.delete(db.customers).go();
      await db.delete(db.sectors).go();
      await db.delete(db.communities).go();
    });
    print('✅ Sync: Local database cleared.');
  }

  /// Photos still on the device whose readings are already on the server.
  Future<List<PendingPhoto>> pendingPhotos() async {
    final rows =
        await (db.select(db.readings)..where(
              (r) => r.isSynced.equals(true) & r.photoUrl.like('/%'),
            ))
            .get();
    return [for (final r in rows) PendingPhoto(r.id, r.photoUrl!)];
  }

  /// Uploads the pending photos (after their readings), attaching each one to its reading
  /// on the server and freeing the device copy. Returns how many are still pending.
  Future<int> uploadPhotos() async {
    return uploadPendingPhotos(
      await pendingPhotos(),
      upload: (photo) =>
          uploadPhoto(io.File(photo.path), readingId: photo.readingId),
      uploaded: (photo, url) async {
        await (db.update(db.readings)
              ..where((t) => t.id.equals(photo.readingId)))
            .write(ReadingsCompanion(photoUrl: Value(url)));
        await _photos.discard(photo.path);
      },
    );
  }

  Future<String?> uploadPhoto(io.File photo, {String readingId = ''}) async {
    final transport = _getTransport();

    try {
      final bytes = await photo.readAsBytes();
      final response = await transport
          .unary<pb.UploadPhotoRequest, pb.UploadPhotoResponse>(
            Spec(
              '/involt.v1.SyncService/UploadPhoto',
              StreamType.unary,
              () => pb.UploadPhotoRequest(),
              () => pb.UploadPhotoResponse(),
            ),
            pb.UploadPhotoRequest(
              fileName: p.basename(photo.path),
              data: bytes,
              readingId: readingId,
            ),
            _authOptions(),
          );
      // A photo for a reading only counts once the server says it is attached to it.
      if (readingId.isNotEmpty && !response.message.attached) {
        debugPrint('⚠️ Sync: server did not attach the photo of $readingId');
        return null;
      }
      return response.message.url;
    } catch (e) {
      print('❌ Sync Error (Photo Upload): $e');
      return null;
    }
  }

  Future<void> pushReadings() async {
    final transport = _getTransport();

    try {
      // 1. Get unsynced readings
      final unsynced = await (db.select(
        db.readings,
      )..where((r) => r.isSynced.equals(false))).get();
      if (unsynced.isEmpty) {
        print('ℹ️ Sync: No new readings to push');
        return;
      }

      print('📤 Sync: Pushing ${unsynced.length} readings...');

      // 2. Prepare Protobuf request. Readings go first, without waiting for their photos:
      // photos still on the device are uploaded afterwards by uploadPhotos().
      final request = pb.PushReadingsRequest();
      for (final r in unsynced) {
        request.readings.add(
          models.Reading(
            id: r.id,
            customerId: r.customerId,
            previousValue: r.previousValue,
            currentValue: r.currentValue,
            consumption: r.consumptionKwh,
            photoUrl: PhotoStore.isLocal(r.photoUrl) ? '' : (r.photoUrl ?? ''),
            timestamp: r.timestamp.toIso8601String(),
            latitude: r.latitude,
            longitude: r.longitude,
            cargoFijo: r.cargoFijo,
            alumbradoPublico: r.alumbradoPublico,
            saldoRedondeo: r.saldoRedondeo,
            totalToPay: r.totalToPay,
            period: r.period,
          ),
        );
      }

      // 3. Call RPC
      final response = await transport
          .unary<pb.PushReadingsRequest, pb.PushReadingsResponse>(
            Spec(
              '/involt.v1.SyncService/PushReadings',
              StreamType.unary,
              () => pb.PushReadingsRequest(),
              () => pb.PushReadingsResponse(),
            ),
            request,
            _authOptions(),
          );

      if (response.message.success) {
        debugPrint(
          '✅ Sync: Successfully pushed ${response.message.syncedCount} readings',
        );

        // 4. Mark as synced in local DB
        await db.batch((batch) {
          for (final r in unsynced) {
            batch.update(
              db.readings,
              ReadingsCompanion(isSynced: const Value(true)),
              where: (tbl) => tbl.id.equals(r.id),
            );
          }
        });
        await _normalizeLocalReadingPeriodsFromIds();
      } else {
        debugPrint('⚠️ Sync: Server reported failure during push');
      }
    } catch (e) {
      debugPrint('❌ Sync Error (Push): $e');
      rethrow;
    }
  }

  Future<Uint8List?> downloadReceipt(String readingId) async {
    final transport = _getTransport();

    try {
      final response = await transport
          .unary<pb.DownloadReceiptRequest, pb.DownloadReceiptResponse>(
            Spec(
              '/involt.v1.SyncService/DownloadReceipt',
              StreamType.unary,
              () => pb.DownloadReceiptRequest(),
              () => pb.DownloadReceiptResponse(),
            ),
            pb.DownloadReceiptRequest(readingId: readingId),
            _authOptions(),
          );
      return Uint8List.fromList(response.message.pdfData);
    } catch (e) {
      print('❌ Sync Error (Download Receipt): $e');
      return null;
    }
  }
}
