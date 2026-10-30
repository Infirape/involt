//
//  Generated code. Do not modify.
//  source: involt/v1/models.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pbenum.dart';

export 'models.pbenum.dart';

/// Community represents a village or Caserio (e.g., Alto Chetilla, Cadena).
class Community extends $pb.GeneratedMessage {
  factory Community({
    $core.String? id,
    $core.String? name,
    $core.int? customerCount,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (customerCount != null) {
      $result.customerCount = customerCount;
    }
    return $result;
  }
  Community._() : super();
  factory Community.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Community.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Community', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'customerCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Community clone() => Community()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Community copyWith(void Function(Community) updates) => super.copyWith((message) => updates(message as Community)) as Community;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Community create() => Community._();
  Community createEmptyInstance() => create();
  static $pb.PbList<Community> createRepeated() => $pb.PbList<Community>();
  @$core.pragma('dart2js:noInline')
  static Community getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Community>(create);
  static Community? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get customerCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set customerCount($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomerCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerCount() => clearField(3);
}

/// Sector represents a specific area within a community (e.g., Sector A, Tambillo Alto).
class Sector extends $pb.GeneratedMessage {
  factory Sector({
    $core.String? id,
    $core.String? communityId,
    $core.String? name,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  Sector._() : super();
  factory Sector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Sector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Sector', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'communityId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Sector clone() => Sector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Sector copyWith(void Function(Sector) updates) => super.copyWith((message) => updates(message as Sector)) as Sector;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sector create() => Sector._();
  Sector createEmptyInstance() => create();
  static $pb.PbList<Sector> createRepeated() => $pb.PbList<Sector>();
  @$core.pragma('dart2js:noInline')
  static Sector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sector>(create);
  static Sector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get communityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set communityId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunityId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);
}

/// Customer contains the master data for a water/electricity user.
class Customer extends $pb.GeneratedMessage {
  factory Customer({
    $core.String? id,
    $core.String? code,
    $core.String? name,
    $core.String? communityId,
    $core.String? sectorId,
    ConnectionType? connectionType,
    $core.double? tariff,
    $core.String? meterNumber,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? initialReading,
    $core.String? address,
    $core.String? contractStart,
    $core.double? lastReadingValue,
    ServiceStatus? serviceStatus,
    $core.String? serviceStatusChangedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (code != null) {
      $result.code = code;
    }
    if (name != null) {
      $result.name = name;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (connectionType != null) {
      $result.connectionType = connectionType;
    }
    if (tariff != null) {
      $result.tariff = tariff;
    }
    if (meterNumber != null) {
      $result.meterNumber = meterNumber;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (initialReading != null) {
      $result.initialReading = initialReading;
    }
    if (address != null) {
      $result.address = address;
    }
    if (contractStart != null) {
      $result.contractStart = contractStart;
    }
    if (lastReadingValue != null) {
      $result.lastReadingValue = lastReadingValue;
    }
    if (serviceStatus != null) {
      $result.serviceStatus = serviceStatus;
    }
    if (serviceStatusChangedAt != null) {
      $result.serviceStatusChangedAt = serviceStatusChangedAt;
    }
    return $result;
  }
  Customer._() : super();
  factory Customer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Customer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Customer', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'communityId')
    ..aOS(5, _omitFieldNames ? '' : 'sectorId')
    ..e<ConnectionType>(6, _omitFieldNames ? '' : 'connectionType', $pb.PbFieldType.OE, defaultOrMaker: ConnectionType.CONNECTION_TYPE_UNSPECIFIED, valueOf: ConnectionType.valueOf, enumValues: ConnectionType.values)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'tariff', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'meterNumber')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'initialReading', $pb.PbFieldType.OD)
    ..aOS(12, _omitFieldNames ? '' : 'address')
    ..aOS(13, _omitFieldNames ? '' : 'contractStart')
    ..a<$core.double>(14, _omitFieldNames ? '' : 'lastReadingValue', $pb.PbFieldType.OD)
    ..e<ServiceStatus>(15, _omitFieldNames ? '' : 'serviceStatus', $pb.PbFieldType.OE, defaultOrMaker: ServiceStatus.SERVICE_STATUS_UNSPECIFIED, valueOf: ServiceStatus.valueOf, enumValues: ServiceStatus.values)
    ..aOS(16, _omitFieldNames ? '' : 'serviceStatusChangedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Customer clone() => Customer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Customer copyWith(void Function(Customer) updates) => super.copyWith((message) => updates(message as Customer)) as Customer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Customer create() => Customer._();
  Customer createEmptyInstance() => create();
  static $pb.PbList<Customer> createRepeated() => $pb.PbList<Customer>();
  @$core.pragma('dart2js:noInline')
  static Customer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Customer>(create);
  static Customer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get communityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set communityId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCommunityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommunityId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sectorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sectorId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSectorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSectorId() => clearField(5);

  @$pb.TagNumber(6)
  ConnectionType get connectionType => $_getN(5);
  @$pb.TagNumber(6)
  set connectionType(ConnectionType v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConnectionType() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectionType() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get tariff => $_getN(6);
  @$pb.TagNumber(7)
  set tariff($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTariff() => $_has(6);
  @$pb.TagNumber(7)
  void clearTariff() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get meterNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set meterNumber($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMeterNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeterNumber() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get latitude => $_getN(8);
  @$pb.TagNumber(9)
  set latitude($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLatitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLatitude() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get longitude => $_getN(9);
  @$pb.TagNumber(10)
  set longitude($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasLongitude() => $_has(9);
  @$pb.TagNumber(10)
  void clearLongitude() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get initialReading => $_getN(10);
  @$pb.TagNumber(11)
  set initialReading($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasInitialReading() => $_has(10);
  @$pb.TagNumber(11)
  void clearInitialReading() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get address => $_getSZ(11);
  @$pb.TagNumber(12)
  set address($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAddress() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddress() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get contractStart => $_getSZ(12);
  @$pb.TagNumber(13)
  set contractStart($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasContractStart() => $_has(12);
  @$pb.TagNumber(13)
  void clearContractStart() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get lastReadingValue => $_getN(13);
  @$pb.TagNumber(14)
  set lastReadingValue($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasLastReadingValue() => $_has(13);
  @$pb.TagNumber(14)
  void clearLastReadingValue() => clearField(14);

  @$pb.TagNumber(15)
  ServiceStatus get serviceStatus => $_getN(14);
  @$pb.TagNumber(15)
  set serviceStatus(ServiceStatus v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasServiceStatus() => $_has(14);
  @$pb.TagNumber(15)
  void clearServiceStatus() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get serviceStatusChangedAt => $_getSZ(15);
  @$pb.TagNumber(16)
  set serviceStatusChangedAt($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasServiceStatusChangedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearServiceStatusChangedAt() => clearField(16);
}

/// Reading represents a captured meter value at a point in time.
class Reading extends $pb.GeneratedMessage {
  factory Reading({
    $core.String? id,
    $core.String? customerId,
    $core.double? previousValue,
    $core.double? currentValue,
    $core.double? consumption,
    $core.String? photoUrl,
    $core.String? timestamp,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? cargoFijo,
    $core.double? alumbradoPublico,
    $core.double? saldoRedondeo,
    $core.double? totalToPay,
    $core.String? periodStart,
    $core.String? periodEnd,
    $core.double? mantenimiento,
    $core.double? adjustment,
    $core.double? subtotal,
    $core.double? roundDifference,
    $core.double? previousBalance,
    $core.double? overdueTotal,
    $core.String? expirationDate,
    $core.String? period,
    $core.String? observation,
    $core.String? customerName,
    $core.bool? isPaid,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (previousValue != null) {
      $result.previousValue = previousValue;
    }
    if (currentValue != null) {
      $result.currentValue = currentValue;
    }
    if (consumption != null) {
      $result.consumption = consumption;
    }
    if (photoUrl != null) {
      $result.photoUrl = photoUrl;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (cargoFijo != null) {
      $result.cargoFijo = cargoFijo;
    }
    if (alumbradoPublico != null) {
      $result.alumbradoPublico = alumbradoPublico;
    }
    if (saldoRedondeo != null) {
      $result.saldoRedondeo = saldoRedondeo;
    }
    if (totalToPay != null) {
      $result.totalToPay = totalToPay;
    }
    if (periodStart != null) {
      $result.periodStart = periodStart;
    }
    if (periodEnd != null) {
      $result.periodEnd = periodEnd;
    }
    if (mantenimiento != null) {
      $result.mantenimiento = mantenimiento;
    }
    if (adjustment != null) {
      $result.adjustment = adjustment;
    }
    if (subtotal != null) {
      $result.subtotal = subtotal;
    }
    if (roundDifference != null) {
      $result.roundDifference = roundDifference;
    }
    if (previousBalance != null) {
      $result.previousBalance = previousBalance;
    }
    if (overdueTotal != null) {
      $result.overdueTotal = overdueTotal;
    }
    if (expirationDate != null) {
      $result.expirationDate = expirationDate;
    }
    if (period != null) {
      $result.period = period;
    }
    if (observation != null) {
      $result.observation = observation;
    }
    if (customerName != null) {
      $result.customerName = customerName;
    }
    if (isPaid != null) {
      $result.isPaid = isPaid;
    }
    return $result;
  }
  Reading._() : super();
  factory Reading.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Reading.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Reading', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'customerId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'previousValue', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'currentValue', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'consumption', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'photoUrl')
    ..aOS(7, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'cargoFijo', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'alumbradoPublico', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'saldoRedondeo', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'totalToPay', $pb.PbFieldType.OD)
    ..aOS(14, _omitFieldNames ? '' : 'periodStart')
    ..aOS(15, _omitFieldNames ? '' : 'periodEnd')
    ..a<$core.double>(16, _omitFieldNames ? '' : 'mantenimiento', $pb.PbFieldType.OD)
    ..a<$core.double>(17, _omitFieldNames ? '' : 'adjustment', $pb.PbFieldType.OD)
    ..a<$core.double>(18, _omitFieldNames ? '' : 'subtotal', $pb.PbFieldType.OD)
    ..a<$core.double>(19, _omitFieldNames ? '' : 'roundDifference', $pb.PbFieldType.OD)
    ..a<$core.double>(20, _omitFieldNames ? '' : 'previousBalance', $pb.PbFieldType.OD)
    ..a<$core.double>(21, _omitFieldNames ? '' : 'overdueTotal', $pb.PbFieldType.OD)
    ..aOS(22, _omitFieldNames ? '' : 'expirationDate')
    ..aOS(23, _omitFieldNames ? '' : 'period')
    ..aOS(24, _omitFieldNames ? '' : 'observation')
    ..aOS(25, _omitFieldNames ? '' : 'customerName')
    ..aOB(26, _omitFieldNames ? '' : 'isPaid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Reading clone() => Reading()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Reading copyWith(void Function(Reading) updates) => super.copyWith((message) => updates(message as Reading)) as Reading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reading create() => Reading._();
  Reading createEmptyInstance() => create();
  static $pb.PbList<Reading> createRepeated() => $pb.PbList<Reading>();
  @$core.pragma('dart2js:noInline')
  static Reading getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reading>(create);
  static Reading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCustomerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerId() => clearField(2);

  /// Consumption data
  @$pb.TagNumber(3)
  $core.double get previousValue => $_getN(2);
  @$pb.TagNumber(3)
  set previousValue($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPreviousValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreviousValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get currentValue => $_getN(3);
  @$pb.TagNumber(4)
  set currentValue($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get consumption => $_getN(4);
  @$pb.TagNumber(5)
  set consumption($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConsumption() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsumption() => clearField(5);

  /// Metadata
  @$pb.TagNumber(6)
  $core.String get photoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set photoUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPhotoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhotoUrl() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get timestamp => $_getSZ(6);
  @$pb.TagNumber(7)
  set timestamp($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get latitude => $_getN(7);
  @$pb.TagNumber(8)
  set latitude($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLatitude() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatitude() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get longitude => $_getN(8);
  @$pb.TagNumber(9)
  set longitude($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLongitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLongitude() => clearField(9);

  /// Financial data (captured for receipt generation consistency)
  @$pb.TagNumber(10)
  $core.double get cargoFijo => $_getN(9);
  @$pb.TagNumber(10)
  set cargoFijo($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCargoFijo() => $_has(9);
  @$pb.TagNumber(10)
  void clearCargoFijo() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get alumbradoPublico => $_getN(10);
  @$pb.TagNumber(11)
  set alumbradoPublico($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAlumbradoPublico() => $_has(10);
  @$pb.TagNumber(11)
  void clearAlumbradoPublico() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get saldoRedondeo => $_getN(11);
  @$pb.TagNumber(12)
  set saldoRedondeo($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSaldoRedondeo() => $_has(11);
  @$pb.TagNumber(12)
  void clearSaldoRedondeo() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get totalToPay => $_getN(12);
  @$pb.TagNumber(13)
  set totalToPay($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTotalToPay() => $_has(12);
  @$pb.TagNumber(13)
  void clearTotalToPay() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get periodStart => $_getSZ(13);
  @$pb.TagNumber(14)
  set periodStart($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasPeriodStart() => $_has(13);
  @$pb.TagNumber(14)
  void clearPeriodStart() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get periodEnd => $_getSZ(14);
  @$pb.TagNumber(15)
  set periodEnd($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasPeriodEnd() => $_has(14);
  @$pb.TagNumber(15)
  void clearPeriodEnd() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get mantenimiento => $_getN(15);
  @$pb.TagNumber(16)
  set mantenimiento($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasMantenimiento() => $_has(15);
  @$pb.TagNumber(16)
  void clearMantenimiento() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get adjustment => $_getN(16);
  @$pb.TagNumber(17)
  set adjustment($core.double v) { $_setDouble(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasAdjustment() => $_has(16);
  @$pb.TagNumber(17)
  void clearAdjustment() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get subtotal => $_getN(17);
  @$pb.TagNumber(18)
  set subtotal($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasSubtotal() => $_has(17);
  @$pb.TagNumber(18)
  void clearSubtotal() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get roundDifference => $_getN(18);
  @$pb.TagNumber(19)
  set roundDifference($core.double v) { $_setDouble(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasRoundDifference() => $_has(18);
  @$pb.TagNumber(19)
  void clearRoundDifference() => clearField(19);

  @$pb.TagNumber(20)
  $core.double get previousBalance => $_getN(19);
  @$pb.TagNumber(20)
  set previousBalance($core.double v) { $_setDouble(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasPreviousBalance() => $_has(19);
  @$pb.TagNumber(20)
  void clearPreviousBalance() => clearField(20);

  @$pb.TagNumber(21)
  $core.double get overdueTotal => $_getN(20);
  @$pb.TagNumber(21)
  set overdueTotal($core.double v) { $_setDouble(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasOverdueTotal() => $_has(20);
  @$pb.TagNumber(21)
  void clearOverdueTotal() => clearField(21);

  @$pb.TagNumber(22)
  $core.String get expirationDate => $_getSZ(21);
  @$pb.TagNumber(22)
  set expirationDate($core.String v) { $_setString(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasExpirationDate() => $_has(21);
  @$pb.TagNumber(22)
  void clearExpirationDate() => clearField(22);

  @$pb.TagNumber(23)
  $core.String get period => $_getSZ(22);
  @$pb.TagNumber(23)
  set period($core.String v) { $_setString(22, v); }
  @$pb.TagNumber(23)
  $core.bool hasPeriod() => $_has(22);
  @$pb.TagNumber(23)
  void clearPeriod() => clearField(23);

  @$pb.TagNumber(24)
  $core.String get observation => $_getSZ(23);
  @$pb.TagNumber(24)
  set observation($core.String v) { $_setString(23, v); }
  @$pb.TagNumber(24)
  $core.bool hasObservation() => $_has(23);
  @$pb.TagNumber(24)
  void clearObservation() => clearField(24);

  @$pb.TagNumber(25)
  $core.String get customerName => $_getSZ(24);
  @$pb.TagNumber(25)
  set customerName($core.String v) { $_setString(24, v); }
  @$pb.TagNumber(25)
  $core.bool hasCustomerName() => $_has(24);
  @$pb.TagNumber(25)
  void clearCustomerName() => clearField(25);

  @$pb.TagNumber(26)
  $core.bool get isPaid => $_getBF(25);
  @$pb.TagNumber(26)
  set isPaid($core.bool v) { $_setBool(25, v); }
  @$pb.TagNumber(26)
  $core.bool hasIsPaid() => $_has(25);
  @$pb.TagNumber(26)
  void clearIsPaid() => clearField(26);
}

/// AppConfig contains remote configuration for the mobile application.
class AppConfig extends $pb.GeneratedMessage {
  factory AppConfig({
    $core.String? mapUrlTemplate,
    $core.String? mapUserAgent,
  }) {
    final $result = create();
    if (mapUrlTemplate != null) {
      $result.mapUrlTemplate = mapUrlTemplate;
    }
    if (mapUserAgent != null) {
      $result.mapUserAgent = mapUserAgent;
    }
    return $result;
  }
  AppConfig._() : super();
  factory AppConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapUrlTemplate')
    ..aOS(2, _omitFieldNames ? '' : 'mapUserAgent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppConfig clone() => AppConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppConfig copyWith(void Function(AppConfig) updates) => super.copyWith((message) => updates(message as AppConfig)) as AppConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppConfig create() => AppConfig._();
  AppConfig createEmptyInstance() => create();
  static $pb.PbList<AppConfig> createRepeated() => $pb.PbList<AppConfig>();
  @$core.pragma('dart2js:noInline')
  static AppConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppConfig>(create);
  static AppConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapUrlTemplate => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapUrlTemplate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMapUrlTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapUrlTemplate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mapUserAgent => $_getSZ(1);
  @$pb.TagNumber(2)
  set mapUserAgent($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMapUserAgent() => $_has(1);
  @$pb.TagNumber(2)
  void clearMapUserAgent() => clearField(2);
}

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.String? municipalidad,
    $core.String? empresa,
    $core.String? ruc,
    $core.String? direccion,
    $core.String? telefono,
    $core.String? email,
    $core.int? diasVencimiento,
    $core.double? tarifaKwh,
    $core.double? cargoFijo,
    $core.double? alumbrado,
    $core.double? mantenimiento,
    $core.bool? igv,
    ReceiptCopies? receiptCopies,
  }) {
    final $result = create();
    if (municipalidad != null) {
      $result.municipalidad = municipalidad;
    }
    if (empresa != null) {
      $result.empresa = empresa;
    }
    if (ruc != null) {
      $result.ruc = ruc;
    }
    if (direccion != null) {
      $result.direccion = direccion;
    }
    if (telefono != null) {
      $result.telefono = telefono;
    }
    if (email != null) {
      $result.email = email;
    }
    if (diasVencimiento != null) {
      $result.diasVencimiento = diasVencimiento;
    }
    if (tarifaKwh != null) {
      $result.tarifaKwh = tarifaKwh;
    }
    if (cargoFijo != null) {
      $result.cargoFijo = cargoFijo;
    }
    if (alumbrado != null) {
      $result.alumbrado = alumbrado;
    }
    if (mantenimiento != null) {
      $result.mantenimiento = mantenimiento;
    }
    if (igv != null) {
      $result.igv = igv;
    }
    if (receiptCopies != null) {
      $result.receiptCopies = receiptCopies;
    }
    return $result;
  }
  Settings._() : super();
  factory Settings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Settings', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'municipalidad')
    ..aOS(2, _omitFieldNames ? '' : 'empresa')
    ..aOS(3, _omitFieldNames ? '' : 'ruc')
    ..aOS(4, _omitFieldNames ? '' : 'direccion')
    ..aOS(5, _omitFieldNames ? '' : 'telefono')
    ..aOS(6, _omitFieldNames ? '' : 'email')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'diasVencimiento', $pb.PbFieldType.O3)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'tarifaKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'cargoFijo', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'alumbrado', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'mantenimiento', $pb.PbFieldType.OD)
    ..aOB(12, _omitFieldNames ? '' : 'igv')
    ..e<ReceiptCopies>(13, _omitFieldNames ? '' : 'receiptCopies', $pb.PbFieldType.OE, defaultOrMaker: ReceiptCopies.RECEIPT_COPIES_UNSPECIFIED, valueOf: ReceiptCopies.valueOf, enumValues: ReceiptCopies.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings clone() => Settings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings copyWith(void Function(Settings) updates) => super.copyWith((message) => updates(message as Settings)) as Settings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  Settings createEmptyInstance() => create();
  static $pb.PbList<Settings> createRepeated() => $pb.PbList<Settings>();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get municipalidad => $_getSZ(0);
  @$pb.TagNumber(1)
  set municipalidad($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMunicipalidad() => $_has(0);
  @$pb.TagNumber(1)
  void clearMunicipalidad() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get empresa => $_getSZ(1);
  @$pb.TagNumber(2)
  set empresa($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmpresa() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmpresa() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ruc => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruc($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRuc() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuc() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get direccion => $_getSZ(3);
  @$pb.TagNumber(4)
  set direccion($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDireccion() => $_has(3);
  @$pb.TagNumber(4)
  void clearDireccion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get telefono => $_getSZ(4);
  @$pb.TagNumber(5)
  set telefono($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTelefono() => $_has(4);
  @$pb.TagNumber(5)
  void clearTelefono() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get email => $_getSZ(5);
  @$pb.TagNumber(6)
  set email($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearEmail() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get diasVencimiento => $_getIZ(6);
  @$pb.TagNumber(7)
  set diasVencimiento($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDiasVencimiento() => $_has(6);
  @$pb.TagNumber(7)
  void clearDiasVencimiento() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get tarifaKwh => $_getN(7);
  @$pb.TagNumber(8)
  set tarifaKwh($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTarifaKwh() => $_has(7);
  @$pb.TagNumber(8)
  void clearTarifaKwh() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get cargoFijo => $_getN(8);
  @$pb.TagNumber(9)
  set cargoFijo($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCargoFijo() => $_has(8);
  @$pb.TagNumber(9)
  void clearCargoFijo() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get alumbrado => $_getN(9);
  @$pb.TagNumber(10)
  set alumbrado($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAlumbrado() => $_has(9);
  @$pb.TagNumber(10)
  void clearAlumbrado() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get mantenimiento => $_getN(10);
  @$pb.TagNumber(11)
  set mantenimiento($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasMantenimiento() => $_has(10);
  @$pb.TagNumber(11)
  void clearMantenimiento() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get igv => $_getBF(11);
  @$pb.TagNumber(12)
  set igv($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasIgv() => $_has(11);
  @$pb.TagNumber(12)
  void clearIgv() => clearField(12);

  @$pb.TagNumber(13)
  ReceiptCopies get receiptCopies => $_getN(12);
  @$pb.TagNumber(13)
  set receiptCopies(ReceiptCopies v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasReceiptCopies() => $_has(12);
  @$pb.TagNumber(13)
  void clearReceiptCopies() => clearField(13);
}

class Period extends $pb.GeneratedMessage {
  factory Period({
    $core.String? id,
    $core.String? startDate,
    $core.String? endDate,
    PeriodStatus? status,
    $core.bool? isBillingPeriod,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (startDate != null) {
      $result.startDate = startDate;
    }
    if (endDate != null) {
      $result.endDate = endDate;
    }
    if (status != null) {
      $result.status = status;
    }
    if (isBillingPeriod != null) {
      $result.isBillingPeriod = isBillingPeriod;
    }
    return $result;
  }
  Period._() : super();
  factory Period.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Period.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Period', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'startDate')
    ..aOS(3, _omitFieldNames ? '' : 'endDate')
    ..e<PeriodStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: PeriodStatus.PERIOD_STATUS_UNSPECIFIED, valueOf: PeriodStatus.valueOf, enumValues: PeriodStatus.values)
    ..aOB(5, _omitFieldNames ? '' : 'isBillingPeriod')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Period clone() => Period()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Period copyWith(void Function(Period) updates) => super.copyWith((message) => updates(message as Period)) as Period;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Period create() => Period._();
  Period createEmptyInstance() => create();
  static $pb.PbList<Period> createRepeated() => $pb.PbList<Period>();
  @$core.pragma('dart2js:noInline')
  static Period getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Period>(create);
  static Period? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get startDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set startDate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get endDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set endDate($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEndDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndDate() => clearField(3);

  @$pb.TagNumber(4)
  PeriodStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(PeriodStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isBillingPeriod => $_getBF(4);
  @$pb.TagNumber(5)
  set isBillingPeriod($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsBillingPeriod() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsBillingPeriod() => clearField(5);
}

/// Operator represents a field user that can log into the mobile app.
/// The password_hash is synced so login can work offline.
class Operator extends $pb.GeneratedMessage {
  factory Operator({
    $core.String? id,
    $core.String? email,
    $core.String? passwordHash,
    $core.String? role,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (email != null) {
      $result.email = email;
    }
    if (passwordHash != null) {
      $result.passwordHash = passwordHash;
    }
    if (role != null) {
      $result.role = role;
    }
    return $result;
  }
  Operator._() : super();
  factory Operator.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Operator.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Operator', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'passwordHash')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Operator clone() => Operator()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Operator copyWith(void Function(Operator) updates) => super.copyWith((message) => updates(message as Operator)) as Operator;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Operator create() => Operator._();
  Operator createEmptyInstance() => create();
  static $pb.PbList<Operator> createRepeated() => $pb.PbList<Operator>();
  @$core.pragma('dart2js:noInline')
  static Operator getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Operator>(create);
  static Operator? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get passwordHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set passwordHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPasswordHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearPasswordHash() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
