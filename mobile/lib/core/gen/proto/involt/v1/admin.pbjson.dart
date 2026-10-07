//
//  Generated code. Do not modify.
//  source: involt/v1/admin.proto
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

@$core.Deprecated('Use userRoleDescriptor instead')
const UserRole$json = {
  '1': 'UserRole',
  '2': [
    {'1': 'USER_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'USER_ROLE_ADMIN', '2': 1},
    {'1': 'USER_ROLE_SUPERVISOR', '2': 2},
    {'1': 'USER_ROLE_READER', '2': 3},
  ],
};

/// Descriptor for `UserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userRoleDescriptor = $convert.base64Decode(
    'CghVc2VyUm9sZRIZChVVU0VSX1JPTEVfVU5TUEVDSUZJRUQQABITCg9VU0VSX1JPTEVfQURNSU'
    '4QARIYChRVU0VSX1JPTEVfU1VQRVJWSVNPUhACEhQKEFVTRVJfUk9MRV9SRUFERVIQAw==');

@$core.Deprecated('Use upsertSectorRequestDescriptor instead')
const UpsertSectorRequest$json = {
  '1': 'UpsertSectorRequest',
  '2': [
    {'1': 'sector', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Sector', '10': 'sector'},
  ],
};

/// Descriptor for `UpsertSectorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertSectorRequestDescriptor = $convert.base64Decode(
    'ChNVcHNlcnRTZWN0b3JSZXF1ZXN0EikKBnNlY3RvchgBIAEoCzIRLmludm9sdC52MS5TZWN0b3'
    'JSBnNlY3Rvcg==');

@$core.Deprecated('Use upsertSectorResponseDescriptor instead')
const UpsertSectorResponse$json = {
  '1': 'UpsertSectorResponse',
  '2': [
    {'1': 'sector', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Sector', '10': 'sector'},
  ],
};

/// Descriptor for `UpsertSectorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertSectorResponseDescriptor = $convert.base64Decode(
    'ChRVcHNlcnRTZWN0b3JSZXNwb25zZRIpCgZzZWN0b3IYASABKAsyES5pbnZvbHQudjEuU2VjdG'
    '9yUgZzZWN0b3I=');

@$core.Deprecated('Use upsertCommunityRequestDescriptor instead')
const UpsertCommunityRequest$json = {
  '1': 'UpsertCommunityRequest',
  '2': [
    {'1': 'community', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Community', '10': 'community'},
  ],
};

/// Descriptor for `UpsertCommunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCommunityRequestDescriptor = $convert.base64Decode(
    'ChZVcHNlcnRDb21tdW5pdHlSZXF1ZXN0EjIKCWNvbW11bml0eRgBIAEoCzIULmludm9sdC52MS'
    '5Db21tdW5pdHlSCWNvbW11bml0eQ==');

@$core.Deprecated('Use upsertCommunityResponseDescriptor instead')
const UpsertCommunityResponse$json = {
  '1': 'UpsertCommunityResponse',
  '2': [
    {'1': 'community', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Community', '10': 'community'},
  ],
};

/// Descriptor for `UpsertCommunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCommunityResponseDescriptor = $convert.base64Decode(
    'ChdVcHNlcnRDb21tdW5pdHlSZXNwb25zZRIyCgljb21tdW5pdHkYASABKAsyFC5pbnZvbHQudj'
    'EuQ29tbXVuaXR5Ugljb21tdW5pdHk=');

@$core.Deprecated('Use deleteCustomerRequestDescriptor instead')
const DeleteCustomerRequest$json = {
  '1': 'DeleteCustomerRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteCustomerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCustomerRequestDescriptor = $convert.base64Decode(
    'ChVEZWxldGVDdXN0b21lclJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use deleteCustomerResponseDescriptor instead')
const DeleteCustomerResponse$json = {
  '1': 'DeleteCustomerResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteCustomerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCustomerResponseDescriptor = $convert.base64Decode(
    'ChZEZWxldGVDdXN0b21lclJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.involt.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbhIjCgR1c2VyGAIgASgLMg8uaW'
    '52b2x0LnYxLlVzZXJSBHVzZXI=');

@$core.Deprecated('Use getUsersRequestDescriptor instead')
const GetUsersRequest$json = {
  '1': 'GetUsersRequest',
};

/// Descriptor for `GetUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsersRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2Vyc1JlcXVlc3Q=');

@$core.Deprecated('Use getUsersResponseDescriptor instead')
const GetUsersResponse$json = {
  '1': 'GetUsersResponse',
  '2': [
    {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.User', '10': 'users'},
  ],
};

/// Descriptor for `GetUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsersResponseDescriptor = $convert.base64Decode(
    'ChBHZXRVc2Vyc1Jlc3BvbnNlEiUKBXVzZXJzGAEgAygLMg8uaW52b2x0LnYxLlVzZXJSBXVzZX'
    'Jz');

@$core.Deprecated('Use upsertUserRequestDescriptor instead')
const UpsertUserRequest$json = {
  '1': 'UpsertUserRequest',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.User', '10': 'user'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `UpsertUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertUserRequestDescriptor = $convert.base64Decode(
    'ChFVcHNlcnRVc2VyUmVxdWVzdBIjCgR1c2VyGAEgASgLMg8uaW52b2x0LnYxLlVzZXJSBHVzZX'
    'ISGgoIcGFzc3dvcmQYAiABKAlSCHBhc3N3b3Jk');

@$core.Deprecated('Use upsertUserResponseDescriptor instead')
const UpsertUserResponse$json = {
  '1': 'UpsertUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `UpsertUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertUserResponseDescriptor = $convert.base64Decode(
    'ChJVcHNlcnRVc2VyUmVzcG9uc2USIwoEdXNlchgBIAEoCzIPLmludm9sdC52MS5Vc2VyUgR1c2'
    'Vy');

@$core.Deprecated('Use getSectorsRequestDescriptor instead')
const GetSectorsRequest$json = {
  '1': 'GetSectorsRequest',
};

/// Descriptor for `GetSectorsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSectorsRequestDescriptor = $convert.base64Decode(
    'ChFHZXRTZWN0b3JzUmVxdWVzdA==');

@$core.Deprecated('Use getSectorsResponseDescriptor instead')
const GetSectorsResponse$json = {
  '1': 'GetSectorsResponse',
  '2': [
    {'1': 'sectors', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Sector', '10': 'sectors'},
  ],
};

/// Descriptor for `GetSectorsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSectorsResponseDescriptor = $convert.base64Decode(
    'ChJHZXRTZWN0b3JzUmVzcG9uc2USKwoHc2VjdG9ycxgBIAMoCzIRLmludm9sdC52MS5TZWN0b3'
    'JSB3NlY3RvcnM=');

@$core.Deprecated('Use getCommunitiesRequestDescriptor instead')
const GetCommunitiesRequest$json = {
  '1': 'GetCommunitiesRequest',
};

/// Descriptor for `GetCommunitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunitiesRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDb21tdW5pdGllc1JlcXVlc3Q=');

@$core.Deprecated('Use getCommunitiesResponseDescriptor instead')
const GetCommunitiesResponse$json = {
  '1': 'GetCommunitiesResponse',
  '2': [
    {'1': 'communities', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Community', '10': 'communities'},
  ],
};

/// Descriptor for `GetCommunitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunitiesResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDb21tdW5pdGllc1Jlc3BvbnNlEjYKC2NvbW11bml0aWVzGAEgAygLMhQuaW52b2x0Ln'
    'YxLkNvbW11bml0eVILY29tbXVuaXRpZXM=');

@$core.Deprecated('Use getCustomersRequestDescriptor instead')
const GetCustomersRequest$json = {
  '1': 'GetCustomersRequest',
  '2': [
    {'1': 'sector_id', '3': 1, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'search_query', '3': 2, '4': 1, '5': 9, '10': 'searchQuery'},
    {'1': 'page_number', '3': 3, '4': 1, '5': 5, '10': 'pageNumber'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'exclude_period_id', '3': 5, '4': 1, '5': 9, '10': 'excludePeriodId'},
    {'1': 'community_id', '3': 6, '4': 1, '5': 9, '10': 'communityId'},
  ],
};

/// Descriptor for `GetCustomersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCustomersRequestDescriptor = $convert.base64Decode(
    'ChNHZXRDdXN0b21lcnNSZXF1ZXN0EhsKCXNlY3Rvcl9pZBgBIAEoCVIIc2VjdG9ySWQSIQoMc2'
    'VhcmNoX3F1ZXJ5GAIgASgJUgtzZWFyY2hRdWVyeRIfCgtwYWdlX251bWJlchgDIAEoBVIKcGFn'
    'ZU51bWJlchIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXplEioKEWV4Y2x1ZGVfcGVyaW9kX2'
    'lkGAUgASgJUg9leGNsdWRlUGVyaW9kSWQSIQoMY29tbXVuaXR5X2lkGAYgASgJUgtjb21tdW5p'
    'dHlJZA==');

@$core.Deprecated('Use getCustomersResponseDescriptor instead')
const GetCustomersResponse$json = {
  '1': 'GetCustomersResponse',
  '2': [
    {'1': 'customers', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Customer', '10': 'customers'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `GetCustomersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCustomersResponseDescriptor = $convert.base64Decode(
    'ChRHZXRDdXN0b21lcnNSZXNwb25zZRIxCgljdXN0b21lcnMYASADKAsyEy5pbnZvbHQudjEuQ3'
    'VzdG9tZXJSCWN1c3RvbWVycxIfCgt0b3RhbF9jb3VudBgCIAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use getReadingsRequestDescriptor instead')
const GetReadingsRequest$json = {
  '1': 'GetReadingsRequest',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'sector_id', '3': 2, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'period', '3': 3, '4': 1, '5': 9, '10': 'period'},
    {'1': 'page_number', '3': 4, '4': 1, '5': 5, '10': 'pageNumber'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadingsRequestDescriptor = $convert.base64Decode(
    'ChJHZXRSZWFkaW5nc1JlcXVlc3QSHwoLY3VzdG9tZXJfaWQYASABKAlSCmN1c3RvbWVySWQSGw'
    'oJc2VjdG9yX2lkGAIgASgJUghzZWN0b3JJZBIWCgZwZXJpb2QYAyABKAlSBnBlcmlvZBIfCgtw'
    'YWdlX251bWJlchgEIAEoBVIKcGFnZU51bWJlchIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaX'
    'pl');

@$core.Deprecated('Use getReadingsResponseDescriptor instead')
const GetReadingsResponse$json = {
  '1': 'GetReadingsResponse',
  '2': [
    {'1': 'readings', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Reading', '10': 'readings'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `GetReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRSZWFkaW5nc1Jlc3BvbnNlEi4KCHJlYWRpbmdzGAEgAygLMhIuaW52b2x0LnYxLlJlYW'
    'RpbmdSCHJlYWRpbmdzEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor = $convert.base64Decode(
    'ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Settings', '10': 'settings'},
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEi8KCHNldHRpbmdzGAEgASgLMhMuaW52b2x0LnYxLlNldH'
    'RpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Settings', '10': 'settings'},
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSLwoIc2V0dGluZ3MYASABKAsyEy5pbnZvbHQudjEuU2'
    'V0dGluZ3NSCHNldHRpbmdz');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Settings', '10': 'settings'},
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEi8KCHNldHRpbmdzGAEgASgLMhMuaW52b2x0LnYxLl'
    'NldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use upsertCustomerRequestDescriptor instead')
const UpsertCustomerRequest$json = {
  '1': 'UpsertCustomerRequest',
  '2': [
    {'1': 'customer', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Customer', '10': 'customer'},
  ],
};

/// Descriptor for `UpsertCustomerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCustomerRequestDescriptor = $convert.base64Decode(
    'ChVVcHNlcnRDdXN0b21lclJlcXVlc3QSLwoIY3VzdG9tZXIYASABKAsyEy5pbnZvbHQudjEuQ3'
    'VzdG9tZXJSCGN1c3RvbWVy');

@$core.Deprecated('Use upsertCustomerResponseDescriptor instead')
const UpsertCustomerResponse$json = {
  '1': 'UpsertCustomerResponse',
  '2': [
    {'1': 'customer', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Customer', '10': 'customer'},
  ],
};

/// Descriptor for `UpsertCustomerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertCustomerResponseDescriptor = $convert.base64Decode(
    'ChZVcHNlcnRDdXN0b21lclJlc3BvbnNlEi8KCGN1c3RvbWVyGAEgASgLMhMuaW52b2x0LnYxLk'
    'N1c3RvbWVyUghjdXN0b21lcg==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'role', '3': 3, '4': 1, '5': 14, '6': '.involt.v1.UserRole', '10': 'role'},
    {'1': 'assigned_sector_ids', '3': 4, '4': 3, '5': 9, '10': 'assignedSectorIds'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haWwSJwoEcm9sZRgDIA'
    'EoDjITLmludm9sdC52MS5Vc2VyUm9sZVIEcm9sZRIuChNhc3NpZ25lZF9zZWN0b3JfaWRzGAQg'
    'AygJUhFhc3NpZ25lZFNlY3Rvcklkcw==');

@$core.Deprecated('Use getDashboardStatsRequestDescriptor instead')
const GetDashboardStatsRequest$json = {
  '1': 'GetDashboardStatsRequest',
  '2': [
    {'1': 'period', '3': 1, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `GetDashboardStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardStatsRequestDescriptor = $convert.base64Decode(
    'ChhHZXREYXNoYm9hcmRTdGF0c1JlcXVlc3QSFgoGcGVyaW9kGAEgASgJUgZwZXJpb2Q=');

@$core.Deprecated('Use getDashboardStatsResponseDescriptor instead')
const GetDashboardStatsResponse$json = {
  '1': 'GetDashboardStatsResponse',
  '2': [
    {'1': 'total_customers', '3': 1, '4': 1, '5': 5, '10': 'totalCustomers'},
    {'1': 'total_users', '3': 2, '4': 1, '5': 5, '10': 'totalUsers'},
    {'1': 'total_readings_period', '3': 3, '4': 1, '5': 5, '10': 'totalReadingsPeriod'},
    {'1': 'pending_readings_period', '3': 4, '4': 1, '5': 5, '10': 'pendingReadingsPeriod'},
    {'1': 'total_revenue', '3': 5, '4': 1, '5': 1, '10': 'totalRevenue'},
    {'1': 'total_consumption_kwh', '3': 6, '4': 1, '5': 1, '10': 'totalConsumptionKwh'},
    {'1': 'previous_consumption_kwh', '3': 7, '4': 1, '5': 1, '10': 'previousConsumptionKwh'},
    {'1': 'sector_stats', '3': 8, '4': 3, '5': 11, '6': '.involt.v1.SectorStat', '10': 'sectorStats'},
  ],
};

/// Descriptor for `GetDashboardStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardStatsResponseDescriptor = $convert.base64Decode(
    'ChlHZXREYXNoYm9hcmRTdGF0c1Jlc3BvbnNlEicKD3RvdGFsX2N1c3RvbWVycxgBIAEoBVIOdG'
    '90YWxDdXN0b21lcnMSHwoLdG90YWxfdXNlcnMYAiABKAVSCnRvdGFsVXNlcnMSMgoVdG90YWxf'
    'cmVhZGluZ3NfcGVyaW9kGAMgASgFUhN0b3RhbFJlYWRpbmdzUGVyaW9kEjYKF3BlbmRpbmdfcm'
    'VhZGluZ3NfcGVyaW9kGAQgASgFUhVwZW5kaW5nUmVhZGluZ3NQZXJpb2QSIwoNdG90YWxfcmV2'
    'ZW51ZRgFIAEoAVIMdG90YWxSZXZlbnVlEjIKFXRvdGFsX2NvbnN1bXB0aW9uX2t3aBgGIAEoAV'
    'ITdG90YWxDb25zdW1wdGlvbkt3aBI4ChhwcmV2aW91c19jb25zdW1wdGlvbl9rd2gYByABKAFS'
    'FnByZXZpb3VzQ29uc3VtcHRpb25Ld2gSOAoMc2VjdG9yX3N0YXRzGAggAygLMhUuaW52b2x0Ln'
    'YxLlNlY3RvclN0YXRSC3NlY3RvclN0YXRz');

@$core.Deprecated('Use sectorStatDescriptor instead')
const SectorStat$json = {
  '1': 'SectorStat',
  '2': [
    {'1': 'sector_id', '3': 1, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'sector_name', '3': 2, '4': 1, '5': 9, '10': 'sectorName'},
    {'1': 'registered_count', '3': 3, '4': 1, '5': 5, '10': 'registeredCount'},
    {'1': 'total_count', '3': 4, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'progress_percentage', '3': 5, '4': 1, '5': 5, '10': 'progressPercentage'},
    {'1': 'total_consumption', '3': 6, '4': 1, '5': 1, '10': 'totalConsumption'},
  ],
};

/// Descriptor for `SectorStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectorStatDescriptor = $convert.base64Decode(
    'CgpTZWN0b3JTdGF0EhsKCXNlY3Rvcl9pZBgBIAEoCVIIc2VjdG9ySWQSHwoLc2VjdG9yX25hbW'
    'UYAiABKAlSCnNlY3Rvck5hbWUSKQoQcmVnaXN0ZXJlZF9jb3VudBgDIAEoBVIPcmVnaXN0ZXJl'
    'ZENvdW50Eh8KC3RvdGFsX2NvdW50GAQgASgFUgp0b3RhbENvdW50Ei8KE3Byb2dyZXNzX3Blcm'
    'NlbnRhZ2UYBSABKAVSEnByb2dyZXNzUGVyY2VudGFnZRIrChF0b3RhbF9jb25zdW1wdGlvbhgG'
    'IAEoAVIQdG90YWxDb25zdW1wdGlvbg==');

@$core.Deprecated('Use listPeriodsRequestDescriptor instead')
const ListPeriodsRequest$json = {
  '1': 'ListPeriodsRequest',
};

/// Descriptor for `ListPeriodsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeriodsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0UGVyaW9kc1JlcXVlc3Q=');

@$core.Deprecated('Use listPeriodsResponseDescriptor instead')
const ListPeriodsResponse$json = {
  '1': 'ListPeriodsResponse',
  '2': [
    {'1': 'periods', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Period', '10': 'periods'},
  ],
};

/// Descriptor for `ListPeriodsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeriodsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0UGVyaW9kc1Jlc3BvbnNlEisKB3BlcmlvZHMYASADKAsyES5pbnZvbHQudjEuUGVyaW'
    '9kUgdwZXJpb2Rz');

@$core.Deprecated('Use getPeriodStatsRequestDescriptor instead')
const GetPeriodStatsRequest$json = {
  '1': 'GetPeriodStatsRequest',
  '2': [
    {'1': 'period_id', '3': 1, '4': 1, '5': 9, '10': 'periodId'},
  ],
};

/// Descriptor for `GetPeriodStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPeriodStatsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRQZXJpb2RTdGF0c1JlcXVlc3QSGwoJcGVyaW9kX2lkGAEgASgJUghwZXJpb2RJZA==');

@$core.Deprecated('Use getPeriodStatsResponseDescriptor instead')
const GetPeriodStatsResponse$json = {
  '1': 'GetPeriodStatsResponse',
  '2': [
    {'1': 'total_customers', '3': 1, '4': 1, '5': 5, '10': 'totalCustomers'},
    {'1': 'readings_captured', '3': 2, '4': 1, '5': 5, '10': 'readingsCaptured'},
    {'1': 'missing_readings', '3': 3, '4': 1, '5': 5, '10': 'missingReadings'},
    {'1': 'missing_customers', '3': 4, '4': 3, '5': 11, '6': '.involt.v1.MissingCustomer', '10': 'missingCustomers'},
  ],
};

/// Descriptor for `GetPeriodStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPeriodStatsResponseDescriptor = $convert.base64Decode(
    'ChZHZXRQZXJpb2RTdGF0c1Jlc3BvbnNlEicKD3RvdGFsX2N1c3RvbWVycxgBIAEoBVIOdG90YW'
    'xDdXN0b21lcnMSKwoRcmVhZGluZ3NfY2FwdHVyZWQYAiABKAVSEHJlYWRpbmdzQ2FwdHVyZWQS'
    'KQoQbWlzc2luZ19yZWFkaW5ncxgDIAEoBVIPbWlzc2luZ1JlYWRpbmdzEkcKEW1pc3NpbmdfY3'
    'VzdG9tZXJzGAQgAygLMhouaW52b2x0LnYxLk1pc3NpbmdDdXN0b21lclIQbWlzc2luZ0N1c3Rv'
    'bWVycw==');

@$core.Deprecated('Use missingCustomerDescriptor instead')
const MissingCustomer$json = {
  '1': 'MissingCustomer',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'sector_name', '3': 4, '4': 1, '5': 9, '10': 'sectorName'},
    {'1': 'supervisor', '3': 5, '4': 1, '5': 9, '10': 'supervisor'},
  ],
};

/// Descriptor for `MissingCustomer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List missingCustomerDescriptor = $convert.base64Decode(
    'Cg9NaXNzaW5nQ3VzdG9tZXISDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEg'
    'oEY29kZRgDIAEoCVIEY29kZRIfCgtzZWN0b3JfbmFtZRgEIAEoCVIKc2VjdG9yTmFtZRIeCgpz'
    'dXBlcnZpc29yGAUgASgJUgpzdXBlcnZpc29y');

@$core.Deprecated('Use openPeriodRequestDescriptor instead')
const OpenPeriodRequest$json = {
  '1': 'OpenPeriodRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'start_date', '3': 2, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 3, '4': 1, '5': 9, '10': 'endDate'},
  ],
};

/// Descriptor for `OpenPeriodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPeriodRequestDescriptor = $convert.base64Decode(
    'ChFPcGVuUGVyaW9kUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSHQoKc3RhcnRfZGF0ZRgCIAEoCV'
    'IJc3RhcnREYXRlEhkKCGVuZF9kYXRlGAMgASgJUgdlbmREYXRl');

@$core.Deprecated('Use openPeriodResponseDescriptor instead')
const OpenPeriodResponse$json = {
  '1': 'OpenPeriodResponse',
  '2': [
    {'1': 'period', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Period', '10': 'period'},
  ],
};

/// Descriptor for `OpenPeriodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPeriodResponseDescriptor = $convert.base64Decode(
    'ChJPcGVuUGVyaW9kUmVzcG9uc2USKQoGcGVyaW9kGAEgASgLMhEuaW52b2x0LnYxLlBlcmlvZF'
    'IGcGVyaW9k');

@$core.Deprecated('Use closePeriodRequestDescriptor instead')
const ClosePeriodRequest$json = {
  '1': 'ClosePeriodRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'open_next', '3': 2, '4': 1, '5': 8, '10': 'openNext'},
  ],
};

/// Descriptor for `ClosePeriodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closePeriodRequestDescriptor = $convert.base64Decode(
    'ChJDbG9zZVBlcmlvZFJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhsKCW9wZW5fbmV4dBgCIAEoCF'
    'IIb3Blbk5leHQ=');

@$core.Deprecated('Use closePeriodResponseDescriptor instead')
const ClosePeriodResponse$json = {
  '1': 'ClosePeriodResponse',
  '2': [
    {'1': 'closed_period', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Period', '10': 'closedPeriod'},
    {'1': 'next_period', '3': 2, '4': 1, '5': 11, '6': '.involt.v1.Period', '10': 'nextPeriod'},
  ],
};

/// Descriptor for `ClosePeriodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closePeriodResponseDescriptor = $convert.base64Decode(
    'ChNDbG9zZVBlcmlvZFJlc3BvbnNlEjYKDWNsb3NlZF9wZXJpb2QYASABKAsyES5pbnZvbHQudj'
    'EuUGVyaW9kUgxjbG9zZWRQZXJpb2QSMgoLbmV4dF9wZXJpb2QYAiABKAsyES5pbnZvbHQudjEu'
    'UGVyaW9kUgpuZXh0UGVyaW9k');

@$core.Deprecated('Use togglePaymentStatusRequestDescriptor instead')
const TogglePaymentStatusRequest$json = {
  '1': 'TogglePaymentStatusRequest',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'is_paid', '3': 2, '4': 1, '5': 8, '10': 'isPaid'},
    {'1': 'customer_id', '3': 3, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'period', '3': 4, '4': 1, '5': 9, '10': 'period'},
    {'1': 'total_to_pay', '3': 5, '4': 1, '5': 1, '10': 'totalToPay'},
    {'1': 'observation', '3': 6, '4': 1, '5': 9, '10': 'observation'},
  ],
};

/// Descriptor for `TogglePaymentStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List togglePaymentStatusRequestDescriptor = $convert.base64Decode(
    'ChpUb2dnbGVQYXltZW50U3RhdHVzUmVxdWVzdBIdCgpyZWFkaW5nX2lkGAEgASgJUglyZWFkaW'
    '5nSWQSFwoHaXNfcGFpZBgCIAEoCFIGaXNQYWlkEh8KC2N1c3RvbWVyX2lkGAMgASgJUgpjdXN0'
    'b21lcklkEhYKBnBlcmlvZBgEIAEoCVIGcGVyaW9kEiAKDHRvdGFsX3RvX3BheRgFIAEoAVIKdG'
    '90YWxUb1BheRIgCgtvYnNlcnZhdGlvbhgGIAEoCVILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use togglePaymentStatusResponseDescriptor instead')
const TogglePaymentStatusResponse$json = {
  '1': 'TogglePaymentStatusResponse',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'is_paid', '3': 2, '4': 1, '5': 8, '10': 'isPaid'},
  ],
};

/// Descriptor for `TogglePaymentStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List togglePaymentStatusResponseDescriptor = $convert.base64Decode(
    'ChtUb2dnbGVQYXltZW50U3RhdHVzUmVzcG9uc2USHQoKcmVhZGluZ19pZBgBIAEoCVIJcmVhZG'
    'luZ0lkEhcKB2lzX3BhaWQYAiABKAhSBmlzUGFpZA==');

@$core.Deprecated('Use getCollectionsRequestDescriptor instead')
const GetCollectionsRequest$json = {
  '1': 'GetCollectionsRequest',
  '2': [
    {'1': 'sector_id', '3': 1, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'periods', '3': 2, '4': 3, '5': 9, '10': 'periods'},
  ],
};

/// Descriptor for `GetCollectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDb2xsZWN0aW9uc1JlcXVlc3QSGwoJc2VjdG9yX2lkGAEgASgJUghzZWN0b3JJZBIYCg'
    'dwZXJpb2RzGAIgAygJUgdwZXJpb2Rz');

@$core.Deprecated('Use getCollectionsResponseDescriptor instead')
const GetCollectionsResponse$json = {
  '1': 'GetCollectionsResponse',
  '2': [
    {'1': 'readings', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Reading', '10': 'readings'},
    {'1': 'customers', '3': 2, '4': 3, '5': 11, '6': '.involt.v1.CollectionCustomer', '10': 'customers'},
  ],
};

/// Descriptor for `GetCollectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionsResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDb2xsZWN0aW9uc1Jlc3BvbnNlEi4KCHJlYWRpbmdzGAEgAygLMhIuaW52b2x0LnYxLl'
    'JlYWRpbmdSCHJlYWRpbmdzEjsKCWN1c3RvbWVycxgCIAMoCzIdLmludm9sdC52MS5Db2xsZWN0'
    'aW9uQ3VzdG9tZXJSCWN1c3RvbWVycw==');

@$core.Deprecated('Use collectionCustomerDescriptor instead')
const CollectionCustomer$json = {
  '1': 'CollectionCustomer',
  '2': [
    {'1': 'customer', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Customer', '10': 'customer'},
    {'1': 'readings', '3': 2, '4': 3, '5': 11, '6': '.involt.v1.Reading', '10': 'readings'},
  ],
};

/// Descriptor for `CollectionCustomer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionCustomerDescriptor = $convert.base64Decode(
    'ChJDb2xsZWN0aW9uQ3VzdG9tZXISLwoIY3VzdG9tZXIYASABKAsyEy5pbnZvbHQudjEuQ3VzdG'
    '9tZXJSCGN1c3RvbWVyEi4KCHJlYWRpbmdzGAIgAygLMhIuaW52b2x0LnYxLlJlYWRpbmdSCHJl'
    'YWRpbmdz');

@$core.Deprecated('Use deleteSectorRequestDescriptor instead')
const DeleteSectorRequest$json = {
  '1': 'DeleteSectorRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteSectorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSectorRequestDescriptor = $convert.base64Decode(
    'ChNEZWxldGVTZWN0b3JSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteSectorResponseDescriptor instead')
const DeleteSectorResponse$json = {
  '1': 'DeleteSectorResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteSectorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSectorResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVTZWN0b3JSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use deleteCommunityRequestDescriptor instead')
const DeleteCommunityRequest$json = {
  '1': 'DeleteCommunityRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteCommunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCommunityRequestDescriptor = $convert.base64Decode(
    'ChZEZWxldGVDb21tdW5pdHlSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteCommunityResponseDescriptor instead')
const DeleteCommunityResponse$json = {
  '1': 'DeleteCommunityResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteCommunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteCommunityResponseDescriptor = $convert.base64Decode(
    'ChdEZWxldGVDb21tdW5pdHlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

const $core.Map<$core.String, $core.dynamic> AdminServiceBase$json = {
  '1': 'AdminService',
  '2': [
    {'1': 'Login', '2': '.involt.v1.LoginRequest', '3': '.involt.v1.LoginResponse'},
    {'1': 'GetUsers', '2': '.involt.v1.GetUsersRequest', '3': '.involt.v1.GetUsersResponse'},
    {'1': 'UpsertUser', '2': '.involt.v1.UpsertUserRequest', '3': '.involt.v1.UpsertUserResponse'},
    {'1': 'GetSectors', '2': '.involt.v1.GetSectorsRequest', '3': '.involt.v1.GetSectorsResponse'},
    {'1': 'GetCommunities', '2': '.involt.v1.GetCommunitiesRequest', '3': '.involt.v1.GetCommunitiesResponse'},
    {'1': 'GetCustomers', '2': '.involt.v1.GetCustomersRequest', '3': '.involt.v1.GetCustomersResponse'},
    {'1': 'GetReadings', '2': '.involt.v1.GetReadingsRequest', '3': '.involt.v1.GetReadingsResponse'},
    {'1': 'GetSettings', '2': '.involt.v1.GetSettingsRequest', '3': '.involt.v1.GetSettingsResponse'},
    {'1': 'UpdateSettings', '2': '.involt.v1.UpdateSettingsRequest', '3': '.involt.v1.UpdateSettingsResponse'},
    {'1': 'UpsertCustomer', '2': '.involt.v1.UpsertCustomerRequest', '3': '.involt.v1.UpsertCustomerResponse'},
    {'1': 'DeleteCustomer', '2': '.involt.v1.DeleteCustomerRequest', '3': '.involt.v1.DeleteCustomerResponse'},
    {'1': 'GetDashboardStats', '2': '.involt.v1.GetDashboardStatsRequest', '3': '.involt.v1.GetDashboardStatsResponse'},
    {'1': 'ListPeriods', '2': '.involt.v1.ListPeriodsRequest', '3': '.involt.v1.ListPeriodsResponse'},
    {'1': 'GetPeriodStats', '2': '.involt.v1.GetPeriodStatsRequest', '3': '.involt.v1.GetPeriodStatsResponse'},
    {'1': 'OpenPeriod', '2': '.involt.v1.OpenPeriodRequest', '3': '.involt.v1.OpenPeriodResponse'},
    {'1': 'ClosePeriod', '2': '.involt.v1.ClosePeriodRequest', '3': '.involt.v1.ClosePeriodResponse'},
    {'1': 'UpsertSector', '2': '.involt.v1.UpsertSectorRequest', '3': '.involt.v1.UpsertSectorResponse'},
    {'1': 'DeleteSector', '2': '.involt.v1.DeleteSectorRequest', '3': '.involt.v1.DeleteSectorResponse'},
    {'1': 'UpsertCommunity', '2': '.involt.v1.UpsertCommunityRequest', '3': '.involt.v1.UpsertCommunityResponse'},
    {'1': 'DeleteCommunity', '2': '.involt.v1.DeleteCommunityRequest', '3': '.involt.v1.DeleteCommunityResponse'},
    {'1': 'TogglePaymentStatus', '2': '.involt.v1.TogglePaymentStatusRequest', '3': '.involt.v1.TogglePaymentStatusResponse'},
    {'1': 'GetCollections', '2': '.involt.v1.GetCollectionsRequest', '3': '.involt.v1.GetCollectionsResponse'},
  ],
};

@$core.Deprecated('Use adminServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> AdminServiceBase$messageJson = {
  '.involt.v1.LoginRequest': LoginRequest$json,
  '.involt.v1.LoginResponse': LoginResponse$json,
  '.involt.v1.User': User$json,
  '.involt.v1.GetUsersRequest': GetUsersRequest$json,
  '.involt.v1.GetUsersResponse': GetUsersResponse$json,
  '.involt.v1.UpsertUserRequest': UpsertUserRequest$json,
  '.involt.v1.UpsertUserResponse': UpsertUserResponse$json,
  '.involt.v1.GetSectorsRequest': GetSectorsRequest$json,
  '.involt.v1.GetSectorsResponse': GetSectorsResponse$json,
  '.involt.v1.Sector': $0.Sector$json,
  '.involt.v1.GetCommunitiesRequest': GetCommunitiesRequest$json,
  '.involt.v1.GetCommunitiesResponse': GetCommunitiesResponse$json,
  '.involt.v1.Community': $0.Community$json,
  '.involt.v1.GetCustomersRequest': GetCustomersRequest$json,
  '.involt.v1.GetCustomersResponse': GetCustomersResponse$json,
  '.involt.v1.Customer': $0.Customer$json,
  '.involt.v1.GetReadingsRequest': GetReadingsRequest$json,
  '.involt.v1.GetReadingsResponse': GetReadingsResponse$json,
  '.involt.v1.Reading': $0.Reading$json,
  '.involt.v1.GetSettingsRequest': GetSettingsRequest$json,
  '.involt.v1.GetSettingsResponse': GetSettingsResponse$json,
  '.involt.v1.Settings': $0.Settings$json,
  '.involt.v1.UpdateSettingsRequest': UpdateSettingsRequest$json,
  '.involt.v1.UpdateSettingsResponse': UpdateSettingsResponse$json,
  '.involt.v1.UpsertCustomerRequest': UpsertCustomerRequest$json,
  '.involt.v1.UpsertCustomerResponse': UpsertCustomerResponse$json,
  '.involt.v1.DeleteCustomerRequest': DeleteCustomerRequest$json,
  '.involt.v1.DeleteCustomerResponse': DeleteCustomerResponse$json,
  '.involt.v1.GetDashboardStatsRequest': GetDashboardStatsRequest$json,
  '.involt.v1.GetDashboardStatsResponse': GetDashboardStatsResponse$json,
  '.involt.v1.SectorStat': SectorStat$json,
  '.involt.v1.ListPeriodsRequest': ListPeriodsRequest$json,
  '.involt.v1.ListPeriodsResponse': ListPeriodsResponse$json,
  '.involt.v1.Period': $0.Period$json,
  '.involt.v1.GetPeriodStatsRequest': GetPeriodStatsRequest$json,
  '.involt.v1.GetPeriodStatsResponse': GetPeriodStatsResponse$json,
  '.involt.v1.MissingCustomer': MissingCustomer$json,
  '.involt.v1.OpenPeriodRequest': OpenPeriodRequest$json,
  '.involt.v1.OpenPeriodResponse': OpenPeriodResponse$json,
  '.involt.v1.ClosePeriodRequest': ClosePeriodRequest$json,
  '.involt.v1.ClosePeriodResponse': ClosePeriodResponse$json,
  '.involt.v1.UpsertSectorRequest': UpsertSectorRequest$json,
  '.involt.v1.UpsertSectorResponse': UpsertSectorResponse$json,
  '.involt.v1.DeleteSectorRequest': DeleteSectorRequest$json,
  '.involt.v1.DeleteSectorResponse': DeleteSectorResponse$json,
  '.involt.v1.UpsertCommunityRequest': UpsertCommunityRequest$json,
  '.involt.v1.UpsertCommunityResponse': UpsertCommunityResponse$json,
  '.involt.v1.DeleteCommunityRequest': DeleteCommunityRequest$json,
  '.involt.v1.DeleteCommunityResponse': DeleteCommunityResponse$json,
  '.involt.v1.TogglePaymentStatusRequest': TogglePaymentStatusRequest$json,
  '.involt.v1.TogglePaymentStatusResponse': TogglePaymentStatusResponse$json,
  '.involt.v1.GetCollectionsRequest': GetCollectionsRequest$json,
  '.involt.v1.GetCollectionsResponse': GetCollectionsResponse$json,
  '.involt.v1.CollectionCustomer': CollectionCustomer$json,
};

/// Descriptor for `AdminService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List adminServiceDescriptor = $convert.base64Decode(
    'CgxBZG1pblNlcnZpY2USOgoFTG9naW4SFy5pbnZvbHQudjEuTG9naW5SZXF1ZXN0GhguaW52b2'
    'x0LnYxLkxvZ2luUmVzcG9uc2USQwoIR2V0VXNlcnMSGi5pbnZvbHQudjEuR2V0VXNlcnNSZXF1'
    'ZXN0GhsuaW52b2x0LnYxLkdldFVzZXJzUmVzcG9uc2USSQoKVXBzZXJ0VXNlchIcLmludm9sdC'
    '52MS5VcHNlcnRVc2VyUmVxdWVzdBodLmludm9sdC52MS5VcHNlcnRVc2VyUmVzcG9uc2USSQoK'
    'R2V0U2VjdG9ycxIcLmludm9sdC52MS5HZXRTZWN0b3JzUmVxdWVzdBodLmludm9sdC52MS5HZX'
    'RTZWN0b3JzUmVzcG9uc2USVQoOR2V0Q29tbXVuaXRpZXMSIC5pbnZvbHQudjEuR2V0Q29tbXVu'
    'aXRpZXNSZXF1ZXN0GiEuaW52b2x0LnYxLkdldENvbW11bml0aWVzUmVzcG9uc2USTwoMR2V0Q3'
    'VzdG9tZXJzEh4uaW52b2x0LnYxLkdldEN1c3RvbWVyc1JlcXVlc3QaHy5pbnZvbHQudjEuR2V0'
    'Q3VzdG9tZXJzUmVzcG9uc2USTAoLR2V0UmVhZGluZ3MSHS5pbnZvbHQudjEuR2V0UmVhZGluZ3'
    'NSZXF1ZXN0Gh4uaW52b2x0LnYxLkdldFJlYWRpbmdzUmVzcG9uc2USTAoLR2V0U2V0dGluZ3MS'
    'HS5pbnZvbHQudjEuR2V0U2V0dGluZ3NSZXF1ZXN0Gh4uaW52b2x0LnYxLkdldFNldHRpbmdzUm'
    'VzcG9uc2USVQoOVXBkYXRlU2V0dGluZ3MSIC5pbnZvbHQudjEuVXBkYXRlU2V0dGluZ3NSZXF1'
    'ZXN0GiEuaW52b2x0LnYxLlVwZGF0ZVNldHRpbmdzUmVzcG9uc2USVQoOVXBzZXJ0Q3VzdG9tZX'
    'ISIC5pbnZvbHQudjEuVXBzZXJ0Q3VzdG9tZXJSZXF1ZXN0GiEuaW52b2x0LnYxLlVwc2VydEN1'
    'c3RvbWVyUmVzcG9uc2USVQoORGVsZXRlQ3VzdG9tZXISIC5pbnZvbHQudjEuRGVsZXRlQ3VzdG'
    '9tZXJSZXF1ZXN0GiEuaW52b2x0LnYxLkRlbGV0ZUN1c3RvbWVyUmVzcG9uc2USXgoRR2V0RGFz'
    'aGJvYXJkU3RhdHMSIy5pbnZvbHQudjEuR2V0RGFzaGJvYXJkU3RhdHNSZXF1ZXN0GiQuaW52b2'
    'x0LnYxLkdldERhc2hib2FyZFN0YXRzUmVzcG9uc2USTAoLTGlzdFBlcmlvZHMSHS5pbnZvbHQu'
    'djEuTGlzdFBlcmlvZHNSZXF1ZXN0Gh4uaW52b2x0LnYxLkxpc3RQZXJpb2RzUmVzcG9uc2USVQ'
    'oOR2V0UGVyaW9kU3RhdHMSIC5pbnZvbHQudjEuR2V0UGVyaW9kU3RhdHNSZXF1ZXN0GiEuaW52'
    'b2x0LnYxLkdldFBlcmlvZFN0YXRzUmVzcG9uc2USSQoKT3BlblBlcmlvZBIcLmludm9sdC52MS'
    '5PcGVuUGVyaW9kUmVxdWVzdBodLmludm9sdC52MS5PcGVuUGVyaW9kUmVzcG9uc2USTAoLQ2xv'
    'c2VQZXJpb2QSHS5pbnZvbHQudjEuQ2xvc2VQZXJpb2RSZXF1ZXN0Gh4uaW52b2x0LnYxLkNsb3'
    'NlUGVyaW9kUmVzcG9uc2USTwoMVXBzZXJ0U2VjdG9yEh4uaW52b2x0LnYxLlVwc2VydFNlY3Rv'
    'clJlcXVlc3QaHy5pbnZvbHQudjEuVXBzZXJ0U2VjdG9yUmVzcG9uc2USTwoMRGVsZXRlU2VjdG'
    '9yEh4uaW52b2x0LnYxLkRlbGV0ZVNlY3RvclJlcXVlc3QaHy5pbnZvbHQudjEuRGVsZXRlU2Vj'
    'dG9yUmVzcG9uc2USWAoPVXBzZXJ0Q29tbXVuaXR5EiEuaW52b2x0LnYxLlVwc2VydENvbW11bm'
    'l0eVJlcXVlc3QaIi5pbnZvbHQudjEuVXBzZXJ0Q29tbXVuaXR5UmVzcG9uc2USWAoPRGVsZXRl'
    'Q29tbXVuaXR5EiEuaW52b2x0LnYxLkRlbGV0ZUNvbW11bml0eVJlcXVlc3QaIi5pbnZvbHQudj'
    'EuRGVsZXRlQ29tbXVuaXR5UmVzcG9uc2USZAoTVG9nZ2xlUGF5bWVudFN0YXR1cxIlLmludm9s'
    'dC52MS5Ub2dnbGVQYXltZW50U3RhdHVzUmVxdWVzdBomLmludm9sdC52MS5Ub2dnbGVQYXltZW'
    '50U3RhdHVzUmVzcG9uc2USVQoOR2V0Q29sbGVjdGlvbnMSIC5pbnZvbHQudjEuR2V0Q29sbGVj'
    'dGlvbnNSZXF1ZXN0GiEuaW52b2x0LnYxLkdldENvbGxlY3Rpb25zUmVzcG9uc2U=');

