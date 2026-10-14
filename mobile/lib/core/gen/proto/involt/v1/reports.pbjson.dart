//
//  Generated code. Do not modify.
//  source: involt/v1/reports.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use agingBucketDescriptor instead')
const AgingBucket$json = {
  '1': 'AgingBucket',
  '2': [
    {'1': 'AGING_BUCKET_UNSPECIFIED', '2': 0},
    {'1': 'AGING_BUCKET_CURRENT', '2': 1},
    {'1': 'AGING_BUCKET_1_30', '2': 2},
    {'1': 'AGING_BUCKET_31_60', '2': 3},
    {'1': 'AGING_BUCKET_61_90', '2': 4},
    {'1': 'AGING_BUCKET_OVER_90', '2': 5},
  ],
};

/// Descriptor for `AgingBucket`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agingBucketDescriptor = $convert.base64Decode(
    'CgtBZ2luZ0J1Y2tldBIcChhBR0lOR19CVUNLRVRfVU5TUEVDSUZJRUQQABIYChRBR0lOR19CVU'
    'NLRVRfQ1VSUkVOVBABEhUKEUFHSU5HX0JVQ0tFVF8xXzMwEAISFgoSQUdJTkdfQlVDS0VUXzMx'
    'XzYwEAMSFgoSQUdJTkdfQlVDS0VUXzYxXzkwEAQSGAoUQUdJTkdfQlVDS0VUX09WRVJfOTAQBQ'
    '==');

@$core.Deprecated('Use agingTotalDescriptor instead')
const AgingTotal$json = {
  '1': 'AgingTotal',
  '2': [
    {'1': 'bucket', '3': 1, '4': 1, '5': 14, '6': '.involt.v1.AgingBucket', '10': 'bucket'},
    {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'receipts', '3': 3, '4': 1, '5': 5, '10': 'receipts'},
    {'1': 'customers', '3': 4, '4': 1, '5': 5, '10': 'customers'},
  ],
};

/// Descriptor for `AgingTotal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agingTotalDescriptor = $convert.base64Decode(
    'CgpBZ2luZ1RvdGFsEi4KBmJ1Y2tldBgBIAEoDjIWLmludm9sdC52MS5BZ2luZ0J1Y2tldFIGYn'
    'Vja2V0EhYKBmFtb3VudBgCIAEoAVIGYW1vdW50EhoKCHJlY2VpcHRzGAMgASgFUghyZWNlaXB0'
    'cxIcCgljdXN0b21lcnMYBCABKAVSCWN1c3RvbWVycw==');

@$core.Deprecated('Use sectorCollectionSummaryDescriptor instead')
const SectorCollectionSummary$json = {
  '1': 'SectorCollectionSummary',
  '2': [
    {'1': 'sector_id', '3': 1, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'sector_name', '3': 2, '4': 1, '5': 9, '10': 'sectorName'},
    {'1': 'community_id', '3': 3, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'community_name', '3': 4, '4': 1, '5': 9, '10': 'communityName'},
    {'1': 'billed', '3': 5, '4': 1, '5': 1, '10': 'billed'},
    {'1': 'collected', '3': 6, '4': 1, '5': 1, '10': 'collected'},
    {'1': 'debt', '3': 7, '4': 1, '5': 1, '10': 'debt'},
    {'1': 'customers', '3': 8, '4': 1, '5': 5, '10': 'customers'},
    {'1': 'debtors', '3': 9, '4': 1, '5': 5, '10': 'debtors'},
  ],
};

/// Descriptor for `SectorCollectionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectorCollectionSummaryDescriptor = $convert.base64Decode(
    'ChdTZWN0b3JDb2xsZWN0aW9uU3VtbWFyeRIbCglzZWN0b3JfaWQYASABKAlSCHNlY3RvcklkEh'
    '8KC3NlY3Rvcl9uYW1lGAIgASgJUgpzZWN0b3JOYW1lEiEKDGNvbW11bml0eV9pZBgDIAEoCVIL'
    'Y29tbXVuaXR5SWQSJQoOY29tbXVuaXR5X25hbWUYBCABKAlSDWNvbW11bml0eU5hbWUSFgoGYm'
    'lsbGVkGAUgASgBUgZiaWxsZWQSHAoJY29sbGVjdGVkGAYgASgBUgljb2xsZWN0ZWQSEgoEZGVi'
    'dBgHIAEoAVIEZGVidBIcCgljdXN0b21lcnMYCCABKAVSCWN1c3RvbWVycxIYCgdkZWJ0b3JzGA'
    'kgASgFUgdkZWJ0b3Jz');

@$core.Deprecated('Use periodCollectionSummaryDescriptor instead')
const PeriodCollectionSummary$json = {
  '1': 'PeriodCollectionSummary',
  '2': [
    {'1': 'period', '3': 1, '4': 1, '5': 9, '10': 'period'},
    {'1': 'billed', '3': 2, '4': 1, '5': 1, '10': 'billed'},
    {'1': 'collected', '3': 3, '4': 1, '5': 1, '10': 'collected'},
    {'1': 'cash_in', '3': 4, '4': 1, '5': 1, '10': 'cashIn'},
  ],
};

/// Descriptor for `PeriodCollectionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List periodCollectionSummaryDescriptor = $convert.base64Decode(
    'ChdQZXJpb2RDb2xsZWN0aW9uU3VtbWFyeRIWCgZwZXJpb2QYASABKAlSBnBlcmlvZBIWCgZiaW'
    'xsZWQYAiABKAFSBmJpbGxlZBIcCgljb2xsZWN0ZWQYAyABKAFSCWNvbGxlY3RlZBIXCgdjYXNo'
    'X2luGAQgASgBUgZjYXNoSW4=');

@$core.Deprecated('Use collectionsDashboardTotalsDescriptor instead')
const CollectionsDashboardTotals$json = {
  '1': 'CollectionsDashboardTotals',
  '2': [
    {'1': 'billed', '3': 1, '4': 1, '5': 1, '10': 'billed'},
    {'1': 'collected', '3': 2, '4': 1, '5': 1, '10': 'collected'},
    {'1': 'total_debt', '3': 3, '4': 1, '5': 1, '10': 'totalDebt'},
    {'1': 'overdue_debt', '3': 4, '4': 1, '5': 1, '10': 'overdueDebt'},
    {'1': 'debtor_count', '3': 5, '4': 1, '5': 5, '10': 'debtorCount'},
    {'1': 'cut_candidates', '3': 6, '4': 1, '5': 5, '10': 'cutCandidates'},
  ],
};

/// Descriptor for `CollectionsDashboardTotals`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionsDashboardTotalsDescriptor = $convert.base64Decode(
    'ChpDb2xsZWN0aW9uc0Rhc2hib2FyZFRvdGFscxIWCgZiaWxsZWQYASABKAFSBmJpbGxlZBIcCg'
    'ljb2xsZWN0ZWQYAiABKAFSCWNvbGxlY3RlZBIdCgp0b3RhbF9kZWJ0GAMgASgBUgl0b3RhbERl'
    'YnQSIQoMb3ZlcmR1ZV9kZWJ0GAQgASgBUgtvdmVyZHVlRGVidBIhCgxkZWJ0b3JfY291bnQYBS'
    'ABKAVSC2RlYnRvckNvdW50EiUKDmN1dF9jYW5kaWRhdGVzGAYgASgFUg1jdXRDYW5kaWRhdGVz');

@$core.Deprecated('Use getCollectionsDashboardRequestDescriptor instead')
const GetCollectionsDashboardRequest$json = {
  '1': 'GetCollectionsDashboardRequest',
  '2': [
    {'1': 'from_period', '3': 1, '4': 1, '5': 9, '10': 'fromPeriod'},
    {'1': 'to_period', '3': 2, '4': 1, '5': 9, '10': 'toPeriod'},
    {'1': 'community_id', '3': 3, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'cut_threshold', '3': 4, '4': 1, '5': 5, '10': 'cutThreshold'},
  ],
};

/// Descriptor for `GetCollectionsDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionsDashboardRequestDescriptor = $convert.base64Decode(
    'Ch5HZXRDb2xsZWN0aW9uc0Rhc2hib2FyZFJlcXVlc3QSHwoLZnJvbV9wZXJpb2QYASABKAlSCm'
    'Zyb21QZXJpb2QSGwoJdG9fcGVyaW9kGAIgASgJUgh0b1BlcmlvZBIhCgxjb21tdW5pdHlfaWQY'
    'AyABKAlSC2NvbW11bml0eUlkEiMKDWN1dF90aHJlc2hvbGQYBCABKAVSDGN1dFRocmVzaG9sZA'
    '==');

@$core.Deprecated('Use getCollectionsDashboardResponseDescriptor instead')
const GetCollectionsDashboardResponse$json = {
  '1': 'GetCollectionsDashboardResponse',
  '2': [
    {'1': 'totals', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.CollectionsDashboardTotals', '10': 'totals'},
    {'1': 'by_sector', '3': 2, '4': 3, '5': 11, '6': '.involt.v1.SectorCollectionSummary', '10': 'bySector'},
    {'1': 'by_period', '3': 3, '4': 3, '5': 11, '6': '.involt.v1.PeriodCollectionSummary', '10': 'byPeriod'},
    {'1': 'aging', '3': 4, '4': 3, '5': 11, '6': '.involt.v1.AgingTotal', '10': 'aging'},
    {'1': 'from_period', '3': 5, '4': 1, '5': 9, '10': 'fromPeriod'},
    {'1': 'to_period', '3': 6, '4': 1, '5': 9, '10': 'toPeriod'},
  ],
};

/// Descriptor for `GetCollectionsDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionsDashboardResponseDescriptor = $convert.base64Decode(
    'Ch9HZXRDb2xsZWN0aW9uc0Rhc2hib2FyZFJlc3BvbnNlEj0KBnRvdGFscxgBIAEoCzIlLmludm'
    '9sdC52MS5Db2xsZWN0aW9uc0Rhc2hib2FyZFRvdGFsc1IGdG90YWxzEj8KCWJ5X3NlY3RvchgC'
    'IAMoCzIiLmludm9sdC52MS5TZWN0b3JDb2xsZWN0aW9uU3VtbWFyeVIIYnlTZWN0b3ISPwoJYn'
    'lfcGVyaW9kGAMgAygLMiIuaW52b2x0LnYxLlBlcmlvZENvbGxlY3Rpb25TdW1tYXJ5UghieVBl'
    'cmlvZBIrCgVhZ2luZxgEIAMoCzIVLmludm9sdC52MS5BZ2luZ1RvdGFsUgVhZ2luZxIfCgtmcm'
    '9tX3BlcmlvZBgFIAEoCVIKZnJvbVBlcmlvZBIbCgl0b19wZXJpb2QYBiABKAlSCHRvUGVyaW9k');

@$core.Deprecated('Use debtorRowDescriptor instead')
const DebtorRow$json = {
  '1': 'DebtorRow',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'customer_code', '3': 2, '4': 1, '5': 9, '10': 'customerCode'},
    {'1': 'customer_name', '3': 3, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'sector_id', '3': 4, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'sector_name', '3': 5, '4': 1, '5': 9, '10': 'sectorName'},
    {'1': 'community_name', '3': 6, '4': 1, '5': 9, '10': 'communityName'},
    {'1': 'total_debt', '3': 7, '4': 1, '5': 1, '10': 'totalDebt'},
    {'1': 'overdue_debt', '3': 8, '4': 1, '5': 1, '10': 'overdueDebt'},
    {'1': 'pending_receipts', '3': 9, '4': 1, '5': 5, '10': 'pendingReceipts'},
    {'1': 'overdue_receipts', '3': 10, '4': 1, '5': 5, '10': 'overdueReceipts'},
    {'1': 'oldest_overdue_period', '3': 11, '4': 1, '5': 9, '10': 'oldestOverduePeriod'},
    {'1': 'days_overdue', '3': 12, '4': 1, '5': 5, '10': 'daysOverdue'},
    {'1': 'last_payment_at', '3': 13, '4': 1, '5': 9, '10': 'lastPaymentAt'},
    {'1': 'cut_candidate', '3': 14, '4': 1, '5': 8, '10': 'cutCandidate'},
  ],
};

/// Descriptor for `DebtorRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List debtorRowDescriptor = $convert.base64Decode(
    'CglEZWJ0b3JSb3cSHwoLY3VzdG9tZXJfaWQYASABKAlSCmN1c3RvbWVySWQSIwoNY3VzdG9tZX'
    'JfY29kZRgCIAEoCVIMY3VzdG9tZXJDb2RlEiMKDWN1c3RvbWVyX25hbWUYAyABKAlSDGN1c3Rv'
    'bWVyTmFtZRIbCglzZWN0b3JfaWQYBCABKAlSCHNlY3RvcklkEh8KC3NlY3Rvcl9uYW1lGAUgAS'
    'gJUgpzZWN0b3JOYW1lEiUKDmNvbW11bml0eV9uYW1lGAYgASgJUg1jb21tdW5pdHlOYW1lEh0K'
    'CnRvdGFsX2RlYnQYByABKAFSCXRvdGFsRGVidBIhCgxvdmVyZHVlX2RlYnQYCCABKAFSC292ZX'
    'JkdWVEZWJ0EikKEHBlbmRpbmdfcmVjZWlwdHMYCSABKAVSD3BlbmRpbmdSZWNlaXB0cxIpChBv'
    'dmVyZHVlX3JlY2VpcHRzGAogASgFUg9vdmVyZHVlUmVjZWlwdHMSMgoVb2xkZXN0X292ZXJkdW'
    'VfcGVyaW9kGAsgASgJUhNvbGRlc3RPdmVyZHVlUGVyaW9kEiEKDGRheXNfb3ZlcmR1ZRgMIAEo'
    'BVILZGF5c092ZXJkdWUSJgoPbGFzdF9wYXltZW50X2F0GA0gASgJUg1sYXN0UGF5bWVudEF0Ei'
    'MKDWN1dF9jYW5kaWRhdGUYDiABKAhSDGN1dENhbmRpZGF0ZQ==');

@$core.Deprecated('Use getDebtorsRequestDescriptor instead')
const GetDebtorsRequest$json = {
  '1': 'GetDebtorsRequest',
  '2': [
    {'1': 'community_id', '3': 1, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'sector_id', '3': 2, '4': 1, '5': 9, '10': 'sectorId'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '10': 'search'},
    {'1': 'min_overdue_receipts', '3': 4, '4': 1, '5': 5, '10': 'minOverdueReceipts'},
    {'1': 'min_debt', '3': 5, '4': 1, '5': 1, '10': 'minDebt'},
    {'1': 'cut_threshold', '3': 6, '4': 1, '5': 5, '10': 'cutThreshold'},
    {'1': 'only_cut_candidates', '3': 7, '4': 1, '5': 8, '10': 'onlyCutCandidates'},
  ],
};

/// Descriptor for `GetDebtorsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDebtorsRequestDescriptor = $convert.base64Decode(
    'ChFHZXREZWJ0b3JzUmVxdWVzdBIhCgxjb21tdW5pdHlfaWQYASABKAlSC2NvbW11bml0eUlkEh'
    'sKCXNlY3Rvcl9pZBgCIAEoCVIIc2VjdG9ySWQSFgoGc2VhcmNoGAMgASgJUgZzZWFyY2gSMAoU'
    'bWluX292ZXJkdWVfcmVjZWlwdHMYBCABKAVSEm1pbk92ZXJkdWVSZWNlaXB0cxIZCghtaW5fZG'
    'VidBgFIAEoAVIHbWluRGVidBIjCg1jdXRfdGhyZXNob2xkGAYgASgFUgxjdXRUaHJlc2hvbGQS'
    'LgoTb25seV9jdXRfY2FuZGlkYXRlcxgHIAEoCFIRb25seUN1dENhbmRpZGF0ZXM=');

@$core.Deprecated('Use getDebtorsResponseDescriptor instead')
const GetDebtorsResponse$json = {
  '1': 'GetDebtorsResponse',
  '2': [
    {'1': 'debtors', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.DebtorRow', '10': 'debtors'},
    {'1': 'total_debt', '3': 2, '4': 1, '5': 1, '10': 'totalDebt'},
    {'1': 'overdue_debt', '3': 3, '4': 1, '5': 1, '10': 'overdueDebt'},
    {'1': 'cut_candidates', '3': 4, '4': 1, '5': 5, '10': 'cutCandidates'},
  ],
};

/// Descriptor for `GetDebtorsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDebtorsResponseDescriptor = $convert.base64Decode(
    'ChJHZXREZWJ0b3JzUmVzcG9uc2USLgoHZGVidG9ycxgBIAMoCzIULmludm9sdC52MS5EZWJ0b3'
    'JSb3dSB2RlYnRvcnMSHQoKdG90YWxfZGVidBgCIAEoAVIJdG90YWxEZWJ0EiEKDG92ZXJkdWVf'
    'ZGVidBgDIAEoAVILb3ZlcmR1ZURlYnQSJQoOY3V0X2NhbmRpZGF0ZXMYBCABKAVSDWN1dENhbm'
    'RpZGF0ZXM=');

