//
//  Generated code. Do not modify.
//  source: involt/v1/agreements.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'agreements.pbenum.dart';

export 'agreements.pbenum.dart';

class CollectionPolicy extends $pb.GeneratedMessage {
  factory CollectionPolicy({
    LateFeeMode? lateFeeMode,
    $core.double? lateFeeValue,
    $core.String? lateFeeStartDate,
    $core.int? agreementMaxInstallments,
    $core.double? agreementMinInitialPercent,
    $core.int? agreementGraceDays,
    $core.bool? agreementWaiveLateFees,
    $core.String? updatedAt,
    $core.String? updatedBy,
  }) {
    final $result = create();
    if (lateFeeMode != null) {
      $result.lateFeeMode = lateFeeMode;
    }
    if (lateFeeValue != null) {
      $result.lateFeeValue = lateFeeValue;
    }
    if (lateFeeStartDate != null) {
      $result.lateFeeStartDate = lateFeeStartDate;
    }
    if (agreementMaxInstallments != null) {
      $result.agreementMaxInstallments = agreementMaxInstallments;
    }
    if (agreementMinInitialPercent != null) {
      $result.agreementMinInitialPercent = agreementMinInitialPercent;
    }
    if (agreementGraceDays != null) {
      $result.agreementGraceDays = agreementGraceDays;
    }
    if (agreementWaiveLateFees != null) {
      $result.agreementWaiveLateFees = agreementWaiveLateFees;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (updatedBy != null) {
      $result.updatedBy = updatedBy;
    }
    return $result;
  }
  CollectionPolicy._() : super();
  factory CollectionPolicy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CollectionPolicy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CollectionPolicy', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..e<LateFeeMode>(1, _omitFieldNames ? '' : 'lateFeeMode', $pb.PbFieldType.OE, defaultOrMaker: LateFeeMode.LATE_FEE_MODE_UNSPECIFIED, valueOf: LateFeeMode.valueOf, enumValues: LateFeeMode.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lateFeeValue', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'lateFeeStartDate')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'agreementMaxInstallments', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'agreementMinInitialPercent', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'agreementGraceDays', $pb.PbFieldType.O3)
    ..aOB(7, _omitFieldNames ? '' : 'agreementWaiveLateFees')
    ..aOS(8, _omitFieldNames ? '' : 'updatedAt')
    ..aOS(9, _omitFieldNames ? '' : 'updatedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CollectionPolicy clone() => CollectionPolicy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CollectionPolicy copyWith(void Function(CollectionPolicy) updates) => super.copyWith((message) => updates(message as CollectionPolicy)) as CollectionPolicy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionPolicy create() => CollectionPolicy._();
  CollectionPolicy createEmptyInstance() => create();
  static $pb.PbList<CollectionPolicy> createRepeated() => $pb.PbList<CollectionPolicy>();
  @$core.pragma('dart2js:noInline')
  static CollectionPolicy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CollectionPolicy>(create);
  static CollectionPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  LateFeeMode get lateFeeMode => $_getN(0);
  @$pb.TagNumber(1)
  set lateFeeMode(LateFeeMode v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLateFeeMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLateFeeMode() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lateFeeValue => $_getN(1);
  @$pb.TagNumber(2)
  set lateFeeValue($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLateFeeValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearLateFeeValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get lateFeeStartDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set lateFeeStartDate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLateFeeStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLateFeeStartDate() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get agreementMaxInstallments => $_getIZ(3);
  @$pb.TagNumber(4)
  set agreementMaxInstallments($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAgreementMaxInstallments() => $_has(3);
  @$pb.TagNumber(4)
  void clearAgreementMaxInstallments() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get agreementMinInitialPercent => $_getN(4);
  @$pb.TagNumber(5)
  set agreementMinInitialPercent($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAgreementMinInitialPercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearAgreementMinInitialPercent() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get agreementGraceDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set agreementGraceDays($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAgreementGraceDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearAgreementGraceDays() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get agreementWaiveLateFees => $_getBF(6);
  @$pb.TagNumber(7)
  set agreementWaiveLateFees($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAgreementWaiveLateFees() => $_has(6);
  @$pb.TagNumber(7)
  void clearAgreementWaiveLateFees() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get updatedAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set updatedAt($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get updatedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set updatedBy($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdatedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedBy() => clearField(9);
}

class GetCollectionPolicyRequest extends $pb.GeneratedMessage {
  factory GetCollectionPolicyRequest() => create();
  GetCollectionPolicyRequest._() : super();
  factory GetCollectionPolicyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionPolicyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionPolicyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionPolicyRequest clone() => GetCollectionPolicyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionPolicyRequest copyWith(void Function(GetCollectionPolicyRequest) updates) => super.copyWith((message) => updates(message as GetCollectionPolicyRequest)) as GetCollectionPolicyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionPolicyRequest create() => GetCollectionPolicyRequest._();
  GetCollectionPolicyRequest createEmptyInstance() => create();
  static $pb.PbList<GetCollectionPolicyRequest> createRepeated() => $pb.PbList<GetCollectionPolicyRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionPolicyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionPolicyRequest>(create);
  static GetCollectionPolicyRequest? _defaultInstance;
}

class GetCollectionPolicyResponse extends $pb.GeneratedMessage {
  factory GetCollectionPolicyResponse({
    CollectionPolicy? policy,
  }) {
    final $result = create();
    if (policy != null) {
      $result.policy = policy;
    }
    return $result;
  }
  GetCollectionPolicyResponse._() : super();
  factory GetCollectionPolicyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionPolicyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionPolicyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<CollectionPolicy>(1, _omitFieldNames ? '' : 'policy', subBuilder: CollectionPolicy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionPolicyResponse clone() => GetCollectionPolicyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionPolicyResponse copyWith(void Function(GetCollectionPolicyResponse) updates) => super.copyWith((message) => updates(message as GetCollectionPolicyResponse)) as GetCollectionPolicyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionPolicyResponse create() => GetCollectionPolicyResponse._();
  GetCollectionPolicyResponse createEmptyInstance() => create();
  static $pb.PbList<GetCollectionPolicyResponse> createRepeated() => $pb.PbList<GetCollectionPolicyResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionPolicyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionPolicyResponse>(create);
  static GetCollectionPolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(CollectionPolicy v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => clearField(1);
  @$pb.TagNumber(1)
  CollectionPolicy ensurePolicy() => $_ensure(0);
}

class UpdateCollectionPolicyRequest extends $pb.GeneratedMessage {
  factory UpdateCollectionPolicyRequest({
    CollectionPolicy? policy,
  }) {
    final $result = create();
    if (policy != null) {
      $result.policy = policy;
    }
    return $result;
  }
  UpdateCollectionPolicyRequest._() : super();
  factory UpdateCollectionPolicyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCollectionPolicyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateCollectionPolicyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<CollectionPolicy>(1, _omitFieldNames ? '' : 'policy', subBuilder: CollectionPolicy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCollectionPolicyRequest clone() => UpdateCollectionPolicyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCollectionPolicyRequest copyWith(void Function(UpdateCollectionPolicyRequest) updates) => super.copyWith((message) => updates(message as UpdateCollectionPolicyRequest)) as UpdateCollectionPolicyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateCollectionPolicyRequest create() => UpdateCollectionPolicyRequest._();
  UpdateCollectionPolicyRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCollectionPolicyRequest> createRepeated() => $pb.PbList<UpdateCollectionPolicyRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCollectionPolicyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCollectionPolicyRequest>(create);
  static UpdateCollectionPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(CollectionPolicy v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => clearField(1);
  @$pb.TagNumber(1)
  CollectionPolicy ensurePolicy() => $_ensure(0);
}

class UpdateCollectionPolicyResponse extends $pb.GeneratedMessage {
  factory UpdateCollectionPolicyResponse({
    CollectionPolicy? policy,
  }) {
    final $result = create();
    if (policy != null) {
      $result.policy = policy;
    }
    return $result;
  }
  UpdateCollectionPolicyResponse._() : super();
  factory UpdateCollectionPolicyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCollectionPolicyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateCollectionPolicyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<CollectionPolicy>(1, _omitFieldNames ? '' : 'policy', subBuilder: CollectionPolicy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCollectionPolicyResponse clone() => UpdateCollectionPolicyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCollectionPolicyResponse copyWith(void Function(UpdateCollectionPolicyResponse) updates) => super.copyWith((message) => updates(message as UpdateCollectionPolicyResponse)) as UpdateCollectionPolicyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateCollectionPolicyResponse create() => UpdateCollectionPolicyResponse._();
  UpdateCollectionPolicyResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCollectionPolicyResponse> createRepeated() => $pb.PbList<UpdateCollectionPolicyResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCollectionPolicyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCollectionPolicyResponse>(create);
  static UpdateCollectionPolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(CollectionPolicy v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => clearField(1);
  @$pb.TagNumber(1)
  CollectionPolicy ensurePolicy() => $_ensure(0);
}

class AgreementReceipt extends $pb.GeneratedMessage {
  factory AgreementReceipt({
    $core.String? readingId,
    $core.String? period,
    $core.double? principal,
    $core.double? lateFee,
  }) {
    final $result = create();
    if (readingId != null) {
      $result.readingId = readingId;
    }
    if (period != null) {
      $result.period = period;
    }
    if (principal != null) {
      $result.principal = principal;
    }
    if (lateFee != null) {
      $result.lateFee = lateFee;
    }
    return $result;
  }
  AgreementReceipt._() : super();
  factory AgreementReceipt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgreementReceipt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgreementReceipt', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'principal', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'lateFee', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgreementReceipt clone() => AgreementReceipt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgreementReceipt copyWith(void Function(AgreementReceipt) updates) => super.copyWith((message) => updates(message as AgreementReceipt)) as AgreementReceipt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgreementReceipt create() => AgreementReceipt._();
  AgreementReceipt createEmptyInstance() => create();
  static $pb.PbList<AgreementReceipt> createRepeated() => $pb.PbList<AgreementReceipt>();
  @$core.pragma('dart2js:noInline')
  static AgreementReceipt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgreementReceipt>(create);
  static AgreementReceipt? _defaultInstance;

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
  $core.double get principal => $_getN(2);
  @$pb.TagNumber(3)
  set principal($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrincipal() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrincipal() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get lateFee => $_getN(3);
  @$pb.TagNumber(4)
  set lateFee($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLateFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearLateFee() => clearField(4);
}

class AgreementInstallment extends $pb.GeneratedMessage {
  factory AgreementInstallment({
    $core.int? number,
    $core.String? dueDate,
    $core.double? amount,
    $core.bool? paid,
  }) {
    final $result = create();
    if (number != null) {
      $result.number = number;
    }
    if (dueDate != null) {
      $result.dueDate = dueDate;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (paid != null) {
      $result.paid = paid;
    }
    return $result;
  }
  AgreementInstallment._() : super();
  factory AgreementInstallment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgreementInstallment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgreementInstallment', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'number', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'dueDate')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOB(4, _omitFieldNames ? '' : 'paid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgreementInstallment clone() => AgreementInstallment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgreementInstallment copyWith(void Function(AgreementInstallment) updates) => super.copyWith((message) => updates(message as AgreementInstallment)) as AgreementInstallment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgreementInstallment create() => AgreementInstallment._();
  AgreementInstallment createEmptyInstance() => create();
  static $pb.PbList<AgreementInstallment> createRepeated() => $pb.PbList<AgreementInstallment>();
  @$core.pragma('dart2js:noInline')
  static AgreementInstallment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgreementInstallment>(create);
  static AgreementInstallment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get number => $_getIZ(0);
  @$pb.TagNumber(1)
  set number($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get dueDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set dueDate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDueDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDueDate() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get paid => $_getBF(3);
  @$pb.TagNumber(4)
  set paid($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPaid() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaid() => clearField(4);
}

class PaymentAgreement extends $pb.GeneratedMessage {
  factory PaymentAgreement({
    $core.String? id,
    $fixnum.Int64? number,
    $core.String? customerId,
    $core.String? customerName,
    $core.String? customerCode,
    AgreementStatus? status,
    $core.double? total,
    $core.double? initialAmount,
    $core.double? paid,
    $core.String? notes,
    $core.String? createdAt,
    $core.String? createdByEmail,
    $core.String? cancelledAt,
    $core.String? cancelReason,
    $core.Iterable<AgreementReceipt>? receipts,
    $core.Iterable<AgreementInstallment>? installments,
    $core.int? nextInstallment,
    $core.double? nextAmount,
    $core.String? nextDueDate,
    $core.double? overdueAmount,
    $core.bool? lateFeesWaived,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (number != null) {
      $result.number = number;
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
    if (status != null) {
      $result.status = status;
    }
    if (total != null) {
      $result.total = total;
    }
    if (initialAmount != null) {
      $result.initialAmount = initialAmount;
    }
    if (paid != null) {
      $result.paid = paid;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (createdByEmail != null) {
      $result.createdByEmail = createdByEmail;
    }
    if (cancelledAt != null) {
      $result.cancelledAt = cancelledAt;
    }
    if (cancelReason != null) {
      $result.cancelReason = cancelReason;
    }
    if (receipts != null) {
      $result.receipts.addAll(receipts);
    }
    if (installments != null) {
      $result.installments.addAll(installments);
    }
    if (nextInstallment != null) {
      $result.nextInstallment = nextInstallment;
    }
    if (nextAmount != null) {
      $result.nextAmount = nextAmount;
    }
    if (nextDueDate != null) {
      $result.nextDueDate = nextDueDate;
    }
    if (overdueAmount != null) {
      $result.overdueAmount = overdueAmount;
    }
    if (lateFeesWaived != null) {
      $result.lateFeesWaived = lateFeesWaived;
    }
    return $result;
  }
  PaymentAgreement._() : super();
  factory PaymentAgreement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaymentAgreement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PaymentAgreement', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'customerId')
    ..aOS(4, _omitFieldNames ? '' : 'customerName')
    ..aOS(5, _omitFieldNames ? '' : 'customerCode')
    ..e<AgreementStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: AgreementStatus.AGREEMENT_STATUS_UNSPECIFIED, valueOf: AgreementStatus.valueOf, enumValues: AgreementStatus.values)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'initialAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'paid', $pb.PbFieldType.OD)
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..aOS(11, _omitFieldNames ? '' : 'createdAt')
    ..aOS(12, _omitFieldNames ? '' : 'createdByEmail')
    ..aOS(13, _omitFieldNames ? '' : 'cancelledAt')
    ..aOS(14, _omitFieldNames ? '' : 'cancelReason')
    ..pc<AgreementReceipt>(15, _omitFieldNames ? '' : 'receipts', $pb.PbFieldType.PM, subBuilder: AgreementReceipt.create)
    ..pc<AgreementInstallment>(16, _omitFieldNames ? '' : 'installments', $pb.PbFieldType.PM, subBuilder: AgreementInstallment.create)
    ..a<$core.int>(17, _omitFieldNames ? '' : 'nextInstallment', $pb.PbFieldType.O3)
    ..a<$core.double>(18, _omitFieldNames ? '' : 'nextAmount', $pb.PbFieldType.OD)
    ..aOS(19, _omitFieldNames ? '' : 'nextDueDate')
    ..a<$core.double>(20, _omitFieldNames ? '' : 'overdueAmount', $pb.PbFieldType.OD)
    ..aOB(21, _omitFieldNames ? '' : 'lateFeesWaived')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaymentAgreement clone() => PaymentAgreement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaymentAgreement copyWith(void Function(PaymentAgreement) updates) => super.copyWith((message) => updates(message as PaymentAgreement)) as PaymentAgreement;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentAgreement create() => PaymentAgreement._();
  PaymentAgreement createEmptyInstance() => create();
  static $pb.PbList<PaymentAgreement> createRepeated() => $pb.PbList<PaymentAgreement>();
  @$core.pragma('dart2js:noInline')
  static PaymentAgreement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaymentAgreement>(create);
  static PaymentAgreement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get number => $_getI64(1);
  @$pb.TagNumber(2)
  set number($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => clearField(2);

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
  AgreementStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(AgreementStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get total => $_getN(6);
  @$pb.TagNumber(7)
  set total($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotal() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotal() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get initialAmount => $_getN(7);
  @$pb.TagNumber(8)
  set initialAmount($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInitialAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearInitialAmount() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get paid => $_getN(8);
  @$pb.TagNumber(9)
  set paid($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPaid() => $_has(8);
  @$pb.TagNumber(9)
  void clearPaid() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get createdAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set createdAt($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get createdByEmail => $_getSZ(11);
  @$pb.TagNumber(12)
  set createdByEmail($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasCreatedByEmail() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedByEmail() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get cancelledAt => $_getSZ(12);
  @$pb.TagNumber(13)
  set cancelledAt($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasCancelledAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCancelledAt() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get cancelReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set cancelReason($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasCancelReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearCancelReason() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<AgreementReceipt> get receipts => $_getList(14);

  @$pb.TagNumber(16)
  $core.List<AgreementInstallment> get installments => $_getList(15);

  @$pb.TagNumber(17)
  $core.int get nextInstallment => $_getIZ(16);
  @$pb.TagNumber(17)
  set nextInstallment($core.int v) { $_setSignedInt32(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasNextInstallment() => $_has(16);
  @$pb.TagNumber(17)
  void clearNextInstallment() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get nextAmount => $_getN(17);
  @$pb.TagNumber(18)
  set nextAmount($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasNextAmount() => $_has(17);
  @$pb.TagNumber(18)
  void clearNextAmount() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get nextDueDate => $_getSZ(18);
  @$pb.TagNumber(19)
  set nextDueDate($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasNextDueDate() => $_has(18);
  @$pb.TagNumber(19)
  void clearNextDueDate() => clearField(19);

  @$pb.TagNumber(20)
  $core.double get overdueAmount => $_getN(19);
  @$pb.TagNumber(20)
  set overdueAmount($core.double v) { $_setDouble(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasOverdueAmount() => $_has(19);
  @$pb.TagNumber(20)
  void clearOverdueAmount() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get lateFeesWaived => $_getBF(20);
  @$pb.TagNumber(21)
  set lateFeesWaived($core.bool v) { $_setBool(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasLateFeesWaived() => $_has(20);
  @$pb.TagNumber(21)
  void clearLateFeesWaived() => clearField(21);
}

class AgreementRequest extends $pb.GeneratedMessage {
  factory AgreementRequest({
    $core.String? customerId,
    $core.Iterable<$core.String>? readingIds,
    $core.int? installments,
    $core.double? initialAmount,
    $core.String? firstDueDate,
    $core.String? notes,
    $core.int? initialPaymentMethod,
    $core.String? initialPaymentReference,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (readingIds != null) {
      $result.readingIds.addAll(readingIds);
    }
    if (installments != null) {
      $result.installments = installments;
    }
    if (initialAmount != null) {
      $result.initialAmount = initialAmount;
    }
    if (firstDueDate != null) {
      $result.firstDueDate = firstDueDate;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (initialPaymentMethod != null) {
      $result.initialPaymentMethod = initialPaymentMethod;
    }
    if (initialPaymentReference != null) {
      $result.initialPaymentReference = initialPaymentReference;
    }
    return $result;
  }
  AgreementRequest._() : super();
  factory AgreementRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgreementRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgreementRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..pPS(2, _omitFieldNames ? '' : 'readingIds')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'installments', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'initialAmount', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'firstDueDate')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'initialPaymentMethod', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'initialPaymentReference')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgreementRequest clone() => AgreementRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgreementRequest copyWith(void Function(AgreementRequest) updates) => super.copyWith((message) => updates(message as AgreementRequest)) as AgreementRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgreementRequest create() => AgreementRequest._();
  AgreementRequest createEmptyInstance() => create();
  static $pb.PbList<AgreementRequest> createRepeated() => $pb.PbList<AgreementRequest>();
  @$core.pragma('dart2js:noInline')
  static AgreementRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgreementRequest>(create);
  static AgreementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get readingIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get installments => $_getIZ(2);
  @$pb.TagNumber(3)
  set installments($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInstallments() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstallments() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get initialAmount => $_getN(3);
  @$pb.TagNumber(4)
  set initialAmount($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInitialAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearInitialAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get firstDueDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set firstDueDate($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFirstDueDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearFirstDueDate() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get initialPaymentMethod => $_getIZ(6);
  @$pb.TagNumber(7)
  set initialPaymentMethod($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasInitialPaymentMethod() => $_has(6);
  @$pb.TagNumber(7)
  void clearInitialPaymentMethod() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get initialPaymentReference => $_getSZ(7);
  @$pb.TagNumber(8)
  set initialPaymentReference($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInitialPaymentReference() => $_has(7);
  @$pb.TagNumber(8)
  void clearInitialPaymentReference() => clearField(8);
}

class PreviewAgreementResponse extends $pb.GeneratedMessage {
  factory PreviewAgreementResponse({
    $core.double? total,
    $core.double? principal,
    $core.double? lateFees,
    $core.double? minInitialAmount,
    $core.int? maxInstallments,
    $core.bool? lateFeesWaived,
    $core.Iterable<AgreementReceipt>? receipts,
    $core.Iterable<AgreementInstallment>? installments,
    $core.String? validationError,
  }) {
    final $result = create();
    if (total != null) {
      $result.total = total;
    }
    if (principal != null) {
      $result.principal = principal;
    }
    if (lateFees != null) {
      $result.lateFees = lateFees;
    }
    if (minInitialAmount != null) {
      $result.minInitialAmount = minInitialAmount;
    }
    if (maxInstallments != null) {
      $result.maxInstallments = maxInstallments;
    }
    if (lateFeesWaived != null) {
      $result.lateFeesWaived = lateFeesWaived;
    }
    if (receipts != null) {
      $result.receipts.addAll(receipts);
    }
    if (installments != null) {
      $result.installments.addAll(installments);
    }
    if (validationError != null) {
      $result.validationError = validationError;
    }
    return $result;
  }
  PreviewAgreementResponse._() : super();
  factory PreviewAgreementResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewAgreementResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreviewAgreementResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'principal', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'lateFees', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'minInitialAmount', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'maxInstallments', $pb.PbFieldType.O3)
    ..aOB(6, _omitFieldNames ? '' : 'lateFeesWaived')
    ..pc<AgreementReceipt>(7, _omitFieldNames ? '' : 'receipts', $pb.PbFieldType.PM, subBuilder: AgreementReceipt.create)
    ..pc<AgreementInstallment>(8, _omitFieldNames ? '' : 'installments', $pb.PbFieldType.PM, subBuilder: AgreementInstallment.create)
    ..aOS(9, _omitFieldNames ? '' : 'validationError')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewAgreementResponse clone() => PreviewAgreementResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewAgreementResponse copyWith(void Function(PreviewAgreementResponse) updates) => super.copyWith((message) => updates(message as PreviewAgreementResponse)) as PreviewAgreementResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewAgreementResponse create() => PreviewAgreementResponse._();
  PreviewAgreementResponse createEmptyInstance() => create();
  static $pb.PbList<PreviewAgreementResponse> createRepeated() => $pb.PbList<PreviewAgreementResponse>();
  @$core.pragma('dart2js:noInline')
  static PreviewAgreementResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewAgreementResponse>(create);
  static PreviewAgreementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get total => $_getN(0);
  @$pb.TagNumber(1)
  set total($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get principal => $_getN(1);
  @$pb.TagNumber(2)
  set principal($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrincipal() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipal() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get lateFees => $_getN(2);
  @$pb.TagNumber(3)
  set lateFees($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLateFees() => $_has(2);
  @$pb.TagNumber(3)
  void clearLateFees() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get minInitialAmount => $_getN(3);
  @$pb.TagNumber(4)
  set minInitialAmount($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinInitialAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinInitialAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxInstallments => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxInstallments($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxInstallments() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxInstallments() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get lateFeesWaived => $_getBF(5);
  @$pb.TagNumber(6)
  set lateFeesWaived($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLateFeesWaived() => $_has(5);
  @$pb.TagNumber(6)
  void clearLateFeesWaived() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<AgreementReceipt> get receipts => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<AgreementInstallment> get installments => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get validationError => $_getSZ(8);
  @$pb.TagNumber(9)
  set validationError($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasValidationError() => $_has(8);
  @$pb.TagNumber(9)
  void clearValidationError() => clearField(9);
}

class CreateAgreementResponse extends $pb.GeneratedMessage {
  factory CreateAgreementResponse({
    PaymentAgreement? agreement,
    $core.String? initialPaymentId,
  }) {
    final $result = create();
    if (agreement != null) {
      $result.agreement = agreement;
    }
    if (initialPaymentId != null) {
      $result.initialPaymentId = initialPaymentId;
    }
    return $result;
  }
  CreateAgreementResponse._() : super();
  factory CreateAgreementResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateAgreementResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAgreementResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<PaymentAgreement>(1, _omitFieldNames ? '' : 'agreement', subBuilder: PaymentAgreement.create)
    ..aOS(2, _omitFieldNames ? '' : 'initialPaymentId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateAgreementResponse clone() => CreateAgreementResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateAgreementResponse copyWith(void Function(CreateAgreementResponse) updates) => super.copyWith((message) => updates(message as CreateAgreementResponse)) as CreateAgreementResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAgreementResponse create() => CreateAgreementResponse._();
  CreateAgreementResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAgreementResponse> createRepeated() => $pb.PbList<CreateAgreementResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateAgreementResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAgreementResponse>(create);
  static CreateAgreementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentAgreement get agreement => $_getN(0);
  @$pb.TagNumber(1)
  set agreement(PaymentAgreement v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgreement() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgreement() => clearField(1);
  @$pb.TagNumber(1)
  PaymentAgreement ensureAgreement() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get initialPaymentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set initialPaymentId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInitialPaymentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialPaymentId() => clearField(2);
}

class CancelAgreementRequest extends $pb.GeneratedMessage {
  factory CancelAgreementRequest({
    $core.String? agreementId,
    $core.String? reason,
  }) {
    final $result = create();
    if (agreementId != null) {
      $result.agreementId = agreementId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  CancelAgreementRequest._() : super();
  factory CancelAgreementRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelAgreementRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelAgreementRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'agreementId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelAgreementRequest clone() => CancelAgreementRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelAgreementRequest copyWith(void Function(CancelAgreementRequest) updates) => super.copyWith((message) => updates(message as CancelAgreementRequest)) as CancelAgreementRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelAgreementRequest create() => CancelAgreementRequest._();
  CancelAgreementRequest createEmptyInstance() => create();
  static $pb.PbList<CancelAgreementRequest> createRepeated() => $pb.PbList<CancelAgreementRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelAgreementRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelAgreementRequest>(create);
  static CancelAgreementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agreementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set agreementId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgreementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgreementId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class CancelAgreementResponse extends $pb.GeneratedMessage {
  factory CancelAgreementResponse({
    PaymentAgreement? agreement,
  }) {
    final $result = create();
    if (agreement != null) {
      $result.agreement = agreement;
    }
    return $result;
  }
  CancelAgreementResponse._() : super();
  factory CancelAgreementResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelAgreementResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelAgreementResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<PaymentAgreement>(1, _omitFieldNames ? '' : 'agreement', subBuilder: PaymentAgreement.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelAgreementResponse clone() => CancelAgreementResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelAgreementResponse copyWith(void Function(CancelAgreementResponse) updates) => super.copyWith((message) => updates(message as CancelAgreementResponse)) as CancelAgreementResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelAgreementResponse create() => CancelAgreementResponse._();
  CancelAgreementResponse createEmptyInstance() => create();
  static $pb.PbList<CancelAgreementResponse> createRepeated() => $pb.PbList<CancelAgreementResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelAgreementResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelAgreementResponse>(create);
  static CancelAgreementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentAgreement get agreement => $_getN(0);
  @$pb.TagNumber(1)
  set agreement(PaymentAgreement v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAgreement() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgreement() => clearField(1);
  @$pb.TagNumber(1)
  PaymentAgreement ensureAgreement() => $_ensure(0);
}

class WaiveLateFeeRequest extends $pb.GeneratedMessage {
  factory WaiveLateFeeRequest({
    $core.Iterable<$core.String>? readingIds,
    $core.String? reason,
  }) {
    final $result = create();
    if (readingIds != null) {
      $result.readingIds.addAll(readingIds);
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  WaiveLateFeeRequest._() : super();
  factory WaiveLateFeeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WaiveLateFeeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WaiveLateFeeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'readingIds')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WaiveLateFeeRequest clone() => WaiveLateFeeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WaiveLateFeeRequest copyWith(void Function(WaiveLateFeeRequest) updates) => super.copyWith((message) => updates(message as WaiveLateFeeRequest)) as WaiveLateFeeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveLateFeeRequest create() => WaiveLateFeeRequest._();
  WaiveLateFeeRequest createEmptyInstance() => create();
  static $pb.PbList<WaiveLateFeeRequest> createRepeated() => $pb.PbList<WaiveLateFeeRequest>();
  @$core.pragma('dart2js:noInline')
  static WaiveLateFeeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WaiveLateFeeRequest>(create);
  static WaiveLateFeeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get readingIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class WaiveLateFeeResponse extends $pb.GeneratedMessage {
  factory WaiveLateFeeResponse({
    $core.int? waived,
  }) {
    final $result = create();
    if (waived != null) {
      $result.waived = waived;
    }
    return $result;
  }
  WaiveLateFeeResponse._() : super();
  factory WaiveLateFeeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WaiveLateFeeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WaiveLateFeeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'waived', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WaiveLateFeeResponse clone() => WaiveLateFeeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WaiveLateFeeResponse copyWith(void Function(WaiveLateFeeResponse) updates) => super.copyWith((message) => updates(message as WaiveLateFeeResponse)) as WaiveLateFeeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveLateFeeResponse create() => WaiveLateFeeResponse._();
  WaiveLateFeeResponse createEmptyInstance() => create();
  static $pb.PbList<WaiveLateFeeResponse> createRepeated() => $pb.PbList<WaiveLateFeeResponse>();
  @$core.pragma('dart2js:noInline')
  static WaiveLateFeeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WaiveLateFeeResponse>(create);
  static WaiveLateFeeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get waived => $_getIZ(0);
  @$pb.TagNumber(1)
  set waived($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWaived() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaived() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
