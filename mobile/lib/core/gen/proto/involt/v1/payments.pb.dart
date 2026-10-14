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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pb.dart' as $0;
import 'payments.pbenum.dart';

export 'payments.pbenum.dart';

/// ReceiptBalance is a receipt with how much has been paid and what is still owed.
class ReceiptBalance extends $pb.GeneratedMessage {
  factory ReceiptBalance({
    $0.Reading? reading,
    $core.double? paidAmount,
    $core.double? balance,
    ReceiptStatus? status,
  }) {
    final $result = create();
    if (reading != null) {
      $result.reading = reading;
    }
    if (paidAmount != null) {
      $result.paidAmount = paidAmount;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  ReceiptBalance._() : super();
  factory ReceiptBalance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiptBalance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiptBalance', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Reading>(1, _omitFieldNames ? '' : 'reading', subBuilder: $0.Reading.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'paidAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'balance', $pb.PbFieldType.OD)
    ..e<ReceiptStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ReceiptStatus.RECEIPT_STATUS_UNSPECIFIED, valueOf: ReceiptStatus.valueOf, enumValues: ReceiptStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiptBalance clone() => ReceiptBalance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiptBalance copyWith(void Function(ReceiptBalance) updates) => super.copyWith((message) => updates(message as ReceiptBalance)) as ReceiptBalance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiptBalance create() => ReceiptBalance._();
  ReceiptBalance createEmptyInstance() => create();
  static $pb.PbList<ReceiptBalance> createRepeated() => $pb.PbList<ReceiptBalance>();
  @$core.pragma('dart2js:noInline')
  static ReceiptBalance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiptBalance>(create);
  static ReceiptBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Reading get reading => $_getN(0);
  @$pb.TagNumber(1)
  set reading($0.Reading v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReading() => $_has(0);
  @$pb.TagNumber(1)
  void clearReading() => clearField(1);
  @$pb.TagNumber(1)
  $0.Reading ensureReading() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get paidAmount => $_getN(1);
  @$pb.TagNumber(2)
  set paidAmount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPaidAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaidAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => clearField(3);

  @$pb.TagNumber(4)
  ReceiptStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ReceiptStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);
}

class PaymentAllocation extends $pb.GeneratedMessage {
  factory PaymentAllocation({
    $core.String? readingId,
    $core.String? period,
    $core.double? amount,
  }) {
    final $result = create();
    if (readingId != null) {
      $result.readingId = readingId;
    }
    if (period != null) {
      $result.period = period;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  PaymentAllocation._() : super();
  factory PaymentAllocation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentAllocation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PaymentAllocation', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentAllocation clone() => PaymentAllocation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentAllocation copyWith(void Function(PaymentAllocation) updates) => super.copyWith((message) => updates(message as PaymentAllocation)) as PaymentAllocation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentAllocation create() => PaymentAllocation._();
  PaymentAllocation createEmptyInstance() => create();
  static $pb.PbList<PaymentAllocation> createRepeated() => $pb.PbList<PaymentAllocation>();
  @$core.pragma('dart2js:noInline')
  static PaymentAllocation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentAllocation>(create);
  static PaymentAllocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
}

class Payment extends $pb.GeneratedMessage {
  factory Payment({
    $core.String? id,
    $fixnum.Int64? receiptNumber,
    $core.String? customerId,
    $core.String? customerName,
    $core.String? customerCode,
    $core.double? amount,
    PaymentMethod? method,
    $core.String? reference,
    $core.String? observation,
    $core.String? collectedByEmail,
    $core.String? paidAt,
    $core.bool? voided,
    $core.String? voidedAt,
    $core.String? voidReason,
    $core.Iterable<PaymentAllocation>? allocations,
    $core.String? collectedBy,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (receiptNumber != null) {
      $result.receiptNumber = receiptNumber;
    }
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (customerName != null) {
      $result.customerName = customerName;
    }
    if (customerCode != null) {
      $result.customerCode = customerCode;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (method != null) {
      $result.method = method;
    }
    if (reference != null) {
      $result.reference = reference;
    }
    if (observation != null) {
      $result.observation = observation;
    }
    if (collectedByEmail != null) {
      $result.collectedByEmail = collectedByEmail;
    }
    if (paidAt != null) {
      $result.paidAt = paidAt;
    }
    if (voided != null) {
      $result.voided = voided;
    }
    if (voidedAt != null) {
      $result.voidedAt = voidedAt;
    }
    if (voidReason != null) {
      $result.voidReason = voidReason;
    }
    if (allocations != null) {
      $result.allocations.addAll(allocations);
    }
    if (collectedBy != null) {
      $result.collectedBy = collectedBy;
    }
    return $result;
  }
  Payment._() : super();
  factory Payment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Payment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Payment', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'receiptNumber')
    ..aOS(3, _omitFieldNames ? '' : 'customerId')
    ..aOS(4, _omitFieldNames ? '' : 'customerName')
    ..aOS(5, _omitFieldNames ? '' : 'customerCode')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..e<PaymentMethod>(7, _omitFieldNames ? '' : 'method', $pb.PbFieldType.OE, defaultOrMaker: PaymentMethod.PAYMENT_METHOD_UNSPECIFIED, valueOf: PaymentMethod.valueOf, enumValues: PaymentMethod.values)
    ..aOS(8, _omitFieldNames ? '' : 'reference')
    ..aOS(9, _omitFieldNames ? '' : 'observation')
    ..aOS(10, _omitFieldNames ? '' : 'collectedByEmail')
    ..aOS(11, _omitFieldNames ? '' : 'paidAt')
    ..aOB(12, _omitFieldNames ? '' : 'voided')
    ..aOS(13, _omitFieldNames ? '' : 'voidedAt')
    ..aOS(14, _omitFieldNames ? '' : 'voidReason')
    ..pc<PaymentAllocation>(15, _omitFieldNames ? '' : 'allocations', $pb.PbFieldType.PM, subBuilder: PaymentAllocation.create)
    ..aOS(16, _omitFieldNames ? '' : 'collectedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Payment clone() => Payment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Payment copyWith(void Function(Payment) updates) => super.copyWith((message) => updates(message as Payment)) as Payment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Payment create() => Payment._();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => $pb.PbList<Payment>();
  @$core.pragma('dart2js:noInline')
  static Payment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payment>(create);
  static Payment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiptNumber => $_getI64(1);
  @$pb.TagNumber(2)
  set receiptNumber($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiptNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiptNumber() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get customerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set customerId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get customerName => $_getSZ(3);
  @$pb.TagNumber(4)
  set customerName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustomerName() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get customerCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set customerCode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCustomerCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomerCode() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get amount => $_getN(5);
  @$pb.TagNumber(6)
  set amount($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => clearField(6);

  @$pb.TagNumber(7)
  PaymentMethod get method => $_getN(6);
  @$pb.TagNumber(7)
  set method(PaymentMethod v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMethod() => $_has(6);
  @$pb.TagNumber(7)
  void clearMethod() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get reference => $_getSZ(7);
  @$pb.TagNumber(8)
  set reference($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasReference() => $_has(7);
  @$pb.TagNumber(8)
  void clearReference() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get observation => $_getSZ(8);
  @$pb.TagNumber(9)
  set observation($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasObservation() => $_has(8);
  @$pb.TagNumber(9)
  void clearObservation() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get collectedByEmail => $_getSZ(9);
  @$pb.TagNumber(10)
  set collectedByEmail($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCollectedByEmail() => $_has(9);
  @$pb.TagNumber(10)
  void clearCollectedByEmail() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get paidAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set paidAt($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasPaidAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPaidAt() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get voided => $_getBF(11);
  @$pb.TagNumber(12)
  set voided($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasVoided() => $_has(11);
  @$pb.TagNumber(12)
  void clearVoided() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get voidedAt => $_getSZ(12);
  @$pb.TagNumber(13)
  set voidedAt($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasVoidedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearVoidedAt() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get voidReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set voidReason($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasVoidReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearVoidReason() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<PaymentAllocation> get allocations => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get collectedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set collectedBy($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasCollectedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearCollectedBy() => clearField(16);
}

class GetCustomerAccountRequest extends $pb.GeneratedMessage {
  factory GetCustomerAccountRequest({
    $core.String? customerId,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    return $result;
  }
  GetCustomerAccountRequest._() : super();
  factory GetCustomerAccountRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomerAccountRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomerAccountRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomerAccountRequest clone() => GetCustomerAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomerAccountRequest copyWith(void Function(GetCustomerAccountRequest) updates) => super.copyWith((message) => updates(message as GetCustomerAccountRequest)) as GetCustomerAccountRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomerAccountRequest create() => GetCustomerAccountRequest._();
  GetCustomerAccountRequest createEmptyInstance() => create();
  static $pb.PbList<GetCustomerAccountRequest> createRepeated() => $pb.PbList<GetCustomerAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCustomerAccountRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomerAccountRequest>(create);
  static GetCustomerAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);
}

class GetCustomerAccountResponse extends $pb.GeneratedMessage {
  factory GetCustomerAccountResponse({
    $0.Customer? customer,
    $core.Iterable<ReceiptBalance>? receipts,
    $core.Iterable<Payment>? payments,
    $core.double? totalDebt,
    $core.int? overdueCount,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    if (receipts != null) {
      $result.receipts.addAll(receipts);
    }
    if (payments != null) {
      $result.payments.addAll(payments);
    }
    if (totalDebt != null) {
      $result.totalDebt = totalDebt;
    }
    if (overdueCount != null) {
      $result.overdueCount = overdueCount;
    }
    return $result;
  }
  GetCustomerAccountResponse._() : super();
  factory GetCustomerAccountResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomerAccountResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomerAccountResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..pc<ReceiptBalance>(2, _omitFieldNames ? '' : 'receipts', $pb.PbFieldType.PM, subBuilder: ReceiptBalance.create)
    ..pc<Payment>(3, _omitFieldNames ? '' : 'payments', $pb.PbFieldType.PM, subBuilder: Payment.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'totalDebt', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'overdueCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomerAccountResponse clone() => GetCustomerAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomerAccountResponse copyWith(void Function(GetCustomerAccountResponse) updates) => super.copyWith((message) => updates(message as GetCustomerAccountResponse)) as GetCustomerAccountResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomerAccountResponse create() => GetCustomerAccountResponse._();
  GetCustomerAccountResponse createEmptyInstance() => create();
  static $pb.PbList<GetCustomerAccountResponse> createRepeated() => $pb.PbList<GetCustomerAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCustomerAccountResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomerAccountResponse>(create);
  static GetCustomerAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Customer get customer => $_getN(0);
  @$pb.TagNumber(1)
  set customer($0.Customer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomer() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomer() => clearField(1);
  @$pb.TagNumber(1)
  $0.Customer ensureCustomer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<ReceiptBalance> get receipts => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<Payment> get payments => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get totalDebt => $_getN(3);
  @$pb.TagNumber(4)
  set totalDebt($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalDebt() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalDebt() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get overdueCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set overdueCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOverdueCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdueCount() => clearField(5);
}

class RegisterPaymentRequest extends $pb.GeneratedMessage {
  factory RegisterPaymentRequest({
    $core.String? customerId,
    $core.Iterable<$core.String>? readingIds,
    $core.double? amount,
    PaymentMethod? method,
    $core.String? reference,
    $core.String? observation,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (readingIds != null) {
      $result.readingIds.addAll(readingIds);
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (method != null) {
      $result.method = method;
    }
    if (reference != null) {
      $result.reference = reference;
    }
    if (observation != null) {
      $result.observation = observation;
    }
    return $result;
  }
  RegisterPaymentRequest._() : super();
  factory RegisterPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..pPS(2, _omitFieldNames ? '' : 'readingIds')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..e<PaymentMethod>(4, _omitFieldNames ? '' : 'method', $pb.PbFieldType.OE, defaultOrMaker: PaymentMethod.PAYMENT_METHOD_UNSPECIFIED, valueOf: PaymentMethod.valueOf, enumValues: PaymentMethod.values)
    ..aOS(5, _omitFieldNames ? '' : 'reference')
    ..aOS(6, _omitFieldNames ? '' : 'observation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest clone() => RegisterPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentRequest copyWith(void Function(RegisterPaymentRequest) updates) => super.copyWith((message) => updates(message as RegisterPaymentRequest)) as RegisterPaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentRequest create() => RegisterPaymentRequest._();
  RegisterPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentRequest> createRepeated() => $pb.PbList<RegisterPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentRequest>(create);
  static RegisterPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  /// Receipts to apply the payment to. Empty means all outstanding receipts.
  /// The amount is always applied oldest period first.
  @$pb.TagNumber(2)
  $core.List<$core.String> get readingIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  PaymentMethod get method => $_getN(3);
  @$pb.TagNumber(4)
  set method(PaymentMethod v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearMethod() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get reference => $_getSZ(4);
  @$pb.TagNumber(5)
  set reference($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReference() => $_has(4);
  @$pb.TagNumber(5)
  void clearReference() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get observation => $_getSZ(5);
  @$pb.TagNumber(6)
  set observation($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObservation() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservation() => clearField(6);
}

class RegisterPaymentResponse extends $pb.GeneratedMessage {
  factory RegisterPaymentResponse({
    Payment? payment,
  }) {
    final $result = create();
    if (payment != null) {
      $result.payment = payment;
    }
    return $result;
  }
  RegisterPaymentResponse._() : super();
  factory RegisterPaymentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterPaymentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPaymentResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<Payment>(1, _omitFieldNames ? '' : 'payment', subBuilder: Payment.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterPaymentResponse clone() => RegisterPaymentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterPaymentResponse copyWith(void Function(RegisterPaymentResponse) updates) => super.copyWith((message) => updates(message as RegisterPaymentResponse)) as RegisterPaymentResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPaymentResponse create() => RegisterPaymentResponse._();
  RegisterPaymentResponse createEmptyInstance() => create();
  static $pb.PbList<RegisterPaymentResponse> createRepeated() => $pb.PbList<RegisterPaymentResponse>();
  @$core.pragma('dart2js:noInline')
  static RegisterPaymentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPaymentResponse>(create);
  static RegisterPaymentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Payment get payment => $_getN(0);
  @$pb.TagNumber(1)
  set payment(Payment v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayment() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayment() => clearField(1);
  @$pb.TagNumber(1)
  Payment ensurePayment() => $_ensure(0);
}

class VoidPaymentRequest extends $pb.GeneratedMessage {
  factory VoidPaymentRequest({
    $core.String? paymentId,
    $core.String? reason,
  }) {
    final $result = create();
    if (paymentId != null) {
      $result.paymentId = paymentId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  VoidPaymentRequest._() : super();
  factory VoidPaymentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoidPaymentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoidPaymentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoidPaymentRequest clone() => VoidPaymentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoidPaymentRequest copyWith(void Function(VoidPaymentRequest) updates) => super.copyWith((message) => updates(message as VoidPaymentRequest)) as VoidPaymentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidPaymentRequest create() => VoidPaymentRequest._();
  VoidPaymentRequest createEmptyInstance() => create();
  static $pb.PbList<VoidPaymentRequest> createRepeated() => $pb.PbList<VoidPaymentRequest>();
  @$core.pragma('dart2js:noInline')
  static VoidPaymentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoidPaymentRequest>(create);
  static VoidPaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class VoidPaymentResponse extends $pb.GeneratedMessage {
  factory VoidPaymentResponse({
    Payment? payment,
  }) {
    final $result = create();
    if (payment != null) {
      $result.payment = payment;
    }
    return $result;
  }
  VoidPaymentResponse._() : super();
  factory VoidPaymentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoidPaymentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoidPaymentResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<Payment>(1, _omitFieldNames ? '' : 'payment', subBuilder: Payment.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoidPaymentResponse clone() => VoidPaymentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoidPaymentResponse copyWith(void Function(VoidPaymentResponse) updates) => super.copyWith((message) => updates(message as VoidPaymentResponse)) as VoidPaymentResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidPaymentResponse create() => VoidPaymentResponse._();
  VoidPaymentResponse createEmptyInstance() => create();
  static $pb.PbList<VoidPaymentResponse> createRepeated() => $pb.PbList<VoidPaymentResponse>();
  @$core.pragma('dart2js:noInline')
  static VoidPaymentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoidPaymentResponse>(create);
  static VoidPaymentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Payment get payment => $_getN(0);
  @$pb.TagNumber(1)
  set payment(Payment v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayment() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayment() => clearField(1);
  @$pb.TagNumber(1)
  Payment ensurePayment() => $_ensure(0);
}

/// CreateFlatChargeRequest bills a period that has no meter reading (fixed fee).
class CreateFlatChargeRequest extends $pb.GeneratedMessage {
  factory CreateFlatChargeRequest({
    $core.String? customerId,
    $core.String? period,
    $core.double? amount,
    $core.String? observation,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (period != null) {
      $result.period = period;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (observation != null) {
      $result.observation = observation;
    }
    return $result;
  }
  CreateFlatChargeRequest._() : super();
  factory CreateFlatChargeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateFlatChargeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateFlatChargeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'observation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateFlatChargeRequest clone() => CreateFlatChargeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateFlatChargeRequest copyWith(void Function(CreateFlatChargeRequest) updates) => super.copyWith((message) => updates(message as CreateFlatChargeRequest)) as CreateFlatChargeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFlatChargeRequest create() => CreateFlatChargeRequest._();
  CreateFlatChargeRequest createEmptyInstance() => create();
  static $pb.PbList<CreateFlatChargeRequest> createRepeated() => $pb.PbList<CreateFlatChargeRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateFlatChargeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateFlatChargeRequest>(create);
  static CreateFlatChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get observation => $_getSZ(3);
  @$pb.TagNumber(4)
  set observation($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasObservation() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservation() => clearField(4);
}

class CreateFlatChargeResponse extends $pb.GeneratedMessage {
  factory CreateFlatChargeResponse({
    $0.Reading? reading,
  }) {
    final $result = create();
    if (reading != null) {
      $result.reading = reading;
    }
    return $result;
  }
  CreateFlatChargeResponse._() : super();
  factory CreateFlatChargeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateFlatChargeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateFlatChargeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Reading>(1, _omitFieldNames ? '' : 'reading', subBuilder: $0.Reading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateFlatChargeResponse clone() => CreateFlatChargeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateFlatChargeResponse copyWith(void Function(CreateFlatChargeResponse) updates) => super.copyWith((message) => updates(message as CreateFlatChargeResponse)) as CreateFlatChargeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFlatChargeResponse create() => CreateFlatChargeResponse._();
  CreateFlatChargeResponse createEmptyInstance() => create();
  static $pb.PbList<CreateFlatChargeResponse> createRepeated() => $pb.PbList<CreateFlatChargeResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateFlatChargeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateFlatChargeResponse>(create);
  static CreateFlatChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Reading get reading => $_getN(0);
  @$pb.TagNumber(1)
  set reading($0.Reading v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReading() => $_has(0);
  @$pb.TagNumber(1)
  void clearReading() => clearField(1);
  @$pb.TagNumber(1)
  $0.Reading ensureReading() => $_ensure(0);
}

class GetCashClosingRequest extends $pb.GeneratedMessage {
  factory GetCashClosingRequest({
    $core.String? dateFrom,
    $core.String? dateTo,
    $core.String? collectedBy,
  }) {
    final $result = create();
    if (dateFrom != null) {
      $result.dateFrom = dateFrom;
    }
    if (dateTo != null) {
      $result.dateTo = dateTo;
    }
    if (collectedBy != null) {
      $result.collectedBy = collectedBy;
    }
    return $result;
  }
  GetCashClosingRequest._() : super();
  factory GetCashClosingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCashClosingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCashClosingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'dateFrom')
    ..aOS(2, _omitFieldNames ? '' : 'dateTo')
    ..aOS(3, _omitFieldNames ? '' : 'collectedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCashClosingRequest clone() => GetCashClosingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCashClosingRequest copyWith(void Function(GetCashClosingRequest) updates) => super.copyWith((message) => updates(message as GetCashClosingRequest)) as GetCashClosingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCashClosingRequest create() => GetCashClosingRequest._();
  GetCashClosingRequest createEmptyInstance() => create();
  static $pb.PbList<GetCashClosingRequest> createRepeated() => $pb.PbList<GetCashClosingRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCashClosingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCashClosingRequest>(create);
  static GetCashClosingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dateFrom => $_getSZ(0);
  @$pb.TagNumber(1)
  set dateFrom($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDateFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearDateFrom() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get dateTo => $_getSZ(1);
  @$pb.TagNumber(2)
  set dateTo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDateTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDateTo() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get collectedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set collectedBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCollectedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCollectedBy() => clearField(3);
}

class MethodTotal extends $pb.GeneratedMessage {
  factory MethodTotal({
    PaymentMethod? method,
    $core.double? amount,
    $core.int? count,
  }) {
    final $result = create();
    if (method != null) {
      $result.method = method;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  MethodTotal._() : super();
  factory MethodTotal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MethodTotal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MethodTotal', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..e<PaymentMethod>(1, _omitFieldNames ? '' : 'method', $pb.PbFieldType.OE, defaultOrMaker: PaymentMethod.PAYMENT_METHOD_UNSPECIFIED, valueOf: PaymentMethod.valueOf, enumValues: PaymentMethod.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MethodTotal clone() => MethodTotal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MethodTotal copyWith(void Function(MethodTotal) updates) => super.copyWith((message) => updates(message as MethodTotal)) as MethodTotal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MethodTotal create() => MethodTotal._();
  MethodTotal createEmptyInstance() => create();
  static $pb.PbList<MethodTotal> createRepeated() => $pb.PbList<MethodTotal>();
  @$core.pragma('dart2js:noInline')
  static MethodTotal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MethodTotal>(create);
  static MethodTotal? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentMethod get method => $_getN(0);
  @$pb.TagNumber(1)
  set method(PaymentMethod v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMethod() => $_has(0);
  @$pb.TagNumber(1)
  void clearMethod() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);
}

class CollectorTotal extends $pb.GeneratedMessage {
  factory CollectorTotal({
    $core.String? collectedBy,
    $core.String? collectedByEmail,
    $core.double? amount,
    $core.int? count,
  }) {
    final $result = create();
    if (collectedBy != null) {
      $result.collectedBy = collectedBy;
    }
    if (collectedByEmail != null) {
      $result.collectedByEmail = collectedByEmail;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  CollectorTotal._() : super();
  factory CollectorTotal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CollectorTotal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CollectorTotal', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectedBy')
    ..aOS(2, _omitFieldNames ? '' : 'collectedByEmail')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CollectorTotal clone() => CollectorTotal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CollectorTotal copyWith(void Function(CollectorTotal) updates) => super.copyWith((message) => updates(message as CollectorTotal)) as CollectorTotal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectorTotal create() => CollectorTotal._();
  CollectorTotal createEmptyInstance() => create();
  static $pb.PbList<CollectorTotal> createRepeated() => $pb.PbList<CollectorTotal>();
  @$core.pragma('dart2js:noInline')
  static CollectorTotal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CollectorTotal>(create);
  static CollectorTotal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectedBy => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectedBy($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCollectedBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectedBy() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get collectedByEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set collectedByEmail($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCollectedByEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollectedByEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => clearField(4);
}

class GetCashClosingResponse extends $pb.GeneratedMessage {
  factory GetCashClosingResponse({
    $core.Iterable<Payment>? payments,
    $core.double? totalAmount,
    $core.int? paymentCount,
    $core.Iterable<MethodTotal>? byMethod,
    $core.Iterable<CollectorTotal>? byCollector,
    $core.double? voidedAmount,
    $core.int? voidedCount,
  }) {
    final $result = create();
    if (payments != null) {
      $result.payments.addAll(payments);
    }
    if (totalAmount != null) {
      $result.totalAmount = totalAmount;
    }
    if (paymentCount != null) {
      $result.paymentCount = paymentCount;
    }
    if (byMethod != null) {
      $result.byMethod.addAll(byMethod);
    }
    if (byCollector != null) {
      $result.byCollector.addAll(byCollector);
    }
    if (voidedAmount != null) {
      $result.voidedAmount = voidedAmount;
    }
    if (voidedCount != null) {
      $result.voidedCount = voidedCount;
    }
    return $result;
  }
  GetCashClosingResponse._() : super();
  factory GetCashClosingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCashClosingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCashClosingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<Payment>(1, _omitFieldNames ? '' : 'payments', $pb.PbFieldType.PM, subBuilder: Payment.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalAmount', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'paymentCount', $pb.PbFieldType.O3)
    ..pc<MethodTotal>(4, _omitFieldNames ? '' : 'byMethod', $pb.PbFieldType.PM, subBuilder: MethodTotal.create)
    ..pc<CollectorTotal>(5, _omitFieldNames ? '' : 'byCollector', $pb.PbFieldType.PM, subBuilder: CollectorTotal.create)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'voidedAmount', $pb.PbFieldType.OD)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'voidedCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCashClosingResponse clone() => GetCashClosingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCashClosingResponse copyWith(void Function(GetCashClosingResponse) updates) => super.copyWith((message) => updates(message as GetCashClosingResponse)) as GetCashClosingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCashClosingResponse create() => GetCashClosingResponse._();
  GetCashClosingResponse createEmptyInstance() => create();
  static $pb.PbList<GetCashClosingResponse> createRepeated() => $pb.PbList<GetCashClosingResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCashClosingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCashClosingResponse>(create);
  static GetCashClosingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Payment> get payments => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get totalAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalAmount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get paymentCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set paymentCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPaymentCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<MethodTotal> get byMethod => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<CollectorTotal> get byCollector => $_getList(4);

  @$pb.TagNumber(6)
  $core.double get voidedAmount => $_getN(5);
  @$pb.TagNumber(6)
  set voidedAmount($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVoidedAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoidedAmount() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get voidedCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set voidedCount($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVoidedCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoidedCount() => clearField(7);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
