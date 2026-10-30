//
//  Generated code. Do not modify.
//  source: involt/v1/agreements.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use lateFeeModeDescriptor instead')
const LateFeeMode$json = {
  '1': 'LateFeeMode',
  '2': [
    {'1': 'LATE_FEE_MODE_UNSPECIFIED', '2': 0},
    {'1': 'LATE_FEE_MODE_NONE', '2': 1},
    {'1': 'LATE_FEE_MODE_FIXED', '2': 2},
    {'1': 'LATE_FEE_MODE_PERCENT', '2': 3},
    {'1': 'LATE_FEE_MODE_MONTHLY_INTEREST', '2': 4},
  ],
};

/// Descriptor for `LateFeeMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lateFeeModeDescriptor = $convert.base64Decode(
    'CgtMYXRlRmVlTW9kZRIdChlMQVRFX0ZFRV9NT0RFX1VOU1BFQ0lGSUVEEAASFgoSTEFURV9GRU'
    'VfTU9ERV9OT05FEAESFwoTTEFURV9GRUVfTU9ERV9GSVhFRBACEhkKFUxBVEVfRkVFX01PREVf'
    'UEVSQ0VOVBADEiIKHkxBVEVfRkVFX01PREVfTU9OVEhMWV9JTlRFUkVTVBAE');

@$core.Deprecated('Use agreementStatusDescriptor instead')
const AgreementStatus$json = {
  '1': 'AgreementStatus',
  '2': [
    {'1': 'AGREEMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'AGREEMENT_STATUS_ACTIVE', '2': 1},
    {'1': 'AGREEMENT_STATUS_IN_DEFAULT', '2': 2},
    {'1': 'AGREEMENT_STATUS_COMPLETED', '2': 3},
    {'1': 'AGREEMENT_STATUS_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `AgreementStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agreementStatusDescriptor = $convert.base64Decode(
    'Cg9BZ3JlZW1lbnRTdGF0dXMSIAocQUdSRUVNRU5UX1NUQVRVU19VTlNQRUNJRklFRBAAEhsKF0'
    'FHUkVFTUVOVF9TVEFUVVNfQUNUSVZFEAESHwobQUdSRUVNRU5UX1NUQVRVU19JTl9ERUZBVUxU'
    'EAISHgoaQUdSRUVNRU5UX1NUQVRVU19DT01QTEVURUQQAxIeChpBR1JFRU1FTlRfU1RBVFVTX0'
    'NBTkNFTExFRBAE');

@$core.Deprecated('Use collectionPolicyDescriptor instead')
const CollectionPolicy$json = {
  '1': 'CollectionPolicy',
  '2': [
    {'1': 'late_fee_mode', '3': 1, '4': 1, '5': 14, '6': '.involt.v1.LateFeeMode', '10': 'lateFeeMode'},
    {'1': 'late_fee_value', '3': 2, '4': 1, '5': 1, '10': 'lateFeeValue'},
    {'1': 'late_fee_start_date', '3': 3, '4': 1, '5': 9, '10': 'lateFeeStartDate'},
    {'1': 'agreement_max_installments', '3': 4, '4': 1, '5': 5, '10': 'agreementMaxInstallments'},
    {'1': 'agreement_min_initial_percent', '3': 5, '4': 1, '5': 1, '10': 'agreementMinInitialPercent'},
    {'1': 'agreement_grace_days', '3': 6, '4': 1, '5': 5, '10': 'agreementGraceDays'},
    {'1': 'agreement_waive_late_fees', '3': 7, '4': 1, '5': 8, '10': 'agreementWaiveLateFees'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 9, '10': 'updatedAt'},
    {'1': 'updated_by', '3': 9, '4': 1, '5': 9, '10': 'updatedBy'},
  ],
};

/// Descriptor for `CollectionPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionPolicyDescriptor = $convert.base64Decode(
    'ChBDb2xsZWN0aW9uUG9saWN5EjoKDWxhdGVfZmVlX21vZGUYASABKA4yFi5pbnZvbHQudjEuTG'
    'F0ZUZlZU1vZGVSC2xhdGVGZWVNb2RlEiQKDmxhdGVfZmVlX3ZhbHVlGAIgASgBUgxsYXRlRmVl'
    'VmFsdWUSLQoTbGF0ZV9mZWVfc3RhcnRfZGF0ZRgDIAEoCVIQbGF0ZUZlZVN0YXJ0RGF0ZRI8Ch'
    'phZ3JlZW1lbnRfbWF4X2luc3RhbGxtZW50cxgEIAEoBVIYYWdyZWVtZW50TWF4SW5zdGFsbG1l'
    'bnRzEkEKHWFncmVlbWVudF9taW5faW5pdGlhbF9wZXJjZW50GAUgASgBUhphZ3JlZW1lbnRNaW'
    '5Jbml0aWFsUGVyY2VudBIwChRhZ3JlZW1lbnRfZ3JhY2VfZGF5cxgGIAEoBVISYWdyZWVtZW50'
    'R3JhY2VEYXlzEjkKGWFncmVlbWVudF93YWl2ZV9sYXRlX2ZlZXMYByABKAhSFmFncmVlbWVudF'
    'dhaXZlTGF0ZUZlZXMSHQoKdXBkYXRlZF9hdBgIIAEoCVIJdXBkYXRlZEF0Eh0KCnVwZGF0ZWRf'
    'YnkYCSABKAlSCXVwZGF0ZWRCeQ==');

@$core.Deprecated('Use getCollectionPolicyRequestDescriptor instead')
const GetCollectionPolicyRequest$json = {
  '1': 'GetCollectionPolicyRequest',
};

/// Descriptor for `GetCollectionPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionPolicyRequestDescriptor = $convert.base64Decode(
    'ChpHZXRDb2xsZWN0aW9uUG9saWN5UmVxdWVzdA==');

@$core.Deprecated('Use getCollectionPolicyResponseDescriptor instead')
const GetCollectionPolicyResponse$json = {
  '1': 'GetCollectionPolicyResponse',
  '2': [
    {'1': 'policy', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.CollectionPolicy', '10': 'policy'},
  ],
};

/// Descriptor for `GetCollectionPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCollectionPolicyResponseDescriptor = $convert.base64Decode(
    'ChtHZXRDb2xsZWN0aW9uUG9saWN5UmVzcG9uc2USMwoGcG9saWN5GAEgASgLMhsuaW52b2x0Ln'
    'YxLkNvbGxlY3Rpb25Qb2xpY3lSBnBvbGljeQ==');

@$core.Deprecated('Use updateCollectionPolicyRequestDescriptor instead')
const UpdateCollectionPolicyRequest$json = {
  '1': 'UpdateCollectionPolicyRequest',
  '2': [
    {'1': 'policy', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.CollectionPolicy', '10': 'policy'},
  ],
};

/// Descriptor for `UpdateCollectionPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCollectionPolicyRequestDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVDb2xsZWN0aW9uUG9saWN5UmVxdWVzdBIzCgZwb2xpY3kYASABKAsyGy5pbnZvbH'
    'QudjEuQ29sbGVjdGlvblBvbGljeVIGcG9saWN5');

@$core.Deprecated('Use updateCollectionPolicyResponseDescriptor instead')
const UpdateCollectionPolicyResponse$json = {
  '1': 'UpdateCollectionPolicyResponse',
  '2': [
    {'1': 'policy', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.CollectionPolicy', '10': 'policy'},
  ],
};

/// Descriptor for `UpdateCollectionPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCollectionPolicyResponseDescriptor = $convert.base64Decode(
    'Ch5VcGRhdGVDb2xsZWN0aW9uUG9saWN5UmVzcG9uc2USMwoGcG9saWN5GAEgASgLMhsuaW52b2'
    'x0LnYxLkNvbGxlY3Rpb25Qb2xpY3lSBnBvbGljeQ==');

@$core.Deprecated('Use agreementReceiptDescriptor instead')
const AgreementReceipt$json = {
  '1': 'AgreementReceipt',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
    {'1': 'principal', '3': 3, '4': 1, '5': 1, '10': 'principal'},
    {'1': 'late_fee', '3': 4, '4': 1, '5': 1, '10': 'lateFee'},
  ],
};

/// Descriptor for `AgreementReceipt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agreementReceiptDescriptor = $convert.base64Decode(
    'ChBBZ3JlZW1lbnRSZWNlaXB0Eh0KCnJlYWRpbmdfaWQYASABKAlSCXJlYWRpbmdJZBIWCgZwZX'
    'Jpb2QYAiABKAlSBnBlcmlvZBIcCglwcmluY2lwYWwYAyABKAFSCXByaW5jaXBhbBIZCghsYXRl'
    'X2ZlZRgEIAEoAVIHbGF0ZUZlZQ==');

@$core.Deprecated('Use agreementInstallmentDescriptor instead')
const AgreementInstallment$json = {
  '1': 'AgreementInstallment',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 5, '10': 'number'},
    {'1': 'due_date', '3': 2, '4': 1, '5': 9, '10': 'dueDate'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'paid', '3': 4, '4': 1, '5': 8, '10': 'paid'},
  ],
};

/// Descriptor for `AgreementInstallment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agreementInstallmentDescriptor = $convert.base64Decode(
    'ChRBZ3JlZW1lbnRJbnN0YWxsbWVudBIWCgZudW1iZXIYASABKAVSBm51bWJlchIZCghkdWVfZG'
    'F0ZRgCIAEoCVIHZHVlRGF0ZRIWCgZhbW91bnQYAyABKAFSBmFtb3VudBISCgRwYWlkGAQgASgI'
    'UgRwYWlk');

@$core.Deprecated('Use paymentAgreementDescriptor instead')
const PaymentAgreement$json = {
  '1': 'PaymentAgreement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'number', '3': 2, '4': 1, '5': 3, '10': 'number'},
    {'1': 'customer_id', '3': 3, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'customer_name', '3': 4, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'customer_code', '3': 5, '4': 1, '5': 9, '10': 'customerCode'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.involt.v1.AgreementStatus', '10': 'status'},
    {'1': 'total', '3': 7, '4': 1, '5': 1, '10': 'total'},
    {'1': 'initial_amount', '3': 8, '4': 1, '5': 1, '10': 'initialAmount'},
    {'1': 'paid', '3': 9, '4': 1, '5': 1, '10': 'paid'},
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'created_at', '3': 11, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'created_by_email', '3': 12, '4': 1, '5': 9, '10': 'createdByEmail'},
    {'1': 'cancelled_at', '3': 13, '4': 1, '5': 9, '10': 'cancelledAt'},
    {'1': 'cancel_reason', '3': 14, '4': 1, '5': 9, '10': 'cancelReason'},
    {'1': 'receipts', '3': 15, '4': 3, '5': 11, '6': '.involt.v1.AgreementReceipt', '10': 'receipts'},
    {'1': 'installments', '3': 16, '4': 3, '5': 11, '6': '.involt.v1.AgreementInstallment', '10': 'installments'},
    {'1': 'next_installment', '3': 17, '4': 1, '5': 5, '10': 'nextInstallment'},
    {'1': 'next_amount', '3': 18, '4': 1, '5': 1, '10': 'nextAmount'},
    {'1': 'next_due_date', '3': 19, '4': 1, '5': 9, '10': 'nextDueDate'},
    {'1': 'overdue_amount', '3': 20, '4': 1, '5': 1, '10': 'overdueAmount'},
    {'1': 'late_fees_waived', '3': 21, '4': 1, '5': 8, '10': 'lateFeesWaived'},
  ],
};

/// Descriptor for `PaymentAgreement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentAgreementDescriptor = $convert.base64Decode(
    'ChBQYXltZW50QWdyZWVtZW50Eg4KAmlkGAEgASgJUgJpZBIWCgZudW1iZXIYAiABKANSBm51bW'
    'JlchIfCgtjdXN0b21lcl9pZBgDIAEoCVIKY3VzdG9tZXJJZBIjCg1jdXN0b21lcl9uYW1lGAQg'
    'ASgJUgxjdXN0b21lck5hbWUSIwoNY3VzdG9tZXJfY29kZRgFIAEoCVIMY3VzdG9tZXJDb2RlEj'
    'IKBnN0YXR1cxgGIAEoDjIaLmludm9sdC52MS5BZ3JlZW1lbnRTdGF0dXNSBnN0YXR1cxIUCgV0'
    'b3RhbBgHIAEoAVIFdG90YWwSJQoOaW5pdGlhbF9hbW91bnQYCCABKAFSDWluaXRpYWxBbW91bn'
    'QSEgoEcGFpZBgJIAEoAVIEcGFpZBIUCgVub3RlcxgKIAEoCVIFbm90ZXMSHQoKY3JlYXRlZF9h'
    'dBgLIAEoCVIJY3JlYXRlZEF0EigKEGNyZWF0ZWRfYnlfZW1haWwYDCABKAlSDmNyZWF0ZWRCeU'
    'VtYWlsEiEKDGNhbmNlbGxlZF9hdBgNIAEoCVILY2FuY2VsbGVkQXQSIwoNY2FuY2VsX3JlYXNv'
    'bhgOIAEoCVIMY2FuY2VsUmVhc29uEjcKCHJlY2VpcHRzGA8gAygLMhsuaW52b2x0LnYxLkFncm'
    'VlbWVudFJlY2VpcHRSCHJlY2VpcHRzEkMKDGluc3RhbGxtZW50cxgQIAMoCzIfLmludm9sdC52'
    'MS5BZ3JlZW1lbnRJbnN0YWxsbWVudFIMaW5zdGFsbG1lbnRzEikKEG5leHRfaW5zdGFsbG1lbn'
    'QYESABKAVSD25leHRJbnN0YWxsbWVudBIfCgtuZXh0X2Ftb3VudBgSIAEoAVIKbmV4dEFtb3Vu'
    'dBIiCg1uZXh0X2R1ZV9kYXRlGBMgASgJUgtuZXh0RHVlRGF0ZRIlCg5vdmVyZHVlX2Ftb3VudB'
    'gUIAEoAVINb3ZlcmR1ZUFtb3VudBIoChBsYXRlX2ZlZXNfd2FpdmVkGBUgASgIUg5sYXRlRmVl'
    'c1dhaXZlZA==');

@$core.Deprecated('Use agreementRequestDescriptor instead')
const AgreementRequest$json = {
  '1': 'AgreementRequest',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'reading_ids', '3': 2, '4': 3, '5': 9, '10': 'readingIds'},
    {'1': 'installments', '3': 3, '4': 1, '5': 5, '10': 'installments'},
    {'1': 'initial_amount', '3': 4, '4': 1, '5': 1, '10': 'initialAmount'},
    {'1': 'first_due_date', '3': 5, '4': 1, '5': 9, '10': 'firstDueDate'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'initial_payment_method', '3': 7, '4': 1, '5': 5, '10': 'initialPaymentMethod'},
    {'1': 'initial_payment_reference', '3': 8, '4': 1, '5': 9, '10': 'initialPaymentReference'},
  ],
};

/// Descriptor for `AgreementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agreementRequestDescriptor = $convert.base64Decode(
    'ChBBZ3JlZW1lbnRSZXF1ZXN0Eh8KC2N1c3RvbWVyX2lkGAEgASgJUgpjdXN0b21lcklkEh8KC3'
    'JlYWRpbmdfaWRzGAIgAygJUgpyZWFkaW5nSWRzEiIKDGluc3RhbGxtZW50cxgDIAEoBVIMaW5z'
    'dGFsbG1lbnRzEiUKDmluaXRpYWxfYW1vdW50GAQgASgBUg1pbml0aWFsQW1vdW50EiQKDmZpcn'
    'N0X2R1ZV9kYXRlGAUgASgJUgxmaXJzdER1ZURhdGUSFAoFbm90ZXMYBiABKAlSBW5vdGVzEjQK'
    'FmluaXRpYWxfcGF5bWVudF9tZXRob2QYByABKAVSFGluaXRpYWxQYXltZW50TWV0aG9kEjoKGW'
    'luaXRpYWxfcGF5bWVudF9yZWZlcmVuY2UYCCABKAlSF2luaXRpYWxQYXltZW50UmVmZXJlbmNl');

@$core.Deprecated('Use previewAgreementResponseDescriptor instead')
const PreviewAgreementResponse$json = {
  '1': 'PreviewAgreementResponse',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 1, '10': 'total'},
    {'1': 'principal', '3': 2, '4': 1, '5': 1, '10': 'principal'},
    {'1': 'late_fees', '3': 3, '4': 1, '5': 1, '10': 'lateFees'},
    {'1': 'min_initial_amount', '3': 4, '4': 1, '5': 1, '10': 'minInitialAmount'},
    {'1': 'max_installments', '3': 5, '4': 1, '5': 5, '10': 'maxInstallments'},
    {'1': 'late_fees_waived', '3': 6, '4': 1, '5': 8, '10': 'lateFeesWaived'},
    {'1': 'receipts', '3': 7, '4': 3, '5': 11, '6': '.involt.v1.AgreementReceipt', '10': 'receipts'},
    {'1': 'installments', '3': 8, '4': 3, '5': 11, '6': '.involt.v1.AgreementInstallment', '10': 'installments'},
    {'1': 'validation_error', '3': 9, '4': 1, '5': 9, '10': 'validationError'},
  ],
};

/// Descriptor for `PreviewAgreementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewAgreementResponseDescriptor = $convert.base64Decode(
    'ChhQcmV2aWV3QWdyZWVtZW50UmVzcG9uc2USFAoFdG90YWwYASABKAFSBXRvdGFsEhwKCXByaW'
    '5jaXBhbBgCIAEoAVIJcHJpbmNpcGFsEhsKCWxhdGVfZmVlcxgDIAEoAVIIbGF0ZUZlZXMSLAoS'
    'bWluX2luaXRpYWxfYW1vdW50GAQgASgBUhBtaW5Jbml0aWFsQW1vdW50EikKEG1heF9pbnN0YW'
    'xsbWVudHMYBSABKAVSD21heEluc3RhbGxtZW50cxIoChBsYXRlX2ZlZXNfd2FpdmVkGAYgASgI'
    'Ug5sYXRlRmVlc1dhaXZlZBI3CghyZWNlaXB0cxgHIAMoCzIbLmludm9sdC52MS5BZ3JlZW1lbn'
    'RSZWNlaXB0UghyZWNlaXB0cxJDCgxpbnN0YWxsbWVudHMYCCADKAsyHy5pbnZvbHQudjEuQWdy'
    'ZWVtZW50SW5zdGFsbG1lbnRSDGluc3RhbGxtZW50cxIpChB2YWxpZGF0aW9uX2Vycm9yGAkgAS'
    'gJUg92YWxpZGF0aW9uRXJyb3I=');

@$core.Deprecated('Use createAgreementResponseDescriptor instead')
const CreateAgreementResponse$json = {
  '1': 'CreateAgreementResponse',
  '2': [
    {'1': 'agreement', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.PaymentAgreement', '10': 'agreement'},
    {'1': 'initial_payment_id', '3': 2, '4': 1, '5': 9, '10': 'initialPaymentId'},
  ],
};

/// Descriptor for `CreateAgreementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAgreementResponseDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVBZ3JlZW1lbnRSZXNwb25zZRI5CglhZ3JlZW1lbnQYASABKAsyGy5pbnZvbHQudj'
    'EuUGF5bWVudEFncmVlbWVudFIJYWdyZWVtZW50EiwKEmluaXRpYWxfcGF5bWVudF9pZBgCIAEo'
    'CVIQaW5pdGlhbFBheW1lbnRJZA==');

@$core.Deprecated('Use cancelAgreementRequestDescriptor instead')
const CancelAgreementRequest$json = {
  '1': 'CancelAgreementRequest',
  '2': [
    {'1': 'agreement_id', '3': 1, '4': 1, '5': 9, '10': 'agreementId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelAgreementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelAgreementRequestDescriptor = $convert.base64Decode(
    'ChZDYW5jZWxBZ3JlZW1lbnRSZXF1ZXN0EiEKDGFncmVlbWVudF9pZBgBIAEoCVILYWdyZWVtZW'
    '50SWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use cancelAgreementResponseDescriptor instead')
const CancelAgreementResponse$json = {
  '1': 'CancelAgreementResponse',
  '2': [
    {'1': 'agreement', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.PaymentAgreement', '10': 'agreement'},
  ],
};

/// Descriptor for `CancelAgreementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelAgreementResponseDescriptor = $convert.base64Decode(
    'ChdDYW5jZWxBZ3JlZW1lbnRSZXNwb25zZRI5CglhZ3JlZW1lbnQYASABKAsyGy5pbnZvbHQudj'
    'EuUGF5bWVudEFncmVlbWVudFIJYWdyZWVtZW50');

@$core.Deprecated('Use waiveLateFeeRequestDescriptor instead')
const WaiveLateFeeRequest$json = {
  '1': 'WaiveLateFeeRequest',
  '2': [
    {'1': 'reading_ids', '3': 1, '4': 3, '5': 9, '10': 'readingIds'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WaiveLateFeeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveLateFeeRequestDescriptor = $convert.base64Decode(
    'ChNXYWl2ZUxhdGVGZWVSZXF1ZXN0Eh8KC3JlYWRpbmdfaWRzGAEgAygJUgpyZWFkaW5nSWRzEh'
    'YKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use waiveLateFeeResponseDescriptor instead')
const WaiveLateFeeResponse$json = {
  '1': 'WaiveLateFeeResponse',
  '2': [
    {'1': 'waived', '3': 1, '4': 1, '5': 5, '10': 'waived'},
  ],
};

/// Descriptor for `WaiveLateFeeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveLateFeeResponseDescriptor = $convert.base64Decode(
    'ChRXYWl2ZUxhdGVGZWVSZXNwb25zZRIWCgZ3YWl2ZWQYASABKAVSBndhaXZlZA==');

