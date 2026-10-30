//
//  Generated code. Do not modify.
//  source: involt/v1/sync.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'models.pbjson.dart' as $0;

@$core.Deprecated('Use pushReadingsRequestDescriptor instead')
const PushReadingsRequest$json = {
  '1': 'PushReadingsRequest',
  '2': [
    {'1': 'readings', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Reading', '10': 'readings'},
  ],
};

/// Descriptor for `PushReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushReadingsRequestDescriptor = $convert.base64Decode(
    'ChNQdXNoUmVhZGluZ3NSZXF1ZXN0Ei4KCHJlYWRpbmdzGAEgAygLMhIuaW52b2x0LnYxLlJlYW'
    'RpbmdSCHJlYWRpbmdz');

@$core.Deprecated('Use pushReadingsResponseDescriptor instead')
const PushReadingsResponse$json = {
  '1': 'PushReadingsResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'synced_count', '3': 2, '4': 1, '5': 5, '10': 'syncedCount'},
  ],
};

/// Descriptor for `PushReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushReadingsResponseDescriptor = $convert.base64Decode(
    'ChRQdXNoUmVhZGluZ3NSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEiEKDHN5bm'
    'NlZF9jb3VudBgCIAEoBVILc3luY2VkQ291bnQ=');

@$core.Deprecated('Use pullMetadataRequestDescriptor instead')
const PullMetadataRequest$json = {
  '1': 'PullMetadataRequest',
  '2': [
    {'1': 'last_sync_timestamp', '3': 1, '4': 1, '5': 3, '10': 'lastSyncTimestamp'},
  ],
};

/// Descriptor for `PullMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMetadataRequestDescriptor = $convert.base64Decode(
    'ChNQdWxsTWV0YWRhdGFSZXF1ZXN0Ei4KE2xhc3Rfc3luY190aW1lc3RhbXAYASABKANSEWxhc3'
    'RTeW5jVGltZXN0YW1w');

@$core.Deprecated('Use pullMetadataResponseDescriptor instead')
const PullMetadataResponse$json = {
  '1': 'PullMetadataResponse',
  '2': [
    {'1': 'communities', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Community', '10': 'communities'},
    {'1': 'sectors', '3': 2, '4': 3, '5': 11, '6': '.involt.v1.Sector', '10': 'sectors'},
    {'1': 'customers', '3': 3, '4': 3, '5': 11, '6': '.involt.v1.Customer', '10': 'customers'},
    {'1': 'readings', '3': 4, '4': 3, '5': 11, '6': '.involt.v1.Reading', '10': 'readings'},
    {'1': 'config', '3': 5, '4': 1, '5': 11, '6': '.involt.v1.AppConfig', '10': 'config'},
    {'1': 'settings', '3': 6, '4': 1, '5': 11, '6': '.involt.v1.Settings', '10': 'settings'},
    {'1': 'current_period', '3': 7, '4': 1, '5': 11, '6': '.involt.v1.Period', '10': 'currentPeriod'},
    {'1': 'operators', '3': 8, '4': 3, '5': 11, '6': '.involt.v1.Operator', '10': 'operators'},
  ],
};

/// Descriptor for `PullMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMetadataResponseDescriptor = $convert.base64Decode(
    'ChRQdWxsTWV0YWRhdGFSZXNwb25zZRI2Cgtjb21tdW5pdGllcxgBIAMoCzIULmludm9sdC52MS'
    '5Db21tdW5pdHlSC2NvbW11bml0aWVzEisKB3NlY3RvcnMYAiADKAsyES5pbnZvbHQudjEuU2Vj'
    'dG9yUgdzZWN0b3JzEjEKCWN1c3RvbWVycxgDIAMoCzITLmludm9sdC52MS5DdXN0b21lclIJY3'
    'VzdG9tZXJzEi4KCHJlYWRpbmdzGAQgAygLMhIuaW52b2x0LnYxLlJlYWRpbmdSCHJlYWRpbmdz'
    'EiwKBmNvbmZpZxgFIAEoCzIULmludm9sdC52MS5BcHBDb25maWdSBmNvbmZpZxIvCghzZXR0aW'
    '5ncxgGIAEoCzITLmludm9sdC52MS5TZXR0aW5nc1IIc2V0dGluZ3MSOAoOY3VycmVudF9wZXJp'
    'b2QYByABKAsyES5pbnZvbHQudjEuUGVyaW9kUg1jdXJyZW50UGVyaW9kEjEKCW9wZXJhdG9ycx'
    'gIIAMoCzITLmludm9sdC52MS5PcGVyYXRvclIJb3BlcmF0b3Jz');

@$core.Deprecated('Use uploadPhotoRequestDescriptor instead')
const UploadPhotoRequest$json = {
  '1': 'UploadPhotoRequest',
  '2': [
    {'1': 'file_name', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'reading_id', '3': 3, '4': 1, '5': 9, '10': 'readingId'},
  ],
};

/// Descriptor for `UploadPhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadPhotoRequestDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRQaG90b1JlcXVlc3QSGwoJZmlsZV9uYW1lGAEgASgJUghmaWxlTmFtZRISCgRkYX'
    'RhGAIgASgMUgRkYXRhEh0KCnJlYWRpbmdfaWQYAyABKAlSCXJlYWRpbmdJZA==');

@$core.Deprecated('Use uploadPhotoResponseDescriptor instead')
const UploadPhotoResponse$json = {
  '1': 'UploadPhotoResponse',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'attached', '3': 2, '4': 1, '5': 8, '10': 'attached'},
  ],
};

/// Descriptor for `UploadPhotoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadPhotoResponseDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRQaG90b1Jlc3BvbnNlEhAKA3VybBgBIAEoCVIDdXJsEhoKCGF0dGFjaGVkGAIgAS'
    'gIUghhdHRhY2hlZA==');

@$core.Deprecated('Use downloadReceiptRequestDescriptor instead')
const DownloadReceiptRequest$json = {
  '1': 'DownloadReceiptRequest',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
  ],
};

/// Descriptor for `DownloadReceiptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadReceiptRequestDescriptor = $convert.base64Decode(
    'ChZEb3dubG9hZFJlY2VpcHRSZXF1ZXN0Eh0KCnJlYWRpbmdfaWQYASABKAlSCXJlYWRpbmdJZA'
    '==');

@$core.Deprecated('Use downloadReceiptResponseDescriptor instead')
const DownloadReceiptResponse$json = {
  '1': 'DownloadReceiptResponse',
  '2': [
    {'1': 'pdf_data', '3': 1, '4': 1, '5': 12, '10': 'pdfData'},
  ],
};

/// Descriptor for `DownloadReceiptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadReceiptResponseDescriptor = $convert.base64Decode(
    'ChdEb3dubG9hZFJlY2VpcHRSZXNwb25zZRIZCghwZGZfZGF0YRgBIAEoDFIHcGRmRGF0YQ==');

const $core.Map<$core.String, $core.dynamic> SyncServiceBase$json = {
  '1': 'SyncService',
  '2': [
    {'1': 'PushReadings', '2': '.involt.v1.PushReadingsRequest', '3': '.involt.v1.PushReadingsResponse'},
    {'1': 'PullMetadata', '2': '.involt.v1.PullMetadataRequest', '3': '.involt.v1.PullMetadataResponse'},
    {'1': 'UploadPhoto', '2': '.involt.v1.UploadPhotoRequest', '3': '.involt.v1.UploadPhotoResponse'},
    {'1': 'DownloadReceipt', '2': '.involt.v1.DownloadReceiptRequest', '3': '.involt.v1.DownloadReceiptResponse'},
  ],
};

@$core.Deprecated('Use syncServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SyncServiceBase$messageJson = {
  '.involt.v1.PushReadingsRequest': PushReadingsRequest$json,
  '.involt.v1.Reading': $0.Reading$json,
  '.involt.v1.PushReadingsResponse': PushReadingsResponse$json,
  '.involt.v1.PullMetadataRequest': PullMetadataRequest$json,
  '.involt.v1.PullMetadataResponse': PullMetadataResponse$json,
  '.involt.v1.Community': $0.Community$json,
  '.involt.v1.Sector': $0.Sector$json,
  '.involt.v1.Customer': $0.Customer$json,
  '.involt.v1.AppConfig': $0.AppConfig$json,
  '.involt.v1.Settings': $0.Settings$json,
  '.involt.v1.Period': $0.Period$json,
  '.involt.v1.Operator': $0.Operator$json,
  '.involt.v1.UploadPhotoRequest': UploadPhotoRequest$json,
  '.involt.v1.UploadPhotoResponse': UploadPhotoResponse$json,
  '.involt.v1.DownloadReceiptRequest': DownloadReceiptRequest$json,
  '.involt.v1.DownloadReceiptResponse': DownloadReceiptResponse$json,
};

/// Descriptor for `SyncService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List syncServiceDescriptor = $convert.base64Decode(
    'CgtTeW5jU2VydmljZRJPCgxQdXNoUmVhZGluZ3MSHi5pbnZvbHQudjEuUHVzaFJlYWRpbmdzUm'
    'VxdWVzdBofLmludm9sdC52MS5QdXNoUmVhZGluZ3NSZXNwb25zZRJPCgxQdWxsTWV0YWRhdGES'
    'Hi5pbnZvbHQudjEuUHVsbE1ldGFkYXRhUmVxdWVzdBofLmludm9sdC52MS5QdWxsTWV0YWRhdG'
    'FSZXNwb25zZRJMCgtVcGxvYWRQaG90bxIdLmludm9sdC52MS5VcGxvYWRQaG90b1JlcXVlc3Qa'
    'Hi5pbnZvbHQudjEuVXBsb2FkUGhvdG9SZXNwb25zZRJYCg9Eb3dubG9hZFJlY2VpcHQSIS5pbn'
    'ZvbHQudjEuRG93bmxvYWRSZWNlaXB0UmVxdWVzdBoiLmludm9sdC52MS5Eb3dubG9hZFJlY2Vp'
    'cHRSZXNwb25zZQ==');

