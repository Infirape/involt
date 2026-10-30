//
//  Generated code. Do not modify.
//  source: involt/v1/reports.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pbenum.dart' as $0;
import 'reports.pbenum.dart';

export 'reports.pbenum.dart';

class AgingTotal extends $pb.GeneratedMessage {
  factory AgingTotal({
    AgingBucket? bucket,
    $core.double? amount,
    $core.int? receipts,
    $core.int? customers,
  }) {
    final $result = create();
    if (bucket != null) {
      $result.bucket = bucket;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (receipts != null) {
      $result.receipts = receipts;
    }
    if (customers != null) {
      $result.customers = customers;
    }
    return $result;
  }
  AgingTotal._() : super();
  factory AgingTotal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgingTotal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgingTotal', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..e<AgingBucket>(1, _omitFieldNames ? '' : 'bucket', $pb.PbFieldType.OE, defaultOrMaker: AgingBucket.AGING_BUCKET_UNSPECIFIED, valueOf: AgingBucket.valueOf, enumValues: AgingBucket.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'receipts', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgingTotal clone() => AgingTotal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgingTotal copyWith(void Function(AgingTotal) updates) => super.copyWith((message) => updates(message as AgingTotal)) as AgingTotal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgingTotal create() => AgingTotal._();
  AgingTotal createEmptyInstance() => create();
  static $pb.PbList<AgingTotal> createRepeated() => $pb.PbList<AgingTotal>();
  @$core.pragma('dart2js:noInline')
  static AgingTotal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgingTotal>(create);
  static AgingTotal? _defaultInstance;

  @$pb.TagNumber(1)
  AgingBucket get bucket => $_getN(0);
  @$pb.TagNumber(1)
  set bucket(AgingBucket v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBucket() => $_has(0);
  @$pb.TagNumber(1)
  void clearBucket() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get receipts => $_getIZ(2);
  @$pb.TagNumber(3)
  set receipts($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceipts() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceipts() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get customers => $_getIZ(3);
  @$pb.TagNumber(4)
  set customers($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustomers() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomers() => clearField(4);
}

class SectorCollectionSummary extends $pb.GeneratedMessage {
  factory SectorCollectionSummary({
    $core.String? sectorId,
    $core.String? sectorName,
    $core.String? communityId,
    $core.String? communityName,
    $core.double? billed,
    $core.double? collected,
    $core.double? debt,
    $core.int? customers,
    $core.int? debtors,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (sectorName != null) {
      $result.sectorName = sectorName;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (communityName != null) {
      $result.communityName = communityName;
    }
    if (billed != null) {
      $result.billed = billed;
    }
    if (collected != null) {
      $result.collected = collected;
    }
    if (debt != null) {
      $result.debt = debt;
    }
    if (customers != null) {
      $result.customers = customers;
    }
    if (debtors != null) {
      $result.debtors = debtors;
    }
    return $result;
  }
  SectorCollectionSummary._() : super();
  factory SectorCollectionSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SectorCollectionSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SectorCollectionSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorName')
    ..aOS(3, _omitFieldNames ? '' : 'communityId')
    ..aOS(4, _omitFieldNames ? '' : 'communityName')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'billed', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'collected', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'debt', $pb.PbFieldType.OD)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.O3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'debtors', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SectorCollectionSummary clone() => SectorCollectionSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SectorCollectionSummary copyWith(void Function(SectorCollectionSummary) updates) => super.copyWith((message) => updates(message as SectorCollectionSummary)) as SectorCollectionSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SectorCollectionSummary create() => SectorCollectionSummary._();
  SectorCollectionSummary createEmptyInstance() => create();
  static $pb.PbList<SectorCollectionSummary> createRepeated() => $pb.PbList<SectorCollectionSummary>();
  @$core.pragma('dart2js:noInline')
  static SectorCollectionSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SectorCollectionSummary>(create);
  static SectorCollectionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sectorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sectorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSectorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSectorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectorName => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectorName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSectorName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectorName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get communityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set communityId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommunityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommunityId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get communityName => $_getSZ(3);
  @$pb.TagNumber(4)
  set communityName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCommunityName() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommunityName() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get billed => $_getN(4);
  @$pb.TagNumber(5)
  set billed($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBilled() => $_has(4);
  @$pb.TagNumber(5)
  void clearBilled() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get collected => $_getN(5);
  @$pb.TagNumber(6)
  set collected($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCollected() => $_has(5);
  @$pb.TagNumber(6)
  void clearCollected() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get debt => $_getN(6);
  @$pb.TagNumber(7)
  set debt($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDebt() => $_has(6);
  @$pb.TagNumber(7)
  void clearDebt() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get customers => $_getIZ(7);
  @$pb.TagNumber(8)
  set customers($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCustomers() => $_has(7);
  @$pb.TagNumber(8)
  void clearCustomers() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get debtors => $_getIZ(8);
  @$pb.TagNumber(9)
  set debtors($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDebtors() => $_has(8);
  @$pb.TagNumber(9)
  void clearDebtors() => clearField(9);
}

class PeriodCollectionSummary extends $pb.GeneratedMessage {
  factory PeriodCollectionSummary({
    $core.String? period,
    $core.double? billed,
    $core.double? collected,
    $core.double? cashIn,
  }) {
    final $result = create();
    if (period != null) {
      $result.period = period;
    }
    if (billed != null) {
      $result.billed = billed;
    }
    if (collected != null) {
      $result.collected = collected;
    }
    if (cashIn != null) {
      $result.cashIn = cashIn;
    }
    return $result;
  }
  PeriodCollectionSummary._() : super();
  factory PeriodCollectionSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PeriodCollectionSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PeriodCollectionSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'billed', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'collected', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cashIn', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PeriodCollectionSummary clone() => PeriodCollectionSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PeriodCollectionSummary copyWith(void Function(PeriodCollectionSummary) updates) => super.copyWith((message) => updates(message as PeriodCollectionSummary)) as PeriodCollectionSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeriodCollectionSummary create() => PeriodCollectionSummary._();
  PeriodCollectionSummary createEmptyInstance() => create();
  static $pb.PbList<PeriodCollectionSummary> createRepeated() => $pb.PbList<PeriodCollectionSummary>();
  @$core.pragma('dart2js:noInline')
  static PeriodCollectionSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeriodCollectionSummary>(create);
  static PeriodCollectionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get period => $_getSZ(0);
  @$pb.TagNumber(1)
  set period($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get billed => $_getN(1);
  @$pb.TagNumber(2)
  set billed($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBilled() => $_has(1);
  @$pb.TagNumber(2)
  void clearBilled() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get collected => $_getN(2);
  @$pb.TagNumber(3)
  set collected($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCollected() => $_has(2);
  @$pb.TagNumber(3)
  void clearCollected() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get cashIn => $_getN(3);
  @$pb.TagNumber(4)
  set cashIn($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCashIn() => $_has(3);
  @$pb.TagNumber(4)
  void clearCashIn() => clearField(4);
}

class CollectionsDashboardTotals extends $pb.GeneratedMessage {
  factory CollectionsDashboardTotals({
    $core.double? billed,
    $core.double? collected,
    $core.double? totalDebt,
    $core.double? overdueDebt,
    $core.int? debtorCount,
    $core.int? cutCandidates,
    $core.int? temporaryCutCount,
    $core.int? noPowerCount,
  }) {
    final $result = create();
    if (billed != null) {
      $result.billed = billed;
    }
    if (collected != null) {
      $result.collected = collected;
    }
    if (totalDebt != null) {
      $result.totalDebt = totalDebt;
    }
    if (overdueDebt != null) {
      $result.overdueDebt = overdueDebt;
    }
    if (debtorCount != null) {
      $result.debtorCount = debtorCount;
    }
    if (cutCandidates != null) {
      $result.cutCandidates = cutCandidates;
    }
    if (temporaryCutCount != null) {
      $result.temporaryCutCount = temporaryCutCount;
    }
    if (noPowerCount != null) {
      $result.noPowerCount = noPowerCount;
    }
    return $result;
  }
  CollectionsDashboardTotals._() : super();
  factory CollectionsDashboardTotals.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CollectionsDashboardTotals.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CollectionsDashboardTotals', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'billed', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'collected', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalDebt', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'overdueDebt', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'debtorCount', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'cutCandidates', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'temporaryCutCount', $pb.PbFieldType.O3)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'noPowerCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CollectionsDashboardTotals clone() => CollectionsDashboardTotals()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CollectionsDashboardTotals copyWith(void Function(CollectionsDashboardTotals) updates) => super.copyWith((message) => updates(message as CollectionsDashboardTotals)) as CollectionsDashboardTotals;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionsDashboardTotals create() => CollectionsDashboardTotals._();
  CollectionsDashboardTotals createEmptyInstance() => create();
  static $pb.PbList<CollectionsDashboardTotals> createRepeated() => $pb.PbList<CollectionsDashboardTotals>();
  @$core.pragma('dart2js:noInline')
  static CollectionsDashboardTotals getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CollectionsDashboardTotals>(create);
  static CollectionsDashboardTotals? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get billed => $_getN(0);
  @$pb.TagNumber(1)
  set billed($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBilled() => $_has(0);
  @$pb.TagNumber(1)
  void clearBilled() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get collected => $_getN(1);
  @$pb.TagNumber(2)
  set collected($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCollected() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollected() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalDebt => $_getN(2);
  @$pb.TagNumber(3)
  set totalDebt($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalDebt() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalDebt() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get overdueDebt => $_getN(3);
  @$pb.TagNumber(4)
  set overdueDebt($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOverdueDebt() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverdueDebt() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get debtorCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set debtorCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDebtorCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDebtorCount() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get cutCandidates => $_getIZ(5);
  @$pb.TagNumber(6)
  set cutCandidates($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCutCandidates() => $_has(5);
  @$pb.TagNumber(6)
  void clearCutCandidates() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get temporaryCutCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set temporaryCutCount($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTemporaryCutCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearTemporaryCutCount() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get noPowerCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set noPowerCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasNoPowerCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearNoPowerCount() => clearField(8);
}

class GetCollectionsDashboardRequest extends $pb.GeneratedMessage {
  factory GetCollectionsDashboardRequest({
    $core.String? fromPeriod,
    $core.String? toPeriod,
    $core.String? communityId,
    $core.int? cutThreshold,
    $core.String? sectorId,
  }) {
    final $result = create();
    if (fromPeriod != null) {
      $result.fromPeriod = fromPeriod;
    }
    if (toPeriod != null) {
      $result.toPeriod = toPeriod;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (cutThreshold != null) {
      $result.cutThreshold = cutThreshold;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    return $result;
  }
  GetCollectionsDashboardRequest._() : super();
  factory GetCollectionsDashboardRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionsDashboardRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionsDashboardRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromPeriod')
    ..aOS(2, _omitFieldNames ? '' : 'toPeriod')
    ..aOS(3, _omitFieldNames ? '' : 'communityId')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'cutThreshold', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'sectorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionsDashboardRequest clone() => GetCollectionsDashboardRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionsDashboardRequest copyWith(void Function(GetCollectionsDashboardRequest) updates) => super.copyWith((message) => updates(message as GetCollectionsDashboardRequest)) as GetCollectionsDashboardRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionsDashboardRequest create() => GetCollectionsDashboardRequest._();
  GetCollectionsDashboardRequest createEmptyInstance() => create();
  static $pb.PbList<GetCollectionsDashboardRequest> createRepeated() => $pb.PbList<GetCollectionsDashboardRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionsDashboardRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionsDashboardRequest>(create);
  static GetCollectionsDashboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromPeriod => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromPeriod($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromPeriod() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get toPeriod => $_getSZ(1);
  @$pb.TagNumber(2)
  set toPeriod($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearToPeriod() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get communityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set communityId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommunityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommunityId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get cutThreshold => $_getIZ(3);
  @$pb.TagNumber(4)
  set cutThreshold($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCutThreshold() => $_has(3);
  @$pb.TagNumber(4)
  void clearCutThreshold() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sectorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sectorId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSectorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSectorId() => clearField(5);
}

class GetCollectionsDashboardResponse extends $pb.GeneratedMessage {
  factory GetCollectionsDashboardResponse({
    CollectionsDashboardTotals? totals,
    $core.Iterable<SectorCollectionSummary>? bySector,
    $core.Iterable<PeriodCollectionSummary>? byPeriod,
    $core.Iterable<AgingTotal>? aging,
    $core.String? fromPeriod,
    $core.String? toPeriod,
  }) {
    final $result = create();
    if (totals != null) {
      $result.totals = totals;
    }
    if (bySector != null) {
      $result.bySector.addAll(bySector);
    }
    if (byPeriod != null) {
      $result.byPeriod.addAll(byPeriod);
    }
    if (aging != null) {
      $result.aging.addAll(aging);
    }
    if (fromPeriod != null) {
      $result.fromPeriod = fromPeriod;
    }
    if (toPeriod != null) {
      $result.toPeriod = toPeriod;
    }
    return $result;
  }
  GetCollectionsDashboardResponse._() : super();
  factory GetCollectionsDashboardResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionsDashboardResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionsDashboardResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<CollectionsDashboardTotals>(1, _omitFieldNames ? '' : 'totals', subBuilder: CollectionsDashboardTotals.create)
    ..pc<SectorCollectionSummary>(2, _omitFieldNames ? '' : 'bySector', $pb.PbFieldType.PM, subBuilder: SectorCollectionSummary.create)
    ..pc<PeriodCollectionSummary>(3, _omitFieldNames ? '' : 'byPeriod', $pb.PbFieldType.PM, subBuilder: PeriodCollectionSummary.create)
    ..pc<AgingTotal>(4, _omitFieldNames ? '' : 'aging', $pb.PbFieldType.PM, subBuilder: AgingTotal.create)
    ..aOS(5, _omitFieldNames ? '' : 'fromPeriod')
    ..aOS(6, _omitFieldNames ? '' : 'toPeriod')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionsDashboardResponse clone() => GetCollectionsDashboardResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionsDashboardResponse copyWith(void Function(GetCollectionsDashboardResponse) updates) => super.copyWith((message) => updates(message as GetCollectionsDashboardResponse)) as GetCollectionsDashboardResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionsDashboardResponse create() => GetCollectionsDashboardResponse._();
  GetCollectionsDashboardResponse createEmptyInstance() => create();
  static $pb.PbList<GetCollectionsDashboardResponse> createRepeated() => $pb.PbList<GetCollectionsDashboardResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionsDashboardResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionsDashboardResponse>(create);
  static GetCollectionsDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CollectionsDashboardTotals get totals => $_getN(0);
  @$pb.TagNumber(1)
  set totals(CollectionsDashboardTotals v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotals() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotals() => clearField(1);
  @$pb.TagNumber(1)
  CollectionsDashboardTotals ensureTotals() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<SectorCollectionSummary> get bySector => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<PeriodCollectionSummary> get byPeriod => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<AgingTotal> get aging => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get fromPeriod => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromPeriod($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFromPeriod() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromPeriod() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get toPeriod => $_getSZ(5);
  @$pb.TagNumber(6)
  set toPeriod($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasToPeriod() => $_has(5);
  @$pb.TagNumber(6)
  void clearToPeriod() => clearField(6);
}

class DebtorRow extends $pb.GeneratedMessage {
  factory DebtorRow({
    $core.String? customerId,
    $core.String? customerCode,
    $core.String? customerName,
    $core.String? sectorId,
    $core.String? sectorName,
    $core.String? communityName,
    $core.double? totalDebt,
    $core.double? overdueDebt,
    $core.int? pendingReceipts,
    $core.int? overdueReceipts,
    $core.String? oldestOverduePeriod,
    $core.int? daysOverdue,
    $core.String? lastPaymentAt,
    $core.bool? cutCandidate,
    $core.bool? inAgreement,
    $core.bool? agreementInDefault,
    $0.ServiceStatus? serviceStatus,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (customerCode != null) {
      $result.customerCode = customerCode;
    }
    if (customerName != null) {
      $result.customerName = customerName;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (sectorName != null) {
      $result.sectorName = sectorName;
    }
    if (communityName != null) {
      $result.communityName = communityName;
    }
    if (totalDebt != null) {
      $result.totalDebt = totalDebt;
    }
    if (overdueDebt != null) {
      $result.overdueDebt = overdueDebt;
    }
    if (pendingReceipts != null) {
      $result.pendingReceipts = pendingReceipts;
    }
    if (overdueReceipts != null) {
      $result.overdueReceipts = overdueReceipts;
    }
    if (oldestOverduePeriod != null) {
      $result.oldestOverduePeriod = oldestOverduePeriod;
    }
    if (daysOverdue != null) {
      $result.daysOverdue = daysOverdue;
    }
    if (lastPaymentAt != null) {
      $result.lastPaymentAt = lastPaymentAt;
    }
    if (cutCandidate != null) {
      $result.cutCandidate = cutCandidate;
    }
    if (inAgreement != null) {
      $result.inAgreement = inAgreement;
    }
    if (agreementInDefault != null) {
      $result.agreementInDefault = agreementInDefault;
    }
    if (serviceStatus != null) {
      $result.serviceStatus = serviceStatus;
    }
    return $result;
  }
  DebtorRow._() : super();
  factory DebtorRow.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DebtorRow.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DebtorRow', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..aOS(2, _omitFieldNames ? '' : 'customerCode')
    ..aOS(3, _omitFieldNames ? '' : 'customerName')
    ..aOS(4, _omitFieldNames ? '' : 'sectorId')
    ..aOS(5, _omitFieldNames ? '' : 'sectorName')
    ..aOS(6, _omitFieldNames ? '' : 'communityName')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'totalDebt', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'overdueDebt', $pb.PbFieldType.OD)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'pendingReceipts', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'overdueReceipts', $pb.PbFieldType.O3)
    ..aOS(11, _omitFieldNames ? '' : 'oldestOverduePeriod')
    ..a<$core.int>(12, _omitFieldNames ? '' : 'daysOverdue', $pb.PbFieldType.O3)
    ..aOS(13, _omitFieldNames ? '' : 'lastPaymentAt')
    ..aOB(14, _omitFieldNames ? '' : 'cutCandidate')
    ..aOB(15, _omitFieldNames ? '' : 'inAgreement')
    ..aOB(16, _omitFieldNames ? '' : 'agreementInDefault')
    ..e<$0.ServiceStatus>(17, _omitFieldNames ? '' : 'serviceStatus', $pb.PbFieldType.OE, defaultOrMaker: $0.ServiceStatus.SERVICE_STATUS_UNSPECIFIED, valueOf: $0.ServiceStatus.valueOf, enumValues: $0.ServiceStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DebtorRow clone() => DebtorRow()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DebtorRow copyWith(void Function(DebtorRow) updates) => super.copyWith((message) => updates(message as DebtorRow)) as DebtorRow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DebtorRow create() => DebtorRow._();
  DebtorRow createEmptyInstance() => create();
  static $pb.PbList<DebtorRow> createRepeated() => $pb.PbList<DebtorRow>();
  @$core.pragma('dart2js:noInline')
  static DebtorRow getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DebtorRow>(create);
  static DebtorRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCustomerCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get customerName => $_getSZ(2);
  @$pb.TagNumber(3)
  set customerName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomerName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sectorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sectorId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSectorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSectorId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sectorName => $_getSZ(4);
  @$pb.TagNumber(5)
  set sectorName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSectorName() => $_has(4);
  @$pb.TagNumber(5)
  void clearSectorName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get communityName => $_getSZ(5);
  @$pb.TagNumber(6)
  set communityName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCommunityName() => $_has(5);
  @$pb.TagNumber(6)
  void clearCommunityName() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get totalDebt => $_getN(6);
  @$pb.TagNumber(7)
  set totalDebt($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalDebt() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalDebt() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get overdueDebt => $_getN(7);
  @$pb.TagNumber(8)
  set overdueDebt($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasOverdueDebt() => $_has(7);
  @$pb.TagNumber(8)
  void clearOverdueDebt() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get pendingReceipts => $_getIZ(8);
  @$pb.TagNumber(9)
  set pendingReceipts($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPendingReceipts() => $_has(8);
  @$pb.TagNumber(9)
  void clearPendingReceipts() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get overdueReceipts => $_getIZ(9);
  @$pb.TagNumber(10)
  set overdueReceipts($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasOverdueReceipts() => $_has(9);
  @$pb.TagNumber(10)
  void clearOverdueReceipts() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get oldestOverduePeriod => $_getSZ(10);
  @$pb.TagNumber(11)
  set oldestOverduePeriod($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasOldestOverduePeriod() => $_has(10);
  @$pb.TagNumber(11)
  void clearOldestOverduePeriod() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get daysOverdue => $_getIZ(11);
  @$pb.TagNumber(12)
  set daysOverdue($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasDaysOverdue() => $_has(11);
  @$pb.TagNumber(12)
  void clearDaysOverdue() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get lastPaymentAt => $_getSZ(12);
  @$pb.TagNumber(13)
  set lastPaymentAt($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasLastPaymentAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearLastPaymentAt() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get cutCandidate => $_getBF(13);
  @$pb.TagNumber(14)
  set cutCandidate($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasCutCandidate() => $_has(13);
  @$pb.TagNumber(14)
  void clearCutCandidate() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get inAgreement => $_getBF(14);
  @$pb.TagNumber(15)
  set inAgreement($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasInAgreement() => $_has(14);
  @$pb.TagNumber(15)
  void clearInAgreement() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get agreementInDefault => $_getBF(15);
  @$pb.TagNumber(16)
  set agreementInDefault($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasAgreementInDefault() => $_has(15);
  @$pb.TagNumber(16)
  void clearAgreementInDefault() => clearField(16);

  @$pb.TagNumber(17)
  $0.ServiceStatus get serviceStatus => $_getN(16);
  @$pb.TagNumber(17)
  set serviceStatus($0.ServiceStatus v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasServiceStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearServiceStatus() => clearField(17);
}

class GetDebtorsRequest extends $pb.GeneratedMessage {
  factory GetDebtorsRequest({
    $core.String? communityId,
    $core.String? sectorId,
    $core.String? search,
    $core.int? minOverdueReceipts,
    $core.double? minDebt,
    $core.int? cutThreshold,
    $core.bool? onlyCutCandidates,
    $0.ServiceStatus? serviceStatus,
  }) {
    final $result = create();
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (search != null) {
      $result.search = search;
    }
    if (minOverdueReceipts != null) {
      $result.minOverdueReceipts = minOverdueReceipts;
    }
    if (minDebt != null) {
      $result.minDebt = minDebt;
    }
    if (cutThreshold != null) {
      $result.cutThreshold = cutThreshold;
    }
    if (onlyCutCandidates != null) {
      $result.onlyCutCandidates = onlyCutCandidates;
    }
    if (serviceStatus != null) {
      $result.serviceStatus = serviceStatus;
    }
    return $result;
  }
  GetDebtorsRequest._() : super();
  factory GetDebtorsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDebtorsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDebtorsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'communityId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorId')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'minOverdueReceipts', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'minDebt', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'cutThreshold', $pb.PbFieldType.O3)
    ..aOB(7, _omitFieldNames ? '' : 'onlyCutCandidates')
    ..e<$0.ServiceStatus>(8, _omitFieldNames ? '' : 'serviceStatus', $pb.PbFieldType.OE, defaultOrMaker: $0.ServiceStatus.SERVICE_STATUS_UNSPECIFIED, valueOf: $0.ServiceStatus.valueOf, enumValues: $0.ServiceStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDebtorsRequest clone() => GetDebtorsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDebtorsRequest copyWith(void Function(GetDebtorsRequest) updates) => super.copyWith((message) => updates(message as GetDebtorsRequest)) as GetDebtorsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDebtorsRequest create() => GetDebtorsRequest._();
  GetDebtorsRequest createEmptyInstance() => create();
  static $pb.PbList<GetDebtorsRequest> createRepeated() => $pb.PbList<GetDebtorsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDebtorsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDebtorsRequest>(create);
  static GetDebtorsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get communityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set communityId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommunityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommunityId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSectorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectorId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get search => $_getSZ(2);
  @$pb.TagNumber(3)
  set search($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get minOverdueReceipts => $_getIZ(3);
  @$pb.TagNumber(4)
  set minOverdueReceipts($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinOverdueReceipts() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinOverdueReceipts() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get minDebt => $_getN(4);
  @$pb.TagNumber(5)
  set minDebt($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMinDebt() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinDebt() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get cutThreshold => $_getIZ(5);
  @$pb.TagNumber(6)
  set cutThreshold($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCutThreshold() => $_has(5);
  @$pb.TagNumber(6)
  void clearCutThreshold() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get onlyCutCandidates => $_getBF(6);
  @$pb.TagNumber(7)
  set onlyCutCandidates($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOnlyCutCandidates() => $_has(6);
  @$pb.TagNumber(7)
  void clearOnlyCutCandidates() => clearField(7);

  @$pb.TagNumber(8)
  $0.ServiceStatus get serviceStatus => $_getN(7);
  @$pb.TagNumber(8)
  set serviceStatus($0.ServiceStatus v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasServiceStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearServiceStatus() => clearField(8);
}

class GetDebtorsResponse extends $pb.GeneratedMessage {
  factory GetDebtorsResponse({
    $core.Iterable<DebtorRow>? debtors,
    $core.double? totalDebt,
    $core.double? overdueDebt,
    $core.int? cutCandidates,
  }) {
    final $result = create();
    if (debtors != null) {
      $result.debtors.addAll(debtors);
    }
    if (totalDebt != null) {
      $result.totalDebt = totalDebt;
    }
    if (overdueDebt != null) {
      $result.overdueDebt = overdueDebt;
    }
    if (cutCandidates != null) {
      $result.cutCandidates = cutCandidates;
    }
    return $result;
  }
  GetDebtorsResponse._() : super();
  factory GetDebtorsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDebtorsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDebtorsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<DebtorRow>(1, _omitFieldNames ? '' : 'debtors', $pb.PbFieldType.PM, subBuilder: DebtorRow.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalDebt', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'overdueDebt', $pb.PbFieldType.OD)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'cutCandidates', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDebtorsResponse clone() => GetDebtorsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDebtorsResponse copyWith(void Function(GetDebtorsResponse) updates) => super.copyWith((message) => updates(message as GetDebtorsResponse)) as GetDebtorsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDebtorsResponse create() => GetDebtorsResponse._();
  GetDebtorsResponse createEmptyInstance() => create();
  static $pb.PbList<GetDebtorsResponse> createRepeated() => $pb.PbList<GetDebtorsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDebtorsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDebtorsResponse>(create);
  static GetDebtorsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DebtorRow> get debtors => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get totalDebt => $_getN(1);
  @$pb.TagNumber(2)
  set totalDebt($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalDebt() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalDebt() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get overdueDebt => $_getN(2);
  @$pb.TagNumber(3)
  set overdueDebt($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOverdueDebt() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverdueDebt() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get cutCandidates => $_getIZ(3);
  @$pb.TagNumber(4)
  set cutCandidates($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCutCandidates() => $_has(3);
  @$pb.TagNumber(4)
  void clearCutCandidates() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
