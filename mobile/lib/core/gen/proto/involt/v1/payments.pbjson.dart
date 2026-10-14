//
//  Generated code. Do not modify.
//  source: involt/v1/payments.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use paymentMethodDescriptor instead')
const PaymentMethod$json = {
  '1': 'PaymentMethod',
  '2': [
    {'1': 'PAYMENT_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'PAYMENT_METHOD_CASH', '2': 1},
    {'1': 'PAYMENT_METHOD_YAPE', '2': 2},
    {'1': 'PAYMENT_METHOD_PLIN', '2': 3},
    {'1': 'PAYMENT_METHOD_TRANSFER', '2': 4},
    {'1': 'PAYMENT_METHOD_OTHER', '2': 5},
  ],
};

/// Descriptor for `PaymentMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentMethodDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50TWV0aG9kEh4KGlBBWU1FTlRfTUVUSE9EX1VOU1BFQ0lGSUVEEAASFwoTUEFZTU'
    'VOVF9NRVRIT0RfQ0FTSBABEhcKE1BBWU1FTlRfTUVUSE9EX1lBUEUQAhIXChNQQVlNRU5UX01F'
    'VEhPRF9QTElOEAMSGwoXUEFZTUVOVF9NRVRIT0RfVFJBTlNGRVIQBBIYChRQQVlNRU5UX01FVE'
    'hPRF9PVEhFUhAF');

@$core.Deprecated('Use receiptStatusDescriptor instead')
const ReceiptStatus$json = {
  '1': 'ReceiptStatus',
  '2': [
    {'1': 'RECEIPT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RECEIPT_STATUS_PAID', '2': 1},
    {'1': 'RECEIPT_STATUS_PARTIAL', '2': 2},
    {'1': 'RECEIPT_STATUS_PENDING', '2': 3},
    {'1': 'RECEIPT_STATUS_OVERDUE', '2': 4},
  ],
};

/// Descriptor for `ReceiptStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List receiptStatusDescriptor = $convert.base64Decode(
    'Cg1SZWNlaXB0U3RhdHVzEh4KGlJFQ0VJUFRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTUkVDRU'
    'lQVF9TVEFUVVNfUEFJRBABEhoKFlJFQ0VJUFRfU1RBVFVTX1BBUlRJQUwQAhIaChZSRUNFSVBU'
    'X1NUQVRVU19QRU5ESU5HEAMSGgoWUkVDRUlQVF9TVEFUVVNfT1ZFUkRVRRAE');

@$core.Deprecated('Use receiptBalanceDescriptor instead')
const ReceiptBalance$json = {
  '1': 'ReceiptBalance',
  '2': [
    {'1': 'reading', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Reading', '10': 'reading'},
    {'1': 'paid_amount', '3': 2, '4': 1, '5': 1, '10': 'paidAmount'},
    {'1': 'balance', '3': 3, '4': 1, '5': 1, '10': 'balance'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.involt.v1.ReceiptStatus', '10': 'status'},
  ],
};

/// Descriptor for `ReceiptBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiptBalanceDescriptor = $convert.base64Decode(
    'Cg5SZWNlaXB0QmFsYW5jZRIsCgdyZWFkaW5nGAEgASgLMhIuaW52b2x0LnYxLlJlYWRpbmdSB3'
    'JlYWRpbmcSHwoLcGFpZF9hbW91bnQYAiABKAFSCnBhaWRBbW91bnQSGAoHYmFsYW5jZRgDIAEo'
    'AVIHYmFsYW5jZRIwCgZzdGF0dXMYBCABKA4yGC5pbnZvbHQudjEuUmVjZWlwdFN0YXR1c1IGc3'
    'RhdHVz');

@$core.Deprecated('Use paymentAllocationDescriptor instead')
const PaymentAllocation$json = {
  '1': 'PaymentAllocation',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `PaymentAllocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentAllocationDescriptor = $convert.base64Decode(
    'ChFQYXltZW50QWxsb2NhdGlvbhIdCgpyZWFkaW5nX2lkGAEgASgJUglyZWFkaW5nSWQSFgoGcG'
    'VyaW9kGAIgASgJUgZwZXJpb2QSFgoGYW1vdW50GAMgASgBUgZhbW91bnQ=');

@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = {
  '1': 'Payment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'receipt_number', '3': 2, '4': 1, '5': 3, '10': 'receiptNumber'},
    {'1': 'customer_id', '3': 3, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'customer_name', '3': 4, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'customer_code', '3': 5, '4': 1, '5': 9, '10': 'customerCode'},
    {'1': 'amount', '3': 6, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'method', '3': 7, '4': 1, '5': 14, '6': '.involt.v1.PaymentMethod', '10': 'method'},
    {'1': 'reference', '3': 8, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'observation', '3': 9, '4': 1, '5': 9, '10': 'observation'},
    {'1': 'collected_by_email', '3': 10, '4': 1, '5': 9, '10': 'collectedByEmail'},
    {'1': 'paid_at', '3': 11, '4': 1, '5': 9, '10': 'paidAt'},
    {'1': 'voided', '3': 12, '4': 1, '5': 8, '10': 'voided'},
    {'1': 'voided_at', '3': 13, '4': 1, '5': 9, '10': 'voidedAt'},
    {'1': 'void_reason', '3': 14, '4': 1, '5': 9, '10': 'voidReason'},
    {'1': 'allocations', '3': 15, '4': 3, '5': 11, '6': '.involt.v1.PaymentAllocation', '10': 'allocations'},
    {'1': 'collected_by', '3': 16, '4': 1, '5': 9, '10': 'collectedBy'},
  ],
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode(
    'CgdQYXltZW50Eg4KAmlkGAEgASgJUgJpZBIlCg5yZWNlaXB0X251bWJlchgCIAEoA1INcmVjZW'
    'lwdE51bWJlchIfCgtjdXN0b21lcl9pZBgDIAEoCVIKY3VzdG9tZXJJZBIjCg1jdXN0b21lcl9u'
    'YW1lGAQgASgJUgxjdXN0b21lck5hbWUSIwoNY3VzdG9tZXJfY29kZRgFIAEoCVIMY3VzdG9tZX'
    'JDb2RlEhYKBmFtb3VudBgGIAEoAVIGYW1vdW50EjAKBm1ldGhvZBgHIAEoDjIYLmludm9sdC52'
    'MS5QYXltZW50TWV0aG9kUgZtZXRob2QSHAoJcmVmZXJlbmNlGAggASgJUglyZWZlcmVuY2USIA'
    'oLb2JzZXJ2YXRpb24YCSABKAlSC29ic2VydmF0aW9uEiwKEmNvbGxlY3RlZF9ieV9lbWFpbBgK'
    'IAEoCVIQY29sbGVjdGVkQnlFbWFpbBIXCgdwYWlkX2F0GAsgASgJUgZwYWlkQXQSFgoGdm9pZG'
    'VkGAwgASgIUgZ2b2lkZWQSGwoJdm9pZGVkX2F0GA0gASgJUgh2b2lkZWRBdBIfCgt2b2lkX3Jl'
    'YXNvbhgOIAEoCVIKdm9pZFJlYXNvbhI+CgthbGxvY2F0aW9ucxgPIAMoCzIcLmludm9sdC52MS'
    '5QYXltZW50QWxsb2NhdGlvblILYWxsb2NhdGlvbnMSIQoMY29sbGVjdGVkX2J5GBAgASgJUgtj'
    'b2xsZWN0ZWRCeQ==');

@$core.Deprecated('Use getCustomerAccountRequestDescriptor instead')
const GetCustomerAccountRequest$json = {
  '1': 'GetCustomerAccountRequest',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
  ],
};

/// Descriptor for `GetCustomerAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCustomerAccountRequestDescriptor = $convert.base64Decode(
    'ChlHZXRDdXN0b21lckFjY291bnRSZXF1ZXN0Eh8KC2N1c3RvbWVyX2lkGAEgASgJUgpjdXN0b2'
    '1lcklk');

@$core.Deprecated('Use getCustomerAccountResponseDescriptor instead')
const GetCustomerAccountResponse$json = {
  '1': 'GetCustomerAccountResponse',
  '2': [
    {'1': 'customer', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Customer', '10': 'customer'},
    {'1': 'receipts', '3': 2, '4': 3, '5': 11, '6': '.involt.v1.ReceiptBalance', '10': 'receipts'},
    {'1': 'payments', '3': 3, '4': 3, '5': 11, '6': '.involt.v1.Payment', '10': 'payments'},
    {'1': 'total_debt', '3': 4, '4': 1, '5': 1, '10': 'totalDebt'},
    {'1': 'overdue_count', '3': 5, '4': 1, '5': 5, '10': 'overdueCount'},
  ],
};

/// Descriptor for `GetCustomerAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCustomerAccountResponseDescriptor = $convert.base64Decode(
    'ChpHZXRDdXN0b21lckFjY291bnRSZXNwb25zZRIvCghjdXN0b21lchgBIAEoCzITLmludm9sdC'
    '52MS5DdXN0b21lclIIY3VzdG9tZXISNQoIcmVjZWlwdHMYAiADKAsyGS5pbnZvbHQudjEuUmVj'
    'ZWlwdEJhbGFuY2VSCHJlY2VpcHRzEi4KCHBheW1lbnRzGAMgAygLMhIuaW52b2x0LnYxLlBheW'
    '1lbnRSCHBheW1lbnRzEh0KCnRvdGFsX2RlYnQYBCABKAFSCXRvdGFsRGVidBIjCg1vdmVyZHVl'
    'X2NvdW50GAUgASgFUgxvdmVyZHVlQ291bnQ=');

@$core.Deprecated('Use registerPaymentRequestDescriptor instead')
const RegisterPaymentRequest$json = {
  '1': 'RegisterPaymentRequest',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'reading_ids', '3': 2, '4': 3, '5': 9, '10': 'readingIds'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'method', '3': 4, '4': 1, '5': 14, '6': '.involt.v1.PaymentMethod', '10': 'method'},
    {'1': 'reference', '3': 5, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'observation', '3': 6, '4': 1, '5': 9, '10': 'observation'},
  ],
};

/// Descriptor for `RegisterPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPaymentRequestDescriptor = $convert.base64Decode(
    'ChZSZWdpc3RlclBheW1lbnRSZXF1ZXN0Eh8KC2N1c3RvbWVyX2lkGAEgASgJUgpjdXN0b21lck'
    'lkEh8KC3JlYWRpbmdfaWRzGAIgAygJUgpyZWFkaW5nSWRzEhYKBmFtb3VudBgDIAEoAVIGYW1v'
    'dW50EjAKBm1ldGhvZBgEIAEoDjIYLmludm9sdC52MS5QYXltZW50TWV0aG9kUgZtZXRob2QSHA'
    'oJcmVmZXJlbmNlGAUgASgJUglyZWZlcmVuY2USIAoLb2JzZXJ2YXRpb24YBiABKAlSC29ic2Vy'
    'dmF0aW9u');

@$core.Deprecated('Use registerPaymentResponseDescriptor instead')
const RegisterPaymentResponse$json = {
  '1': 'RegisterPaymentResponse',
  '2': [
    {'1': 'payment', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Payment', '10': 'payment'},
  ],
};

/// Descriptor for `RegisterPaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPaymentResponseDescriptor = $convert.base64Decode(
    'ChdSZWdpc3RlclBheW1lbnRSZXNwb25zZRIsCgdwYXltZW50GAEgASgLMhIuaW52b2x0LnYxLl'
    'BheW1lbnRSB3BheW1lbnQ=');

@$core.Deprecated('Use voidPaymentRequestDescriptor instead')
const VoidPaymentRequest$json = {
  '1': 'VoidPaymentRequest',
  '2': [
    {'1': 'payment_id', '3': 1, '4': 1, '5': 9, '10': 'paymentId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `VoidPaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidPaymentRequestDescriptor = $convert.base64Decode(
    'ChJWb2lkUGF5bWVudFJlcXVlc3QSHQoKcGF5bWVudF9pZBgBIAEoCVIJcGF5bWVudElkEhYKBn'
    'JlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use voidPaymentResponseDescriptor instead')
const VoidPaymentResponse$json = {
  '1': 'VoidPaymentResponse',
  '2': [
    {'1': 'payment', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Payment', '10': 'payment'},
  ],
};

/// Descriptor for `VoidPaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidPaymentResponseDescriptor = $convert.base64Decode(
    'ChNWb2lkUGF5bWVudFJlc3BvbnNlEiwKB3BheW1lbnQYASABKAsyEi5pbnZvbHQudjEuUGF5bW'
    'VudFIHcGF5bWVudA==');

@$core.Deprecated('Use createFlatChargeRequestDescriptor instead')
const CreateFlatChargeRequest$json = {
  '1': 'CreateFlatChargeRequest',
  '2': [
    {'1': 'customer_id', '3': 1, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'observation', '3': 4, '4': 1, '5': 9, '10': 'observation'},
  ],
};

/// Descriptor for `CreateFlatChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFlatChargeRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVGbGF0Q2hhcmdlUmVxdWVzdBIfCgtjdXN0b21lcl9pZBgBIAEoCVIKY3VzdG9tZX'
    'JJZBIWCgZwZXJpb2QYAiABKAlSBnBlcmlvZBIWCgZhbW91bnQYAyABKAFSBmFtb3VudBIgCgtv'
    'YnNlcnZhdGlvbhgEIAEoCVILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use createFlatChargeResponseDescriptor instead')
const CreateFlatChargeResponse$json = {
  '1': 'CreateFlatChargeResponse',
  '2': [
    {'1': 'reading', '3': 1, '4': 1, '5': 11, '6': '.involt.v1.Reading', '10': 'reading'},
  ],
};

/// Descriptor for `CreateFlatChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFlatChargeResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVGbGF0Q2hhcmdlUmVzcG9uc2USLAoHcmVhZGluZxgBIAEoCzISLmludm9sdC52MS'
    '5SZWFkaW5nUgdyZWFkaW5n');

@$core.Deprecated('Use getCashClosingRequestDescriptor instead')
const GetCashClosingRequest$json = {
  '1': 'GetCashClosingRequest',
  '2': [
    {'1': 'date_from', '3': 1, '4': 1, '5': 9, '10': 'dateFrom'},
    {'1': 'date_to', '3': 2, '4': 1, '5': 9, '10': 'dateTo'},
    {'1': 'collected_by', '3': 3, '4': 1, '5': 9, '10': 'collectedBy'},
  ],
};

/// Descriptor for `GetCashClosingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCashClosingRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDYXNoQ2xvc2luZ1JlcXVlc3QSGwoJZGF0ZV9mcm9tGAEgASgJUghkYXRlRnJvbRIXCg'
    'dkYXRlX3RvGAIgASgJUgZkYXRlVG8SIQoMY29sbGVjdGVkX2J5GAMgASgJUgtjb2xsZWN0ZWRC'
    'eQ==');

@$core.Deprecated('Use methodTotalDescriptor instead')
const MethodTotal$json = {
  '1': 'MethodTotal',
  '2': [
    {'1': 'method', '3': 1, '4': 1, '5': 14, '6': '.involt.v1.PaymentMethod', '10': 'method'},
    {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `MethodTotal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List methodTotalDescriptor = $convert.base64Decode(
    'CgtNZXRob2RUb3RhbBIwCgZtZXRob2QYASABKA4yGC5pbnZvbHQudjEuUGF5bWVudE1ldGhvZF'
    'IGbWV0aG9kEhYKBmFtb3VudBgCIAEoAVIGYW1vdW50EhQKBWNvdW50GAMgASgFUgVjb3VudA==');

@$core.Deprecated('Use collectorTotalDescriptor instead')
const CollectorTotal$json = {
  '1': 'CollectorTotal',
  '2': [
    {'1': 'collected_by', '3': 1, '4': 1, '5': 9, '10': 'collectedBy'},
    {'1': 'collected_by_email', '3': 2, '4': 1, '5': 9, '10': 'collectedByEmail'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'count', '3': 4, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `CollectorTotal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectorTotalDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0b3JUb3RhbBIhCgxjb2xsZWN0ZWRfYnkYASABKAlSC2NvbGxlY3RlZEJ5EiwKEm'
    'NvbGxlY3RlZF9ieV9lbWFpbBgCIAEoCVIQY29sbGVjdGVkQnlFbWFpbBIWCgZhbW91bnQYAyAB'
    'KAFSBmFtb3VudBIUCgVjb3VudBgEIAEoBVIFY291bnQ=');

@$core.Deprecated('Use getCashClosingResponseDescriptor instead')
const GetCashClosingResponse$json = {
  '1': 'GetCashClosingResponse',
  '2': [
    {'1': 'payments', '3': 1, '4': 3, '5': 11, '6': '.involt.v1.Payment', '10': 'payments'},
    {'1': 'total_amount', '3': 2, '4': 1, '5': 1, '10': 'totalAmount'},
    {'1': 'payment_count', '3': 3, '4': 1, '5': 5, '10': 'paymentCount'},
    {'1': 'by_method', '3': 4, '4': 3, '5': 11, '6': '.involt.v1.MethodTotal', '10': 'byMethod'},
    {'1': 'by_collector', '3': 5, '4': 3, '5': 11, '6': '.involt.v1.CollectorTotal', '10': 'byCollector'},
    {'1': 'voided_amount', '3': 6, '4': 1, '5': 1, '10': 'voidedAmount'},
    {'1': 'voided_count', '3': 7, '4': 1, '5': 5, '10': 'voidedCount'},
  ],
};

/// Descriptor for `GetCashClosingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCashClosingResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDYXNoQ2xvc2luZ1Jlc3BvbnNlEi4KCHBheW1lbnRzGAEgAygLMhIuaW52b2x0LnYxLl'
    'BheW1lbnRSCHBheW1lbnRzEiEKDHRvdGFsX2Ftb3VudBgCIAEoAVILdG90YWxBbW91bnQSIwoN'
    'cGF5bWVudF9jb3VudBgDIAEoBVIMcGF5bWVudENvdW50EjMKCWJ5X21ldGhvZBgEIAMoCzIWLm'
    'ludm9sdC52MS5NZXRob2RUb3RhbFIIYnlNZXRob2QSPAoMYnlfY29sbGVjdG9yGAUgAygLMhku'
    'aW52b2x0LnYxLkNvbGxlY3RvclRvdGFsUgtieUNvbGxlY3RvchIjCg12b2lkZWRfYW1vdW50GA'
    'YgASgBUgx2b2lkZWRBbW91bnQSIQoMdm9pZGVkX2NvdW50GAcgASgFUgt2b2lkZWRDb3VudA==');

