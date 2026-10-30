//
//  Generated code. Do not modify.
//  source: involt/v1/models.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use connectionTypeDescriptor instead')
const ConnectionType$json = {
  '1': 'ConnectionType',
  '2': [
    {'1': 'CONNECTION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CONNECTION_TYPE_MONOFASICA', '2': 1},
    {'1': 'CONNECTION_TYPE_TRIFASICA', '2': 2},
  ],
};

/// Descriptor for `ConnectionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionTypeDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0aW9uVHlwZRIfChtDT05ORUNUSU9OX1RZUEVfVU5TUEVDSUZJRUQQABIeChpDT0'
    '5ORUNUSU9OX1RZUEVfTU9OT0ZBU0lDQRABEh0KGUNPTk5FQ1RJT05fVFlQRV9UUklGQVNJQ0EQ'
    'Ag==');

@$core.Deprecated('Use serviceStatusDescriptor instead')
const ServiceStatus$json = {
  '1': 'ServiceStatus',
  '2': [
    {'1': 'SERVICE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SERVICE_STATUS_ACTIVE', '2': 1},
    {'1': 'SERVICE_STATUS_TEMPORARY_CUT', '2': 2},
    {'1': 'SERVICE_STATUS_NO_POWER', '2': 3},
  ],
};

/// Descriptor for `ServiceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serviceStatusDescriptor = $convert.base64Decode(
    'Cg1TZXJ2aWNlU3RhdHVzEh4KGlNFUlZJQ0VfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVU0VSVk'
    'lDRV9TVEFUVVNfQUNUSVZFEAESIAocU0VSVklDRV9TVEFUVVNfVEVNUE9SQVJZX0NVVBACEhsK'
    'F1NFUlZJQ0VfU1RBVFVTX05PX1BPV0VSEAM=');

@$core.Deprecated('Use receiptCopiesDescriptor instead')
const ReceiptCopies$json = {
  '1': 'ReceiptCopies',
  '2': [
    {'1': 'RECEIPT_COPIES_UNSPECIFIED', '2': 0},
    {'1': 'RECEIPT_COPIES_DUPLICATE', '2': 1},
    {'1': 'RECEIPT_COPIES_SINGLE', '2': 2},
  ],
};

/// Descriptor for `ReceiptCopies`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List receiptCopiesDescriptor = $convert.base64Decode(
    'Cg1SZWNlaXB0Q29waWVzEh4KGlJFQ0VJUFRfQ09QSUVTX1VOU1BFQ0lGSUVEEAASHAoYUkVDRU'
    'lQVF9DT1BJRVNfRFVQTElDQVRFEAESGQoVUkVDRUlQVF9DT1BJRVNfU0lOR0xFEAI=');

@$core.Deprecated('Use periodStatusDescriptor instead')
const PeriodStatus$json = {
  '1': 'PeriodStatus',
  '2': [
    {'1': 'PERIOD_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PERIOD_STATUS_OPEN', '2': 1},
    {'1': 'PERIOD_STATUS_CLOSED', '2': 2},
  ],
};

/// Descriptor for `PeriodStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List periodStatusDescriptor = $convert.base64Decode(
    'CgxQZXJpb2RTdGF0dXMSHQoZUEVSSU9EX1NUQVRVU19VTlNQRUNJRklFRBAAEhYKElBFUklPRF'
    '9TVEFUVVNfT1BFThABEhgKFFBFUklPRF9TVEFUVVNfQ0xPU0VEEAI=');

@$core.Deprecated('Use communityDescriptor instead')
const Community$json = {
  '1': 'Community',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'customer_count', '3': 3, '4': 1, '5': 13, '10': 'customerCount'},
  ],
};

/// Descriptor for `Community`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityDescriptor = $convert.base64Decode(
    'CglDb21tdW5pdHkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSJQoOY3VzdG'
    '9tZXJfY291bnQYAyABKA1SDWN1c3RvbWVyQ291bnQ=');

@$core.Deprecated('Use sectorDescriptor instead')
const Sector$json = {
  '1': 'Sector',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'community_id', '3': 2, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Sector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectorDescriptor = $convert.base64Decode(
    'CgZTZWN0b3ISDgoCaWQYASABKAlSAmlkEiEKDGNvbW11bml0eV9pZBgCIAEoCVILY29tbXVuaX'
    'R5SWQSEgoEbmFtZRgDIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use customerDescriptor instead')
const Customer$json = {
  '1': 'Customer',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'community_id', '3': 4, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'sector_id', '3': 5, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'connection_type', '3': 6, '4': 1, '5': 14, '6': '.involt.v1.ConnectionType', '10': 'connectionType'},
    {'1': 'tariff', '3': 7, '4': 1, '5': 1, '10': 'tariff'},
    {'1': 'meter_number', '3': 8, '4': 1, '5': 9, '10': 'meterNumber'},
    {'1': 'latitude', '3': 9, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 10, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'initial_reading', '3': 11, '4': 1, '5': 1, '10': 'initialReading'},
    {'1': 'address', '3': 12, '4': 1, '5': 9, '10': 'address'},
    {'1': 'contract_start', '3': 13, '4': 1, '5': 9, '10': 'contractStart'},
    {'1': 'last_reading_value', '3': 14, '4': 1, '5': 1, '10': 'lastReadingValue'},
    {'1': 'service_status', '3': 15, '4': 1, '5': 14, '6': '.involt.v1.ServiceStatus', '10': 'serviceStatus'},
    {'1': 'service_status_changed_at', '3': 16, '4': 1, '5': 9, '10': 'serviceStatusChangedAt'},
  ],
};

/// Descriptor for `Customer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List customerDescriptor = $convert.base64Decode(
    'CghDdXN0b21lchIOCgJpZBgBIAEoCVICaWQSEgoEY29kZRgCIAEoCVIEY29kZRISCgRuYW1lGA'
    'MgASgJUgRuYW1lEiEKDGNvbW11bml0eV9pZBgEIAEoCVILY29tbXVuaXR5SWQSGwoJc2VjdG9y'
    'X2lkGAUgASgJUghzZWN0b3JJZBJCCg9jb25uZWN0aW9uX3R5cGUYBiABKA4yGS5pbnZvbHQudj'
    'EuQ29ubmVjdGlvblR5cGVSDmNvbm5lY3Rpb25UeXBlEhYKBnRhcmlmZhgHIAEoAVIGdGFyaWZm'
    'EiEKDG1ldGVyX251bWJlchgIIAEoCVILbWV0ZXJOdW1iZXISGgoIbGF0aXR1ZGUYCSABKAFSCG'
    'xhdGl0dWRlEhwKCWxvbmdpdHVkZRgKIAEoAVIJbG9uZ2l0dWRlEicKD2luaXRpYWxfcmVhZGlu'
    'ZxgLIAEoAVIOaW5pdGlhbFJlYWRpbmcSGAoHYWRkcmVzcxgMIAEoCVIHYWRkcmVzcxIlCg5jb2'
    '50cmFjdF9zdGFydBgNIAEoCVINY29udHJhY3RTdGFydBIsChJsYXN0X3JlYWRpbmdfdmFsdWUY'
    'DiABKAFSEGxhc3RSZWFkaW5nVmFsdWUSPwoOc2VydmljZV9zdGF0dXMYDyABKA4yGC5pbnZvbH'
    'QudjEuU2VydmljZVN0YXR1c1INc2VydmljZVN0YXR1cxI5ChlzZXJ2aWNlX3N0YXR1c19jaGFu'
    'Z2VkX2F0GBAgASgJUhZzZXJ2aWNlU3RhdHVzQ2hhbmdlZEF0');

@$core.Deprecated('Use readingDescriptor instead')
const Reading$json = {
  '1': 'Reading',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'customer_id', '3': 2, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'previous_value', '3': 3, '4': 1, '5': 1, '10': 'previousValue'},
    {'1': 'current_value', '3': 4, '4': 1, '5': 1, '10': 'currentValue'},
    {'1': 'consumption', '3': 5, '4': 1, '5': 1, '10': 'consumption'},
    {'1': 'photo_url', '3': 6, '4': 1, '5': 9, '10': 'photoUrl'},
    {'1': 'timestamp', '3': 7, '4': 1, '5': 9, '10': 'timestamp'},
    {'1': 'latitude', '3': 8, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 9, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'cargo_fijo', '3': 10, '4': 1, '5': 1, '10': 'cargoFijo'},
    {'1': 'alumbrado_publico', '3': 11, '4': 1, '5': 1, '10': 'alumbradoPublico'},
    {'1': 'saldo_redondeo', '3': 12, '4': 1, '5': 1, '10': 'saldoRedondeo'},
    {'1': 'total_to_pay', '3': 13, '4': 1, '5': 1, '10': 'totalToPay'},
    {'1': 'period_start', '3': 14, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 15, '4': 1, '5': 9, '10': 'periodEnd'},
    {'1': 'mantenimiento', '3': 16, '4': 1, '5': 1, '10': 'mantenimiento'},
    {'1': 'adjustment', '3': 17, '4': 1, '5': 1, '10': 'adjustment'},
    {'1': 'subtotal', '3': 18, '4': 1, '5': 1, '10': 'subtotal'},
    {'1': 'round_difference', '3': 19, '4': 1, '5': 1, '10': 'roundDifference'},
    {'1': 'previous_balance', '3': 20, '4': 1, '5': 1, '10': 'previousBalance'},
    {'1': 'overdue_total', '3': 21, '4': 1, '5': 1, '10': 'overdueTotal'},
    {'1': 'expiration_date', '3': 22, '4': 1, '5': 9, '10': 'expirationDate'},
    {'1': 'period', '3': 23, '4': 1, '5': 9, '10': 'period'},
    {'1': 'observation', '3': 24, '4': 1, '5': 9, '10': 'observation'},
    {'1': 'customer_name', '3': 25, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'is_paid', '3': 26, '4': 1, '5': 8, '10': 'isPaid'},
  ],
};

/// Descriptor for `Reading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readingDescriptor = $convert.base64Decode(
    'CgdSZWFkaW5nEg4KAmlkGAEgASgJUgJpZBIfCgtjdXN0b21lcl9pZBgCIAEoCVIKY3VzdG9tZX'
    'JJZBIlCg5wcmV2aW91c192YWx1ZRgDIAEoAVINcHJldmlvdXNWYWx1ZRIjCg1jdXJyZW50X3Zh'
    'bHVlGAQgASgBUgxjdXJyZW50VmFsdWUSIAoLY29uc3VtcHRpb24YBSABKAFSC2NvbnN1bXB0aW'
    '9uEhsKCXBob3RvX3VybBgGIAEoCVIIcGhvdG9VcmwSHAoJdGltZXN0YW1wGAcgASgJUgl0aW1l'
    'c3RhbXASGgoIbGF0aXR1ZGUYCCABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgJIAEoAVIJbG'
    '9uZ2l0dWRlEh0KCmNhcmdvX2Zpam8YCiABKAFSCWNhcmdvRmlqbxIrChFhbHVtYnJhZG9fcHVi'
    'bGljbxgLIAEoAVIQYWx1bWJyYWRvUHVibGljbxIlCg5zYWxkb19yZWRvbmRlbxgMIAEoAVINc2'
    'FsZG9SZWRvbmRlbxIgCgx0b3RhbF90b19wYXkYDSABKAFSCnRvdGFsVG9QYXkSIQoMcGVyaW9k'
    'X3N0YXJ0GA4gASgJUgtwZXJpb2RTdGFydBIdCgpwZXJpb2RfZW5kGA8gASgJUglwZXJpb2RFbm'
    'QSJAoNbWFudGVuaW1pZW50bxgQIAEoAVINbWFudGVuaW1pZW50bxIeCgphZGp1c3RtZW50GBEg'
    'ASgBUgphZGp1c3RtZW50EhoKCHN1YnRvdGFsGBIgASgBUghzdWJ0b3RhbBIpChByb3VuZF9kaW'
    'ZmZXJlbmNlGBMgASgBUg9yb3VuZERpZmZlcmVuY2USKQoQcHJldmlvdXNfYmFsYW5jZRgUIAEo'
    'AVIPcHJldmlvdXNCYWxhbmNlEiMKDW92ZXJkdWVfdG90YWwYFSABKAFSDG92ZXJkdWVUb3RhbB'
    'InCg9leHBpcmF0aW9uX2RhdGUYFiABKAlSDmV4cGlyYXRpb25EYXRlEhYKBnBlcmlvZBgXIAEo'
    'CVIGcGVyaW9kEiAKC29ic2VydmF0aW9uGBggASgJUgtvYnNlcnZhdGlvbhIjCg1jdXN0b21lcl'
    '9uYW1lGBkgASgJUgxjdXN0b21lck5hbWUSFwoHaXNfcGFpZBgaIAEoCFIGaXNQYWlk');

@$core.Deprecated('Use appConfigDescriptor instead')
const AppConfig$json = {
  '1': 'AppConfig',
  '2': [
    {'1': 'map_url_template', '3': 1, '4': 1, '5': 9, '10': 'mapUrlTemplate'},
    {'1': 'map_user_agent', '3': 2, '4': 1, '5': 9, '10': 'mapUserAgent'},
  ],
};

/// Descriptor for `AppConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appConfigDescriptor = $convert.base64Decode(
    'CglBcHBDb25maWcSKAoQbWFwX3VybF90ZW1wbGF0ZRgBIAEoCVIObWFwVXJsVGVtcGxhdGUSJA'
    'oObWFwX3VzZXJfYWdlbnQYAiABKAlSDG1hcFVzZXJBZ2VudA==');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'municipalidad', '3': 1, '4': 1, '5': 9, '10': 'municipalidad'},
    {'1': 'empresa', '3': 2, '4': 1, '5': 9, '10': 'empresa'},
    {'1': 'ruc', '3': 3, '4': 1, '5': 9, '10': 'ruc'},
    {'1': 'direccion', '3': 4, '4': 1, '5': 9, '10': 'direccion'},
    {'1': 'telefono', '3': 5, '4': 1, '5': 9, '10': 'telefono'},
    {'1': 'email', '3': 6, '4': 1, '5': 9, '10': 'email'},
    {'1': 'dias_vencimiento', '3': 7, '4': 1, '5': 5, '10': 'diasVencimiento'},
    {'1': 'tarifa_kwh', '3': 8, '4': 1, '5': 1, '10': 'tarifaKwh'},
    {'1': 'cargo_fijo', '3': 9, '4': 1, '5': 1, '10': 'cargoFijo'},
    {'1': 'alumbrado', '3': 10, '4': 1, '5': 1, '10': 'alumbrado'},
    {'1': 'mantenimiento', '3': 11, '4': 1, '5': 1, '10': 'mantenimiento'},
    {'1': 'igv', '3': 12, '4': 1, '5': 8, '10': 'igv'},
    {'1': 'receipt_copies', '3': 13, '4': 1, '5': 14, '6': '.involt.v1.ReceiptCopies', '10': 'receiptCopies'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxIkCg1tdW5pY2lwYWxpZGFkGAEgASgJUg1tdW5pY2lwYWxpZGFkEhgKB2VtcH'
    'Jlc2EYAiABKAlSB2VtcHJlc2ESEAoDcnVjGAMgASgJUgNydWMSHAoJZGlyZWNjaW9uGAQgASgJ'
    'UglkaXJlY2Npb24SGgoIdGVsZWZvbm8YBSABKAlSCHRlbGVmb25vEhQKBWVtYWlsGAYgASgJUg'
    'VlbWFpbBIpChBkaWFzX3ZlbmNpbWllbnRvGAcgASgFUg9kaWFzVmVuY2ltaWVudG8SHQoKdGFy'
    'aWZhX2t3aBgIIAEoAVIJdGFyaWZhS3doEh0KCmNhcmdvX2Zpam8YCSABKAFSCWNhcmdvRmlqbx'
    'IcCglhbHVtYnJhZG8YCiABKAFSCWFsdW1icmFkbxIkCg1tYW50ZW5pbWllbnRvGAsgASgBUg1t'
    'YW50ZW5pbWllbnRvEhAKA2lndhgMIAEoCFIDaWd2Ej8KDnJlY2VpcHRfY29waWVzGA0gASgOMh'
    'guaW52b2x0LnYxLlJlY2VpcHRDb3BpZXNSDXJlY2VpcHRDb3BpZXM=');

@$core.Deprecated('Use periodDescriptor instead')
const Period$json = {
  '1': 'Period',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'start_date', '3': 2, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 3, '4': 1, '5': 9, '10': 'endDate'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.involt.v1.PeriodStatus', '10': 'status'},
    {'1': 'is_billing_period', '3': 5, '4': 1, '5': 8, '10': 'isBillingPeriod'},
  ],
};

/// Descriptor for `Period`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List periodDescriptor = $convert.base64Decode(
    'CgZQZXJpb2QSDgoCaWQYASABKAlSAmlkEh0KCnN0YXJ0X2RhdGUYAiABKAlSCXN0YXJ0RGF0ZR'
    'IZCghlbmRfZGF0ZRgDIAEoCVIHZW5kRGF0ZRIvCgZzdGF0dXMYBCABKA4yFy5pbnZvbHQudjEu'
    'UGVyaW9kU3RhdHVzUgZzdGF0dXMSKgoRaXNfYmlsbGluZ19wZXJpb2QYBSABKAhSD2lzQmlsbG'
    'luZ1BlcmlvZA==');

@$core.Deprecated('Use operatorDescriptor instead')
const Operator$json = {
  '1': 'Operator',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password_hash', '3': 3, '4': 1, '5': 9, '10': 'passwordHash'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `Operator`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operatorDescriptor = $convert.base64Decode(
    'CghPcGVyYXRvchIOCgJpZBgBIAEoCVICaWQSFAoFZW1haWwYAiABKAlSBWVtYWlsEiMKDXBhc3'
    'N3b3JkX2hhc2gYAyABKAlSDHBhc3N3b3JkSGFzaBISCgRyb2xlGAQgASgJUgRyb2xl');

