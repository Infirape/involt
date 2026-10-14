//
//  Generated code. Do not modify.
//  source: involt/v1/sync.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'sync.pb.dart' as $4;
import 'sync.pbjson.dart';

export 'sync.pb.dart';

abstract class SyncServiceBase extends $pb.GeneratedService {
  $async.Future<$4.PushReadingsResponse> pushReadings($pb.ServerContext ctx, $4.PushReadingsRequest request);
  $async.Future<$4.PullMetadataResponse> pullMetadata($pb.ServerContext ctx, $4.PullMetadataRequest request);
  $async.Future<$4.UploadPhotoResponse> uploadPhoto($pb.ServerContext ctx, $4.UploadPhotoRequest request);
  $async.Future<$4.DownloadReceiptResponse> downloadReceipt($pb.ServerContext ctx, $4.DownloadReceiptRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'PushReadings': return $4.PushReadingsRequest();
      case 'PullMetadata': return $4.PullMetadataRequest();
      case 'UploadPhoto': return $4.UploadPhotoRequest();
      case 'DownloadReceipt': return $4.DownloadReceiptRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'PushReadings': return this.pushReadings(ctx, request as $4.PushReadingsRequest);
      case 'PullMetadata': return this.pullMetadata(ctx, request as $4.PullMetadataRequest);
      case 'UploadPhoto': return this.uploadPhoto(ctx, request as $4.UploadPhotoRequest);
      case 'DownloadReceipt': return this.downloadReceipt(ctx, request as $4.DownloadReceiptRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SyncServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SyncServiceBase$messageJson;
}

