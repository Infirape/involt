//
//  Generated code. Do not modify.
//  source: involt/v1/sync.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pb.dart' as $0;

class PushReadingsRequest extends $pb.GeneratedMessage {
  factory PushReadingsRequest({
    $core.Iterable<$0.Reading>? readings,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    return $result;
  }
  PushReadingsRequest._() : super();
  factory PushReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Reading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushReadingsRequest clone() => PushReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushReadingsRequest copyWith(void Function(PushReadingsRequest) updates) => super.copyWith((message) => updates(message as PushReadingsRequest)) as PushReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushReadingsRequest create() => PushReadingsRequest._();
  PushReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<PushReadingsRequest> createRepeated() => $pb.PbList<PushReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static PushReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushReadingsRequest>(create);
  static PushReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Reading> get readings => $_getList(0);
}

class PushReadingsResponse extends $pb.GeneratedMessage {
  factory PushReadingsResponse({
    $core.bool? success,
    $core.int? syncedCount,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (syncedCount != null) {
      $result.syncedCount = syncedCount;
    }
    return $result;
  }
  PushReadingsResponse._() : super();
  factory PushReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'syncedCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PushReadingsResponse clone() => PushReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PushReadingsResponse copyWith(void Function(PushReadingsResponse) updates) => super.copyWith((message) => updates(message as PushReadingsResponse)) as PushReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushReadingsResponse create() => PushReadingsResponse._();
  PushReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<PushReadingsResponse> createRepeated() => $pb.PbList<PushReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static PushReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushReadingsResponse>(create);
  static PushReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get syncedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set syncedCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSyncedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncedCount() => clearField(2);
}

class PullMetadataRequest extends $pb.GeneratedMessage {
  factory PullMetadataRequest({
    $fixnum.Int64? lastSyncTimestamp,
  }) {
    final $result = create();
    if (lastSyncTimestamp != null) {
      $result.lastSyncTimestamp = lastSyncTimestamp;
    }
    return $result;
  }
  PullMetadataRequest._() : super();
  factory PullMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PullMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PullMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'lastSyncTimestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PullMetadataRequest clone() => PullMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PullMetadataRequest copyWith(void Function(PullMetadataRequest) updates) => super.copyWith((message) => updates(message as PullMetadataRequest)) as PullMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMetadataRequest create() => PullMetadataRequest._();
  PullMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<PullMetadataRequest> createRepeated() => $pb.PbList<PullMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static PullMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PullMetadataRequest>(create);
  static PullMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lastSyncTimestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set lastSyncTimestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLastSyncTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearLastSyncTimestamp() => clearField(1);
}

class PullMetadataResponse extends $pb.GeneratedMessage {
  factory PullMetadataResponse({
    $core.Iterable<$0.Community>? communities,
    $core.Iterable<$0.Sector>? sectors,
    $core.Iterable<$0.Customer>? customers,
    $core.Iterable<$0.Reading>? readings,
    $0.AppConfig? config,
    $0.Settings? settings,
    $0.Period? currentPeriod,
    $core.Iterable<$0.Operator>? operators,
  }) {
    final $result = create();
    if (communities != null) {
      $result.communities.addAll(communities);
    }
    if (sectors != null) {
      $result.sectors.addAll(sectors);
    }
    if (customers != null) {
      $result.customers.addAll(customers);
    }
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    if (config != null) {
      $result.config = config;
    }
    if (settings != null) {
      $result.settings = settings;
    }
    if (currentPeriod != null) {
      $result.currentPeriod = currentPeriod;
    }
    if (operators != null) {
      $result.operators.addAll(operators);
    }
    return $result;
  }
  PullMetadataResponse._() : super();
  factory PullMetadataResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PullMetadataResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PullMetadataResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Community>(1, _omitFieldNames ? '' : 'communities', $pb.PbFieldType.PM, subBuilder: $0.Community.create)
    ..pc<$0.Sector>(2, _omitFieldNames ? '' : 'sectors', $pb.PbFieldType.PM, subBuilder: $0.Sector.create)
    ..pc<$0.Customer>(3, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.PM, subBuilder: $0.Customer.create)
    ..pc<$0.Reading>(4, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..aOM<$0.AppConfig>(5, _omitFieldNames ? '' : 'config', subBuilder: $0.AppConfig.create)
    ..aOM<$0.Settings>(6, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..aOM<$0.Period>(7, _omitFieldNames ? '' : 'currentPeriod', subBuilder: $0.Period.create)
    ..pc<$0.Operator>(8, _omitFieldNames ? '' : 'operators', $pb.PbFieldType.PM, subBuilder: $0.Operator.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PullMetadataResponse clone() => PullMetadataResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PullMetadataResponse copyWith(void Function(PullMetadataResponse) updates) => super.copyWith((message) => updates(message as PullMetadataResponse)) as PullMetadataResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMetadataResponse create() => PullMetadataResponse._();
  PullMetadataResponse createEmptyInstance() => create();
  static $pb.PbList<PullMetadataResponse> createRepeated() => $pb.PbList<PullMetadataResponse>();
  @$core.pragma('dart2js:noInline')
  static PullMetadataResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PullMetadataResponse>(create);
  static PullMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Community> get communities => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$0.Sector> get sectors => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$0.Customer> get customers => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$0.Reading> get readings => $_getList(3);

  @$pb.TagNumber(5)
  $0.AppConfig get config => $_getN(4);
  @$pb.TagNumber(5)
  set config($0.AppConfig v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfig() => clearField(5);
  @$pb.TagNumber(5)
  $0.AppConfig ensureConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Settings get settings => $_getN(5);
  @$pb.TagNumber(6)
  set settings($0.Settings v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSettings() => $_has(5);
  @$pb.TagNumber(6)
  void clearSettings() => clearField(6);
  @$pb.TagNumber(6)
  $0.Settings ensureSettings() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Period get currentPeriod => $_getN(6);
  @$pb.TagNumber(7)
  set currentPeriod($0.Period v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurrentPeriod() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentPeriod() => clearField(7);
  @$pb.TagNumber(7)
  $0.Period ensureCurrentPeriod() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.List<$0.Operator> get operators => $_getList(7);
}

class UploadPhotoRequest extends $pb.GeneratedMessage {
  factory UploadPhotoRequest({
    $core.String? fileName,
    $core.List<$core.int>? data,
    $core.String? readingId,
  }) {
    final $result = create();
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (data != null) {
      $result.data = data;
    }
    if (readingId != null) {
      $result.readingId = readingId;
    }
    return $result;
  }
  UploadPhotoRequest._() : super();
  factory UploadPhotoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadPhotoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadPhotoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileName')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'readingId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadPhotoRequest clone() => UploadPhotoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadPhotoRequest copyWith(void Function(UploadPhotoRequest) updates) => super.copyWith((message) => updates(message as UploadPhotoRequest)) as UploadPhotoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadPhotoRequest create() => UploadPhotoRequest._();
  UploadPhotoRequest createEmptyInstance() => create();
  static $pb.PbList<UploadPhotoRequest> createRepeated() => $pb.PbList<UploadPhotoRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadPhotoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadPhotoRequest>(create);
  static UploadPhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);

  /// When set, the photo is attached to this (already synced) reading. Photos are uploaded
  /// after their readings, in the background.
  @$pb.TagNumber(3)
  $core.String get readingId => $_getSZ(2);
  @$pb.TagNumber(3)
  set readingId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReadingId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadingId() => clearField(3);
}

class UploadPhotoResponse extends $pb.GeneratedMessage {
  factory UploadPhotoResponse({
    $core.String? url,
    $core.bool? attached,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (attached != null) {
      $result.attached = attached;
    }
    return $result;
  }
  UploadPhotoResponse._() : super();
  factory UploadPhotoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadPhotoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadPhotoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOB(2, _omitFieldNames ? '' : 'attached')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadPhotoResponse clone() => UploadPhotoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadPhotoResponse copyWith(void Function(UploadPhotoResponse) updates) => super.copyWith((message) => updates(message as UploadPhotoResponse)) as UploadPhotoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadPhotoResponse create() => UploadPhotoResponse._();
  UploadPhotoResponse createEmptyInstance() => create();
  static $pb.PbList<UploadPhotoResponse> createRepeated() => $pb.PbList<UploadPhotoResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadPhotoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadPhotoResponse>(create);
  static UploadPhotoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  /// True when the photo was attached to the requested reading. Older servers never set it,
  /// so the app keeps its copy instead of losing the photo.
  @$pb.TagNumber(2)
  $core.bool get attached => $_getBF(1);
  @$pb.TagNumber(2)
  set attached($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAttached() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttached() => clearField(2);
}

class DownloadReceiptRequest extends $pb.GeneratedMessage {
  factory DownloadReceiptRequest({
    $core.String? readingId,
  }) {
    final $result = create();
    if (readingId != null) {
      $result.readingId = readingId;
    }
    return $result;
  }
  DownloadReceiptRequest._() : super();
  factory DownloadReceiptRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadReceiptRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DownloadReceiptRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadReceiptRequest clone() => DownloadReceiptRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadReceiptRequest copyWith(void Function(DownloadReceiptRequest) updates) => super.copyWith((message) => updates(message as DownloadReceiptRequest)) as DownloadReceiptRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadReceiptRequest create() => DownloadReceiptRequest._();
  DownloadReceiptRequest createEmptyInstance() => create();
  static $pb.PbList<DownloadReceiptRequest> createRepeated() => $pb.PbList<DownloadReceiptRequest>();
  @$core.pragma('dart2js:noInline')
  static DownloadReceiptRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadReceiptRequest>(create);
  static DownloadReceiptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => clearField(1);
}

class DownloadReceiptResponse extends $pb.GeneratedMessage {
  factory DownloadReceiptResponse({
    $core.List<$core.int>? pdfData,
  }) {
    final $result = create();
    if (pdfData != null) {
      $result.pdfData = pdfData;
    }
    return $result;
  }
  DownloadReceiptResponse._() : super();
  factory DownloadReceiptResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadReceiptResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DownloadReceiptResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'pdfData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadReceiptResponse clone() => DownloadReceiptResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadReceiptResponse copyWith(void Function(DownloadReceiptResponse) updates) => super.copyWith((message) => updates(message as DownloadReceiptResponse)) as DownloadReceiptResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadReceiptResponse create() => DownloadReceiptResponse._();
  DownloadReceiptResponse createEmptyInstance() => create();
  static $pb.PbList<DownloadReceiptResponse> createRepeated() => $pb.PbList<DownloadReceiptResponse>();
  @$core.pragma('dart2js:noInline')
  static DownloadReceiptResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadReceiptResponse>(create);
  static DownloadReceiptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get pdfData => $_getN(0);
  @$pb.TagNumber(1)
  set pdfData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPdfData() => $_has(0);
  @$pb.TagNumber(1)
  void clearPdfData() => clearField(1);
}

class SyncServiceApi {
  $pb.RpcClient _client;
  SyncServiceApi(this._client);

  $async.Future<PushReadingsResponse> pushReadings($pb.ClientContext? ctx, PushReadingsRequest request) =>
    _client.invoke<PushReadingsResponse>(ctx, 'SyncService', 'PushReadings', request, PushReadingsResponse())
  ;
  $async.Future<PullMetadataResponse> pullMetadata($pb.ClientContext? ctx, PullMetadataRequest request) =>
    _client.invoke<PullMetadataResponse>(ctx, 'SyncService', 'PullMetadata', request, PullMetadataResponse())
  ;
  $async.Future<UploadPhotoResponse> uploadPhoto($pb.ClientContext? ctx, UploadPhotoRequest request) =>
    _client.invoke<UploadPhotoResponse>(ctx, 'SyncService', 'UploadPhoto', request, UploadPhotoResponse())
  ;
  $async.Future<DownloadReceiptResponse> downloadReceipt($pb.ClientContext? ctx, DownloadReceiptRequest request) =>
    _client.invoke<DownloadReceiptResponse>(ctx, 'SyncService', 'DownloadReceipt', request, DownloadReceiptResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
