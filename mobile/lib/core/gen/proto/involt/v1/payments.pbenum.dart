//
//  Generated code. Do not modify.
//  source: involt/v1/payments.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// PaymentMethod is how the customer paid at the cash desk.
class PaymentMethod extends $pb.ProtobufEnum {
  static const PaymentMethod PAYMENT_METHOD_UNSPECIFIED = PaymentMethod._(0, _omitEnumNames ? '' : 'PAYMENT_METHOD_UNSPECIFIED');
  static const PaymentMethod PAYMENT_METHOD_CASH = PaymentMethod._(1, _omitEnumNames ? '' : 'PAYMENT_METHOD_CASH');
  static const PaymentMethod PAYMENT_METHOD_YAPE = PaymentMethod._(2, _omitEnumNames ? '' : 'PAYMENT_METHOD_YAPE');
  static const PaymentMethod PAYMENT_METHOD_PLIN = PaymentMethod._(3, _omitEnumNames ? '' : 'PAYMENT_METHOD_PLIN');
  static const PaymentMethod PAYMENT_METHOD_TRANSFER = PaymentMethod._(4, _omitEnumNames ? '' : 'PAYMENT_METHOD_TRANSFER');
  static const PaymentMethod PAYMENT_METHOD_OTHER = PaymentMethod._(5, _omitEnumNames ? '' : 'PAYMENT_METHOD_OTHER');

  static const $core.List<PaymentMethod> values = <PaymentMethod> [
    PAYMENT_METHOD_UNSPECIFIED,
    PAYMENT_METHOD_CASH,
    PAYMENT_METHOD_YAPE,
    PAYMENT_METHOD_PLIN,
    PAYMENT_METHOD_TRANSFER,
    PAYMENT_METHOD_OTHER,
  ];

  static final $core.Map<$core.int, PaymentMethod> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PaymentMethod? valueOf($core.int value) => _byValue[value];

  const PaymentMethod._($core.int v, $core.String n) : super(v, n);
}

/// ReceiptStatus is the collection state of a receipt (reading).
class ReceiptStatus extends $pb.ProtobufEnum {
  static const ReceiptStatus RECEIPT_STATUS_UNSPECIFIED = ReceiptStatus._(0, _omitEnumNames ? '' : 'RECEIPT_STATUS_UNSPECIFIED');
  static const ReceiptStatus RECEIPT_STATUS_PAID = ReceiptStatus._(1, _omitEnumNames ? '' : 'RECEIPT_STATUS_PAID');
  static const ReceiptStatus RECEIPT_STATUS_PARTIAL = ReceiptStatus._(2, _omitEnumNames ? '' : 'RECEIPT_STATUS_PARTIAL');
  static const ReceiptStatus RECEIPT_STATUS_PENDING = ReceiptStatus._(3, _omitEnumNames ? '' : 'RECEIPT_STATUS_PENDING');
  static const ReceiptStatus RECEIPT_STATUS_OVERDUE = ReceiptStatus._(4, _omitEnumNames ? '' : 'RECEIPT_STATUS_OVERDUE');

  static const $core.List<ReceiptStatus> values = <ReceiptStatus> [
    RECEIPT_STATUS_UNSPECIFIED,
    RECEIPT_STATUS_PAID,
    RECEIPT_STATUS_PARTIAL,
    RECEIPT_STATUS_PENDING,
    RECEIPT_STATUS_OVERDUE,
  ];

  static final $core.Map<$core.int, ReceiptStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReceiptStatus? valueOf($core.int value) => _byValue[value];

  const ReceiptStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
