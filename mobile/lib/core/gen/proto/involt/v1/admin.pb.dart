//
//  Generated code. Do not modify.
//  source: involt/v1/admin.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pbenum.dart';
import 'models.pb.dart' as $0;

export 'admin.pbenum.dart';

class UpsertSectorRequest extends $pb.GeneratedMessage {
  factory UpsertSectorRequest({
    $0.Sector? sector,
  }) {
    final $result = create();
    if (sector != null) {
      $result.sector = sector;
    }
    return $result;
  }
  UpsertSectorRequest._() : super();
  factory UpsertSectorRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertSectorRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertSectorRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Sector>(1, _omitFieldNames ? '' : 'sector', subBuilder: $0.Sector.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertSectorRequest clone() => UpsertSectorRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertSectorRequest copyWith(void Function(UpsertSectorRequest) updates) => super.copyWith((message) => updates(message as UpsertSectorRequest)) as UpsertSectorRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertSectorRequest create() => UpsertSectorRequest._();
  UpsertSectorRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertSectorRequest> createRepeated() => $pb.PbList<UpsertSectorRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertSectorRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertSectorRequest>(create);
  static UpsertSectorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Sector get sector => $_getN(0);
  @$pb.TagNumber(1)
  set sector($0.Sector v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSector() => $_has(0);
  @$pb.TagNumber(1)
  void clearSector() => clearField(1);
  @$pb.TagNumber(1)
  $0.Sector ensureSector() => $_ensure(0);
}

class UpsertSectorResponse extends $pb.GeneratedMessage {
  factory UpsertSectorResponse({
    $0.Sector? sector,
  }) {
    final $result = create();
    if (sector != null) {
      $result.sector = sector;
    }
    return $result;
  }
  UpsertSectorResponse._() : super();
  factory UpsertSectorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertSectorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertSectorResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Sector>(1, _omitFieldNames ? '' : 'sector', subBuilder: $0.Sector.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertSectorResponse clone() => UpsertSectorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertSectorResponse copyWith(void Function(UpsertSectorResponse) updates) => super.copyWith((message) => updates(message as UpsertSectorResponse)) as UpsertSectorResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertSectorResponse create() => UpsertSectorResponse._();
  UpsertSectorResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertSectorResponse> createRepeated() => $pb.PbList<UpsertSectorResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertSectorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertSectorResponse>(create);
  static UpsertSectorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Sector get sector => $_getN(0);
  @$pb.TagNumber(1)
  set sector($0.Sector v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSector() => $_has(0);
  @$pb.TagNumber(1)
  void clearSector() => clearField(1);
  @$pb.TagNumber(1)
  $0.Sector ensureSector() => $_ensure(0);
}

class UpsertCommunityRequest extends $pb.GeneratedMessage {
  factory UpsertCommunityRequest({
    $0.Community? community,
  }) {
    final $result = create();
    if (community != null) {
      $result.community = community;
    }
    return $result;
  }
  UpsertCommunityRequest._() : super();
  factory UpsertCommunityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCommunityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCommunityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Community>(1, _omitFieldNames ? '' : 'community', subBuilder: $0.Community.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCommunityRequest clone() => UpsertCommunityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCommunityRequest copyWith(void Function(UpsertCommunityRequest) updates) => super.copyWith((message) => updates(message as UpsertCommunityRequest)) as UpsertCommunityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCommunityRequest create() => UpsertCommunityRequest._();
  UpsertCommunityRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertCommunityRequest> createRepeated() => $pb.PbList<UpsertCommunityRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertCommunityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCommunityRequest>(create);
  static UpsertCommunityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Community get community => $_getN(0);
  @$pb.TagNumber(1)
  set community($0.Community v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommunity() => clearField(1);
  @$pb.TagNumber(1)
  $0.Community ensureCommunity() => $_ensure(0);
}

class UpsertCommunityResponse extends $pb.GeneratedMessage {
  factory UpsertCommunityResponse({
    $0.Community? community,
  }) {
    final $result = create();
    if (community != null) {
      $result.community = community;
    }
    return $result;
  }
  UpsertCommunityResponse._() : super();
  factory UpsertCommunityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCommunityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCommunityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Community>(1, _omitFieldNames ? '' : 'community', subBuilder: $0.Community.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCommunityResponse clone() => UpsertCommunityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCommunityResponse copyWith(void Function(UpsertCommunityResponse) updates) => super.copyWith((message) => updates(message as UpsertCommunityResponse)) as UpsertCommunityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCommunityResponse create() => UpsertCommunityResponse._();
  UpsertCommunityResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertCommunityResponse> createRepeated() => $pb.PbList<UpsertCommunityResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertCommunityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCommunityResponse>(create);
  static UpsertCommunityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Community get community => $_getN(0);
  @$pb.TagNumber(1)
  set community($0.Community v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommunity() => clearField(1);
  @$pb.TagNumber(1)
  $0.Community ensureCommunity() => $_ensure(0);
}

class DeleteCustomerRequest extends $pb.GeneratedMessage {
  factory DeleteCustomerRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteCustomerRequest._() : super();
  factory DeleteCustomerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCustomerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteCustomerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCustomerRequest clone() => DeleteCustomerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCustomerRequest copyWith(void Function(DeleteCustomerRequest) updates) => super.copyWith((message) => updates(message as DeleteCustomerRequest)) as DeleteCustomerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteCustomerRequest create() => DeleteCustomerRequest._();
  DeleteCustomerRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCustomerRequest> createRepeated() => $pb.PbList<DeleteCustomerRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCustomerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCustomerRequest>(create);
  static DeleteCustomerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteCustomerResponse extends $pb.GeneratedMessage {
  factory DeleteCustomerResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  DeleteCustomerResponse._() : super();
  factory DeleteCustomerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCustomerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteCustomerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCustomerResponse clone() => DeleteCustomerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCustomerResponse copyWith(void Function(DeleteCustomerResponse) updates) => super.copyWith((message) => updates(message as DeleteCustomerResponse)) as DeleteCustomerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteCustomerResponse create() => DeleteCustomerResponse._();
  DeleteCustomerResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCustomerResponse> createRepeated() => $pb.PbList<DeleteCustomerResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCustomerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCustomerResponse>(create);
  static DeleteCustomerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? email,
    $core.String? password,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? token,
    User? user,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  LoginResponse._() : super();
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOM<User>(2, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(User v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
  @$pb.TagNumber(2)
  User ensureUser() => $_ensure(1);
}

class GetUsersRequest extends $pb.GeneratedMessage {
  factory GetUsersRequest() => create();
  GetUsersRequest._() : super();
  factory GetUsersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUsersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUsersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUsersRequest clone() => GetUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUsersRequest copyWith(void Function(GetUsersRequest) updates) => super.copyWith((message) => updates(message as GetUsersRequest)) as GetUsersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsersRequest create() => GetUsersRequest._();
  GetUsersRequest createEmptyInstance() => create();
  static $pb.PbList<GetUsersRequest> createRepeated() => $pb.PbList<GetUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUsersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsersRequest>(create);
  static GetUsersRequest? _defaultInstance;
}

class GetUsersResponse extends $pb.GeneratedMessage {
  factory GetUsersResponse({
    $core.Iterable<User>? users,
  }) {
    final $result = create();
    if (users != null) {
      $result.users.addAll(users);
    }
    return $result;
  }
  GetUsersResponse._() : super();
  factory GetUsersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUsersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUsersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUsersResponse clone() => GetUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUsersResponse copyWith(void Function(GetUsersResponse) updates) => super.copyWith((message) => updates(message as GetUsersResponse)) as GetUsersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsersResponse create() => GetUsersResponse._();
  GetUsersResponse createEmptyInstance() => create();
  static $pb.PbList<GetUsersResponse> createRepeated() => $pb.PbList<GetUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUsersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsersResponse>(create);
  static GetUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get users => $_getList(0);
}

class UpsertUserRequest extends $pb.GeneratedMessage {
  factory UpsertUserRequest({
    User? user,
    $core.String? password,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  UpsertUserRequest._() : super();
  factory UpsertUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUserRequest clone() => UpsertUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUserRequest copyWith(void Function(UpsertUserRequest) updates) => super.copyWith((message) => updates(message as UpsertUserRequest)) as UpsertUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertUserRequest create() => UpsertUserRequest._();
  UpsertUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertUserRequest> createRepeated() => $pb.PbList<UpsertUserRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUserRequest>(create);
  static UpsertUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class UpsertUserResponse extends $pb.GeneratedMessage {
  factory UpsertUserResponse({
    User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  UpsertUserResponse._() : super();
  factory UpsertUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertUserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUserResponse clone() => UpsertUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUserResponse copyWith(void Function(UpsertUserResponse) updates) => super.copyWith((message) => updates(message as UpsertUserResponse)) as UpsertUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertUserResponse create() => UpsertUserResponse._();
  UpsertUserResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertUserResponse> createRepeated() => $pb.PbList<UpsertUserResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUserResponse>(create);
  static UpsertUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class GetSectorsRequest extends $pb.GeneratedMessage {
  factory GetSectorsRequest() => create();
  GetSectorsRequest._() : super();
  factory GetSectorsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSectorsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSectorsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSectorsRequest clone() => GetSectorsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSectorsRequest copyWith(void Function(GetSectorsRequest) updates) => super.copyWith((message) => updates(message as GetSectorsRequest)) as GetSectorsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSectorsRequest create() => GetSectorsRequest._();
  GetSectorsRequest createEmptyInstance() => create();
  static $pb.PbList<GetSectorsRequest> createRepeated() => $pb.PbList<GetSectorsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSectorsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSectorsRequest>(create);
  static GetSectorsRequest? _defaultInstance;
}

class GetSectorsResponse extends $pb.GeneratedMessage {
  factory GetSectorsResponse({
    $core.Iterable<$0.Sector>? sectors,
  }) {
    final $result = create();
    if (sectors != null) {
      $result.sectors.addAll(sectors);
    }
    return $result;
  }
  GetSectorsResponse._() : super();
  factory GetSectorsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSectorsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSectorsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Sector>(1, _omitFieldNames ? '' : 'sectors', $pb.PbFieldType.PM, subBuilder: $0.Sector.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSectorsResponse clone() => GetSectorsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSectorsResponse copyWith(void Function(GetSectorsResponse) updates) => super.copyWith((message) => updates(message as GetSectorsResponse)) as GetSectorsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSectorsResponse create() => GetSectorsResponse._();
  GetSectorsResponse createEmptyInstance() => create();
  static $pb.PbList<GetSectorsResponse> createRepeated() => $pb.PbList<GetSectorsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSectorsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSectorsResponse>(create);
  static GetSectorsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Sector> get sectors => $_getList(0);
}

class GetCommunitiesRequest extends $pb.GeneratedMessage {
  factory GetCommunitiesRequest() => create();
  GetCommunitiesRequest._() : super();
  factory GetCommunitiesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCommunitiesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCommunitiesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCommunitiesRequest clone() => GetCommunitiesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCommunitiesRequest copyWith(void Function(GetCommunitiesRequest) updates) => super.copyWith((message) => updates(message as GetCommunitiesRequest)) as GetCommunitiesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCommunitiesRequest create() => GetCommunitiesRequest._();
  GetCommunitiesRequest createEmptyInstance() => create();
  static $pb.PbList<GetCommunitiesRequest> createRepeated() => $pb.PbList<GetCommunitiesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCommunitiesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCommunitiesRequest>(create);
  static GetCommunitiesRequest? _defaultInstance;
}

class GetCommunitiesResponse extends $pb.GeneratedMessage {
  factory GetCommunitiesResponse({
    $core.Iterable<$0.Community>? communities,
  }) {
    final $result = create();
    if (communities != null) {
      $result.communities.addAll(communities);
    }
    return $result;
  }
  GetCommunitiesResponse._() : super();
  factory GetCommunitiesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCommunitiesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCommunitiesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Community>(1, _omitFieldNames ? '' : 'communities', $pb.PbFieldType.PM, subBuilder: $0.Community.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCommunitiesResponse clone() => GetCommunitiesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCommunitiesResponse copyWith(void Function(GetCommunitiesResponse) updates) => super.copyWith((message) => updates(message as GetCommunitiesResponse)) as GetCommunitiesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCommunitiesResponse create() => GetCommunitiesResponse._();
  GetCommunitiesResponse createEmptyInstance() => create();
  static $pb.PbList<GetCommunitiesResponse> createRepeated() => $pb.PbList<GetCommunitiesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCommunitiesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCommunitiesResponse>(create);
  static GetCommunitiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Community> get communities => $_getList(0);
}

class GetCustomersRequest extends $pb.GeneratedMessage {
  factory GetCustomersRequest({
    $core.String? sectorId,
    $core.String? searchQuery,
    $core.int? pageNumber,
    $core.int? pageSize,
    $core.String? excludePeriodId,
    $core.String? communityId,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (searchQuery != null) {
      $result.searchQuery = searchQuery;
    }
    if (pageNumber != null) {
      $result.pageNumber = pageNumber;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (excludePeriodId != null) {
      $result.excludePeriodId = excludePeriodId;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    return $result;
  }
  GetCustomersRequest._() : super();
  factory GetCustomersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..aOS(2, _omitFieldNames ? '' : 'searchQuery')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageNumber', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'excludePeriodId')
    ..aOS(6, _omitFieldNames ? '' : 'communityId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomersRequest clone() => GetCustomersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomersRequest copyWith(void Function(GetCustomersRequest) updates) => super.copyWith((message) => updates(message as GetCustomersRequest)) as GetCustomersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomersRequest create() => GetCustomersRequest._();
  GetCustomersRequest createEmptyInstance() => create();
  static $pb.PbList<GetCustomersRequest> createRepeated() => $pb.PbList<GetCustomersRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCustomersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomersRequest>(create);
  static GetCustomersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sectorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sectorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSectorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSectorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get searchQuery => $_getSZ(1);
  @$pb.TagNumber(2)
  set searchQuery($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSearchQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearSearchQuery() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get excludePeriodId => $_getSZ(4);
  @$pb.TagNumber(5)
  set excludePeriodId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExcludePeriodId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExcludePeriodId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get communityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set communityId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCommunityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCommunityId() => clearField(6);
}

class GetCustomersResponse extends $pb.GeneratedMessage {
  factory GetCustomersResponse({
    $core.Iterable<$0.Customer>? customers,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (customers != null) {
      $result.customers.addAll(customers);
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  GetCustomersResponse._() : super();
  factory GetCustomersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Customer>(1, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.PM, subBuilder: $0.Customer.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomersResponse clone() => GetCustomersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomersResponse copyWith(void Function(GetCustomersResponse) updates) => super.copyWith((message) => updates(message as GetCustomersResponse)) as GetCustomersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomersResponse create() => GetCustomersResponse._();
  GetCustomersResponse createEmptyInstance() => create();
  static $pb.PbList<GetCustomersResponse> createRepeated() => $pb.PbList<GetCustomersResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCustomersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomersResponse>(create);
  static GetCustomersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Customer> get customers => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => clearField(2);
}

class GetReadingsRequest extends $pb.GeneratedMessage {
  factory GetReadingsRequest({
    $core.String? customerId,
    $core.String? sectorId,
    $core.String? period,
    $core.int? pageNumber,
    $core.int? pageSize,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (period != null) {
      $result.period = period;
    }
    if (pageNumber != null) {
      $result.pageNumber = pageNumber;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    return $result;
  }
  GetReadingsRequest._() : super();
  factory GetReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorId')
    ..aOS(3, _omitFieldNames ? '' : 'period')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pageNumber', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReadingsRequest clone() => GetReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReadingsRequest copyWith(void Function(GetReadingsRequest) updates) => super.copyWith((message) => updates(message as GetReadingsRequest)) as GetReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadingsRequest create() => GetReadingsRequest._();
  GetReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetReadingsRequest> createRepeated() => $pb.PbList<GetReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReadingsRequest>(create);
  static GetReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSectorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectorId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get period => $_getSZ(2);
  @$pb.TagNumber(3)
  set period($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriod() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageNumber => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageNumber($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPageNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageNumber() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => clearField(5);
}

class GetReadingsResponse extends $pb.GeneratedMessage {
  factory GetReadingsResponse({
    $core.Iterable<$0.Reading>? readings,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  GetReadingsResponse._() : super();
  factory GetReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Reading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReadingsResponse clone() => GetReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReadingsResponse copyWith(void Function(GetReadingsResponse) updates) => super.copyWith((message) => updates(message as GetReadingsResponse)) as GetReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadingsResponse create() => GetReadingsResponse._();
  GetReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetReadingsResponse> createRepeated() => $pb.PbList<GetReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReadingsResponse>(create);
  static GetReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Reading> get readings => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => clearField(2);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => create();
  GetSettingsRequest._() : super();
  factory GetSettingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSettingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSettingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSettingsRequest clone() => GetSettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) => super.copyWith((message) => updates(message as GetSettingsRequest)) as GetSettingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  GetSettingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetSettingsRequest> createRepeated() => $pb.PbList<GetSettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  GetSettingsResponse._() : super();
  factory GetSettingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSettingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSettingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSettingsResponse clone() => GetSettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) => super.copyWith((message) => updates(message as GetSettingsResponse)) as GetSettingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse create() => GetSettingsResponse._();
  GetSettingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetSettingsResponse> createRepeated() => $pb.PbList<GetSettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(create);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  UpdateSettingsRequest._() : super();
  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSettingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateSettingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSettingsRequest clone() => UpdateSettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSettingsRequest copyWith(void Function(UpdateSettingsRequest) updates) => super.copyWith((message) => updates(message as UpdateSettingsRequest)) as UpdateSettingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  UpdateSettingsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSettingsRequest> createRepeated() => $pb.PbList<UpdateSettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  UpdateSettingsResponse._() : super();
  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSettingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateSettingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSettingsResponse clone() => UpdateSettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSettingsResponse copyWith(void Function(UpdateSettingsResponse) updates) => super.copyWith((message) => updates(message as UpdateSettingsResponse)) as UpdateSettingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  UpdateSettingsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateSettingsResponse> createRepeated() => $pb.PbList<UpdateSettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(create);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpsertCustomerRequest extends $pb.GeneratedMessage {
  factory UpsertCustomerRequest({
    $0.Customer? customer,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    return $result;
  }
  UpsertCustomerRequest._() : super();
  factory UpsertCustomerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCustomerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCustomerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCustomerRequest clone() => UpsertCustomerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCustomerRequest copyWith(void Function(UpsertCustomerRequest) updates) => super.copyWith((message) => updates(message as UpsertCustomerRequest)) as UpsertCustomerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCustomerRequest create() => UpsertCustomerRequest._();
  UpsertCustomerRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertCustomerRequest> createRepeated() => $pb.PbList<UpsertCustomerRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertCustomerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCustomerRequest>(create);
  static UpsertCustomerRequest? _defaultInstance;

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
}

class UpsertCustomerResponse extends $pb.GeneratedMessage {
  factory UpsertCustomerResponse({
    $0.Customer? customer,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    return $result;
  }
  UpsertCustomerResponse._() : super();
  factory UpsertCustomerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCustomerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCustomerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCustomerResponse clone() => UpsertCustomerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCustomerResponse copyWith(void Function(UpsertCustomerResponse) updates) => super.copyWith((message) => updates(message as UpsertCustomerResponse)) as UpsertCustomerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCustomerResponse create() => UpsertCustomerResponse._();
  UpsertCustomerResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertCustomerResponse> createRepeated() => $pb.PbList<UpsertCustomerResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertCustomerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCustomerResponse>(create);
  static UpsertCustomerResponse? _defaultInstance;

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
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? email,
    UserRole? role,
    $core.Iterable<$core.String>? assignedSectorIds,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (email != null) {
      $result.email = email;
    }
    if (role != null) {
      $result.role = role;
    }
    if (assignedSectorIds != null) {
      $result.assignedSectorIds.addAll(assignedSectorIds);
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..e<UserRole>(3, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: UserRole.USER_ROLE_UNSPECIFIED, valueOf: UserRole.valueOf, enumValues: UserRole.values)
    ..pPS(4, _omitFieldNames ? '' : 'assignedSectorIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

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
  UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role(UserRole v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.String> get assignedSectorIds => $_getList(3);
}

class GetDashboardStatsRequest extends $pb.GeneratedMessage {
  factory GetDashboardStatsRequest({
    $core.String? period,
  }) {
    final $result = create();
    if (period != null) {
      $result.period = period;
    }
    return $result;
  }
  GetDashboardStatsRequest._() : super();
  factory GetDashboardStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDashboardStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDashboardStatsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDashboardStatsRequest clone() => GetDashboardStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDashboardStatsRequest copyWith(void Function(GetDashboardStatsRequest) updates) => super.copyWith((message) => updates(message as GetDashboardStatsRequest)) as GetDashboardStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsRequest create() => GetDashboardStatsRequest._();
  GetDashboardStatsRequest createEmptyInstance() => create();
  static $pb.PbList<GetDashboardStatsRequest> createRepeated() => $pb.PbList<GetDashboardStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDashboardStatsRequest>(create);
  static GetDashboardStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get period => $_getSZ(0);
  @$pb.TagNumber(1)
  set period($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => clearField(1);
}

class GetDashboardStatsResponse extends $pb.GeneratedMessage {
  factory GetDashboardStatsResponse({
    $core.int? totalCustomers,
    $core.int? totalUsers,
    $core.int? totalReadingsPeriod,
    $core.int? pendingReadingsPeriod,
    $core.double? totalRevenue,
    $core.double? totalConsumptionKwh,
    $core.double? previousConsumptionKwh,
    $core.Iterable<SectorStat>? sectorStats,
  }) {
    final $result = create();
    if (totalCustomers != null) {
      $result.totalCustomers = totalCustomers;
    }
    if (totalUsers != null) {
      $result.totalUsers = totalUsers;
    }
    if (totalReadingsPeriod != null) {
      $result.totalReadingsPeriod = totalReadingsPeriod;
    }
    if (pendingReadingsPeriod != null) {
      $result.pendingReadingsPeriod = pendingReadingsPeriod;
    }
    if (totalRevenue != null) {
      $result.totalRevenue = totalRevenue;
    }
    if (totalConsumptionKwh != null) {
      $result.totalConsumptionKwh = totalConsumptionKwh;
    }
    if (previousConsumptionKwh != null) {
      $result.previousConsumptionKwh = previousConsumptionKwh;
    }
    if (sectorStats != null) {
      $result.sectorStats.addAll(sectorStats);
    }
    return $result;
  }
  GetDashboardStatsResponse._() : super();
  factory GetDashboardStatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDashboardStatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDashboardStatsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalCustomers', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalUsers', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalReadingsPeriod', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pendingReadingsPeriod', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalRevenue', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalConsumptionKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'previousConsumptionKwh', $pb.PbFieldType.OD)
    ..pc<SectorStat>(8, _omitFieldNames ? '' : 'sectorStats', $pb.PbFieldType.PM, subBuilder: SectorStat.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDashboardStatsResponse clone() => GetDashboardStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDashboardStatsResponse copyWith(void Function(GetDashboardStatsResponse) updates) => super.copyWith((message) => updates(message as GetDashboardStatsResponse)) as GetDashboardStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsResponse create() => GetDashboardStatsResponse._();
  GetDashboardStatsResponse createEmptyInstance() => create();
  static $pb.PbList<GetDashboardStatsResponse> createRepeated() => $pb.PbList<GetDashboardStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDashboardStatsResponse>(create);
  static GetDashboardStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCustomers => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCustomers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalCustomers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCustomers() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalUsers => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalUsers($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalUsers() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalReadingsPeriod => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalReadingsPeriod($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalReadingsPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalReadingsPeriod() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get pendingReadingsPeriod => $_getIZ(3);
  @$pb.TagNumber(4)
  set pendingReadingsPeriod($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPendingReadingsPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingReadingsPeriod() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalRevenue => $_getN(4);
  @$pb.TagNumber(5)
  set totalRevenue($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalRevenue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalRevenue() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalConsumptionKwh => $_getN(5);
  @$pb.TagNumber(6)
  set totalConsumptionKwh($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalConsumptionKwh() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalConsumptionKwh() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get previousConsumptionKwh => $_getN(6);
  @$pb.TagNumber(7)
  set previousConsumptionKwh($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPreviousConsumptionKwh() => $_has(6);
  @$pb.TagNumber(7)
  void clearPreviousConsumptionKwh() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<SectorStat> get sectorStats => $_getList(7);
}

class SectorStat extends $pb.GeneratedMessage {
  factory SectorStat({
    $core.String? sectorId,
    $core.String? sectorName,
    $core.int? registeredCount,
    $core.int? totalCount,
    $core.int? progressPercentage,
    $core.double? totalConsumption,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (sectorName != null) {
      $result.sectorName = sectorName;
    }
    if (registeredCount != null) {
      $result.registeredCount = registeredCount;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    if (progressPercentage != null) {
      $result.progressPercentage = progressPercentage;
    }
    if (totalConsumption != null) {
      $result.totalConsumption = totalConsumption;
    }
    return $result;
  }
  SectorStat._() : super();
  factory SectorStat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SectorStat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SectorStat', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorName')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'registeredCount', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'progressPercentage', $pb.PbFieldType.O3)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalConsumption', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SectorStat clone() => SectorStat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SectorStat copyWith(void Function(SectorStat) updates) => super.copyWith((message) => updates(message as SectorStat)) as SectorStat;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SectorStat create() => SectorStat._();
  SectorStat createEmptyInstance() => create();
  static $pb.PbList<SectorStat> createRepeated() => $pb.PbList<SectorStat>();
  @$core.pragma('dart2js:noInline')
  static SectorStat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SectorStat>(create);
  static SectorStat? _defaultInstance;

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
  $core.int get registeredCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set registeredCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRegisteredCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegisteredCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get progressPercentage => $_getIZ(4);
  @$pb.TagNumber(5)
  set progressPercentage($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProgressPercentage() => $_has(4);
  @$pb.TagNumber(5)
  void clearProgressPercentage() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalConsumption => $_getN(5);
  @$pb.TagNumber(6)
  set totalConsumption($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalConsumption() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalConsumption() => clearField(6);
}

class ListPeriodsRequest extends $pb.GeneratedMessage {
  factory ListPeriodsRequest() => create();
  ListPeriodsRequest._() : super();
  factory ListPeriodsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeriodsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPeriodsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeriodsRequest clone() => ListPeriodsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeriodsRequest copyWith(void Function(ListPeriodsRequest) updates) => super.copyWith((message) => updates(message as ListPeriodsRequest)) as ListPeriodsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeriodsRequest create() => ListPeriodsRequest._();
  ListPeriodsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPeriodsRequest> createRepeated() => $pb.PbList<ListPeriodsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPeriodsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPeriodsRequest>(create);
  static ListPeriodsRequest? _defaultInstance;
}

class ListPeriodsResponse extends $pb.GeneratedMessage {
  factory ListPeriodsResponse({
    $core.Iterable<$0.Period>? periods,
  }) {
    final $result = create();
    if (periods != null) {
      $result.periods.addAll(periods);
    }
    return $result;
  }
  ListPeriodsResponse._() : super();
  factory ListPeriodsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeriodsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPeriodsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Period>(1, _omitFieldNames ? '' : 'periods', $pb.PbFieldType.PM, subBuilder: $0.Period.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeriodsResponse clone() => ListPeriodsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeriodsResponse copyWith(void Function(ListPeriodsResponse) updates) => super.copyWith((message) => updates(message as ListPeriodsResponse)) as ListPeriodsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeriodsResponse create() => ListPeriodsResponse._();
  ListPeriodsResponse createEmptyInstance() => create();
  static $pb.PbList<ListPeriodsResponse> createRepeated() => $pb.PbList<ListPeriodsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPeriodsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPeriodsResponse>(create);
  static ListPeriodsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Period> get periods => $_getList(0);
}

class GetPeriodStatsRequest extends $pb.GeneratedMessage {
  factory GetPeriodStatsRequest({
    $core.String? periodId,
  }) {
    final $result = create();
    if (periodId != null) {
      $result.periodId = periodId;
    }
    return $result;
  }
  GetPeriodStatsRequest._() : super();
  factory GetPeriodStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPeriodStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPeriodStatsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'periodId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPeriodStatsRequest clone() => GetPeriodStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPeriodStatsRequest copyWith(void Function(GetPeriodStatsRequest) updates) => super.copyWith((message) => updates(message as GetPeriodStatsRequest)) as GetPeriodStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPeriodStatsRequest create() => GetPeriodStatsRequest._();
  GetPeriodStatsRequest createEmptyInstance() => create();
  static $pb.PbList<GetPeriodStatsRequest> createRepeated() => $pb.PbList<GetPeriodStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPeriodStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPeriodStatsRequest>(create);
  static GetPeriodStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get periodId => $_getSZ(0);
  @$pb.TagNumber(1)
  set periodId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeriodId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriodId() => clearField(1);
}

class GetPeriodStatsResponse extends $pb.GeneratedMessage {
  factory GetPeriodStatsResponse({
    $core.int? totalCustomers,
    $core.int? readingsCaptured,
    $core.int? missingReadings,
    $core.Iterable<MissingCustomer>? missingCustomers,
  }) {
    final $result = create();
    if (totalCustomers != null) {
      $result.totalCustomers = totalCustomers;
    }
    if (readingsCaptured != null) {
      $result.readingsCaptured = readingsCaptured;
    }
    if (missingReadings != null) {
      $result.missingReadings = missingReadings;
    }
    if (missingCustomers != null) {
      $result.missingCustomers.addAll(missingCustomers);
    }
    return $result;
  }
  GetPeriodStatsResponse._() : super();
  factory GetPeriodStatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPeriodStatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPeriodStatsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalCustomers', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'readingsCaptured', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'missingReadings', $pb.PbFieldType.O3)
    ..pc<MissingCustomer>(4, _omitFieldNames ? '' : 'missingCustomers', $pb.PbFieldType.PM, subBuilder: MissingCustomer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPeriodStatsResponse clone() => GetPeriodStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPeriodStatsResponse copyWith(void Function(GetPeriodStatsResponse) updates) => super.copyWith((message) => updates(message as GetPeriodStatsResponse)) as GetPeriodStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPeriodStatsResponse create() => GetPeriodStatsResponse._();
  GetPeriodStatsResponse createEmptyInstance() => create();
  static $pb.PbList<GetPeriodStatsResponse> createRepeated() => $pb.PbList<GetPeriodStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetPeriodStatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPeriodStatsResponse>(create);
  static GetPeriodStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCustomers => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCustomers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalCustomers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCustomers() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get readingsCaptured => $_getIZ(1);
  @$pb.TagNumber(2)
  set readingsCaptured($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReadingsCaptured() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadingsCaptured() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get missingReadings => $_getIZ(2);
  @$pb.TagNumber(3)
  set missingReadings($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMissingReadings() => $_has(2);
  @$pb.TagNumber(3)
  void clearMissingReadings() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<MissingCustomer> get missingCustomers => $_getList(3);
}

class MissingCustomer extends $pb.GeneratedMessage {
  factory MissingCustomer({
    $core.String? id,
    $core.String? name,
    $core.String? code,
    $core.String? sectorName,
    $core.String? supervisor,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (code != null) {
      $result.code = code;
    }
    if (sectorName != null) {
      $result.sectorName = sectorName;
    }
    if (supervisor != null) {
      $result.supervisor = supervisor;
    }
    return $result;
  }
  MissingCustomer._() : super();
  factory MissingCustomer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MissingCustomer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MissingCustomer', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'sectorName')
    ..aOS(5, _omitFieldNames ? '' : 'supervisor')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MissingCustomer clone() => MissingCustomer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MissingCustomer copyWith(void Function(MissingCustomer) updates) => super.copyWith((message) => updates(message as MissingCustomer)) as MissingCustomer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MissingCustomer create() => MissingCustomer._();
  MissingCustomer createEmptyInstance() => create();
  static $pb.PbList<MissingCustomer> createRepeated() => $pb.PbList<MissingCustomer>();
  @$core.pragma('dart2js:noInline')
  static MissingCustomer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MissingCustomer>(create);
  static MissingCustomer? _defaultInstance;

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
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sectorName => $_getSZ(3);
  @$pb.TagNumber(4)
  set sectorName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSectorName() => $_has(3);
  @$pb.TagNumber(4)
  void clearSectorName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get supervisor => $_getSZ(4);
  @$pb.TagNumber(5)
  set supervisor($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSupervisor() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupervisor() => clearField(5);
}

class OpenPeriodRequest extends $pb.GeneratedMessage {
  factory OpenPeriodRequest({
    $core.String? id,
    $core.String? startDate,
    $core.String? endDate,
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
    return $result;
  }
  OpenPeriodRequest._() : super();
  factory OpenPeriodRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenPeriodRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OpenPeriodRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'startDate')
    ..aOS(3, _omitFieldNames ? '' : 'endDate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenPeriodRequest clone() => OpenPeriodRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenPeriodRequest copyWith(void Function(OpenPeriodRequest) updates) => super.copyWith((message) => updates(message as OpenPeriodRequest)) as OpenPeriodRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenPeriodRequest create() => OpenPeriodRequest._();
  OpenPeriodRequest createEmptyInstance() => create();
  static $pb.PbList<OpenPeriodRequest> createRepeated() => $pb.PbList<OpenPeriodRequest>();
  @$core.pragma('dart2js:noInline')
  static OpenPeriodRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenPeriodRequest>(create);
  static OpenPeriodRequest? _defaultInstance;

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
}

class OpenPeriodResponse extends $pb.GeneratedMessage {
  factory OpenPeriodResponse({
    $0.Period? period,
  }) {
    final $result = create();
    if (period != null) {
      $result.period = period;
    }
    return $result;
  }
  OpenPeriodResponse._() : super();
  factory OpenPeriodResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenPeriodResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OpenPeriodResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Period>(1, _omitFieldNames ? '' : 'period', subBuilder: $0.Period.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenPeriodResponse clone() => OpenPeriodResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenPeriodResponse copyWith(void Function(OpenPeriodResponse) updates) => super.copyWith((message) => updates(message as OpenPeriodResponse)) as OpenPeriodResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenPeriodResponse create() => OpenPeriodResponse._();
  OpenPeriodResponse createEmptyInstance() => create();
  static $pb.PbList<OpenPeriodResponse> createRepeated() => $pb.PbList<OpenPeriodResponse>();
  @$core.pragma('dart2js:noInline')
  static OpenPeriodResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenPeriodResponse>(create);
  static OpenPeriodResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Period get period => $_getN(0);
  @$pb.TagNumber(1)
  set period($0.Period v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => clearField(1);
  @$pb.TagNumber(1)
  $0.Period ensurePeriod() => $_ensure(0);
}

class ClosePeriodRequest extends $pb.GeneratedMessage {
  factory ClosePeriodRequest({
    $core.String? id,
    $core.bool? openNext,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (openNext != null) {
      $result.openNext = openNext;
    }
    return $result;
  }
  ClosePeriodRequest._() : super();
  factory ClosePeriodRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClosePeriodRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClosePeriodRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'openNext')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClosePeriodRequest clone() => ClosePeriodRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClosePeriodRequest copyWith(void Function(ClosePeriodRequest) updates) => super.copyWith((message) => updates(message as ClosePeriodRequest)) as ClosePeriodRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClosePeriodRequest create() => ClosePeriodRequest._();
  ClosePeriodRequest createEmptyInstance() => create();
  static $pb.PbList<ClosePeriodRequest> createRepeated() => $pb.PbList<ClosePeriodRequest>();
  @$core.pragma('dart2js:noInline')
  static ClosePeriodRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClosePeriodRequest>(create);
  static ClosePeriodRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get openNext => $_getBF(1);
  @$pb.TagNumber(2)
  set openNext($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOpenNext() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenNext() => clearField(2);
}

class ClosePeriodResponse extends $pb.GeneratedMessage {
  factory ClosePeriodResponse({
    $0.Period? closedPeriod,
    $0.Period? nextPeriod,
  }) {
    final $result = create();
    if (closedPeriod != null) {
      $result.closedPeriod = closedPeriod;
    }
    if (nextPeriod != null) {
      $result.nextPeriod = nextPeriod;
    }
    return $result;
  }
  ClosePeriodResponse._() : super();
  factory ClosePeriodResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClosePeriodResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClosePeriodResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Period>(1, _omitFieldNames ? '' : 'closedPeriod', subBuilder: $0.Period.create)
    ..aOM<$0.Period>(2, _omitFieldNames ? '' : 'nextPeriod', subBuilder: $0.Period.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClosePeriodResponse clone() => ClosePeriodResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClosePeriodResponse copyWith(void Function(ClosePeriodResponse) updates) => super.copyWith((message) => updates(message as ClosePeriodResponse)) as ClosePeriodResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClosePeriodResponse create() => ClosePeriodResponse._();
  ClosePeriodResponse createEmptyInstance() => create();
  static $pb.PbList<ClosePeriodResponse> createRepeated() => $pb.PbList<ClosePeriodResponse>();
  @$core.pragma('dart2js:noInline')
  static ClosePeriodResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClosePeriodResponse>(create);
  static ClosePeriodResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Period get closedPeriod => $_getN(0);
  @$pb.TagNumber(1)
  set closedPeriod($0.Period v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasClosedPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosedPeriod() => clearField(1);
  @$pb.TagNumber(1)
  $0.Period ensureClosedPeriod() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Period get nextPeriod => $_getN(1);
  @$pb.TagNumber(2)
  set nextPeriod($0.Period v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNextPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPeriod() => clearField(2);
  @$pb.TagNumber(2)
  $0.Period ensureNextPeriod() => $_ensure(1);
}

class TogglePaymentStatusRequest extends $pb.GeneratedMessage {
  factory TogglePaymentStatusRequest({
    $core.String? readingId,
    $core.bool? isPaid,
    $core.String? customerId,
    $core.String? period,
    $core.double? totalToPay,
    $core.String? observation,
  }) {
    final $result = create();
    if (readingId != null) {
      $result.readingId = readingId;
    }
    if (isPaid != null) {
      $result.isPaid = isPaid;
    }
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (period != null) {
      $result.period = period;
    }
    if (totalToPay != null) {
      $result.totalToPay = totalToPay;
    }
    if (observation != null) {
      $result.observation = observation;
    }
    return $result;
  }
  TogglePaymentStatusRequest._() : super();
  factory TogglePaymentStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TogglePaymentStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TogglePaymentStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOB(2, _omitFieldNames ? '' : 'isPaid')
    ..aOS(3, _omitFieldNames ? '' : 'customerId')
    ..aOS(4, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalToPay', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'observation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TogglePaymentStatusRequest clone() => TogglePaymentStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TogglePaymentStatusRequest copyWith(void Function(TogglePaymentStatusRequest) updates) => super.copyWith((message) => updates(message as TogglePaymentStatusRequest)) as TogglePaymentStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TogglePaymentStatusRequest create() => TogglePaymentStatusRequest._();
  TogglePaymentStatusRequest createEmptyInstance() => create();
  static $pb.PbList<TogglePaymentStatusRequest> createRepeated() => $pb.PbList<TogglePaymentStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static TogglePaymentStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TogglePaymentStatusRequest>(create);
  static TogglePaymentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isPaid => $_getBF(1);
  @$pb.TagNumber(2)
  set isPaid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsPaid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsPaid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get customerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set customerId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustomerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get period => $_getSZ(3);
  @$pb.TagNumber(4)
  set period($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriod() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalToPay => $_getN(4);
  @$pb.TagNumber(5)
  set totalToPay($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalToPay() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalToPay() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get observation => $_getSZ(5);
  @$pb.TagNumber(6)
  set observation($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObservation() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservation() => clearField(6);
}

class TogglePaymentStatusResponse extends $pb.GeneratedMessage {
  factory TogglePaymentStatusResponse({
    $core.String? readingId,
    $core.bool? isPaid,
  }) {
    final $result = create();
    if (readingId != null) {
      $result.readingId = readingId;
    }
    if (isPaid != null) {
      $result.isPaid = isPaid;
    }
    return $result;
  }
  TogglePaymentStatusResponse._() : super();
  factory TogglePaymentStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TogglePaymentStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TogglePaymentStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOB(2, _omitFieldNames ? '' : 'isPaid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TogglePaymentStatusResponse clone() => TogglePaymentStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TogglePaymentStatusResponse copyWith(void Function(TogglePaymentStatusResponse) updates) => super.copyWith((message) => updates(message as TogglePaymentStatusResponse)) as TogglePaymentStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TogglePaymentStatusResponse create() => TogglePaymentStatusResponse._();
  TogglePaymentStatusResponse createEmptyInstance() => create();
  static $pb.PbList<TogglePaymentStatusResponse> createRepeated() => $pb.PbList<TogglePaymentStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static TogglePaymentStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TogglePaymentStatusResponse>(create);
  static TogglePaymentStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isPaid => $_getBF(1);
  @$pb.TagNumber(2)
  set isPaid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsPaid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsPaid() => clearField(2);
}

class GetCollectionsRequest extends $pb.GeneratedMessage {
  factory GetCollectionsRequest({
    $core.String? sectorId,
    $core.Iterable<$core.String>? periods,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (periods != null) {
      $result.periods.addAll(periods);
    }
    return $result;
  }
  GetCollectionsRequest._() : super();
  factory GetCollectionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..pPS(2, _omitFieldNames ? '' : 'periods')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionsRequest clone() => GetCollectionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionsRequest copyWith(void Function(GetCollectionsRequest) updates) => super.copyWith((message) => updates(message as GetCollectionsRequest)) as GetCollectionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionsRequest create() => GetCollectionsRequest._();
  GetCollectionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCollectionsRequest> createRepeated() => $pb.PbList<GetCollectionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionsRequest>(create);
  static GetCollectionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sectorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sectorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSectorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSectorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get periods => $_getList(1);
}

class GetCollectionsResponse extends $pb.GeneratedMessage {
  factory GetCollectionsResponse({
    $core.Iterable<$0.Reading>? readings,
    $core.Iterable<CollectionCustomer>? customers,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    if (customers != null) {
      $result.customers.addAll(customers);
    }
    return $result;
  }
  GetCollectionsResponse._() : super();
  factory GetCollectionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCollectionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCollectionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Reading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..pc<CollectionCustomer>(2, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.PM, subBuilder: CollectionCustomer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCollectionsResponse clone() => GetCollectionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCollectionsResponse copyWith(void Function(GetCollectionsResponse) updates) => super.copyWith((message) => updates(message as GetCollectionsResponse)) as GetCollectionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCollectionsResponse create() => GetCollectionsResponse._();
  GetCollectionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetCollectionsResponse> createRepeated() => $pb.PbList<GetCollectionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCollectionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCollectionsResponse>(create);
  static GetCollectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Reading> get readings => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<CollectionCustomer> get customers => $_getList(1);
}

class CollectionCustomer extends $pb.GeneratedMessage {
  factory CollectionCustomer({
    $0.Customer? customer,
    $core.Iterable<$0.Reading>? readings,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    return $result;
  }
  CollectionCustomer._() : super();
  factory CollectionCustomer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CollectionCustomer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CollectionCustomer', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..pc<$0.Reading>(2, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CollectionCustomer clone() => CollectionCustomer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CollectionCustomer copyWith(void Function(CollectionCustomer) updates) => super.copyWith((message) => updates(message as CollectionCustomer)) as CollectionCustomer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionCustomer create() => CollectionCustomer._();
  CollectionCustomer createEmptyInstance() => create();
  static $pb.PbList<CollectionCustomer> createRepeated() => $pb.PbList<CollectionCustomer>();
  @$core.pragma('dart2js:noInline')
  static CollectionCustomer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CollectionCustomer>(create);
  static CollectionCustomer? _defaultInstance;

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
  $core.List<$0.Reading> get readings => $_getList(1);
}

class DeleteSectorRequest extends $pb.GeneratedMessage {
  factory DeleteSectorRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteSectorRequest._() : super();
  factory DeleteSectorRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSectorRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSectorRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSectorRequest clone() => DeleteSectorRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSectorRequest copyWith(void Function(DeleteSectorRequest) updates) => super.copyWith((message) => updates(message as DeleteSectorRequest)) as DeleteSectorRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSectorRequest create() => DeleteSectorRequest._();
  DeleteSectorRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteSectorRequest> createRepeated() => $pb.PbList<DeleteSectorRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteSectorRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSectorRequest>(create);
  static DeleteSectorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteSectorResponse extends $pb.GeneratedMessage {
  factory DeleteSectorResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  DeleteSectorResponse._() : super();
  factory DeleteSectorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSectorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSectorResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSectorResponse clone() => DeleteSectorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSectorResponse copyWith(void Function(DeleteSectorResponse) updates) => super.copyWith((message) => updates(message as DeleteSectorResponse)) as DeleteSectorResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSectorResponse create() => DeleteSectorResponse._();
  DeleteSectorResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteSectorResponse> createRepeated() => $pb.PbList<DeleteSectorResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteSectorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSectorResponse>(create);
  static DeleteSectorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class DeleteCommunityRequest extends $pb.GeneratedMessage {
  factory DeleteCommunityRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteCommunityRequest._() : super();
  factory DeleteCommunityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCommunityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteCommunityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCommunityRequest clone() => DeleteCommunityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCommunityRequest copyWith(void Function(DeleteCommunityRequest) updates) => super.copyWith((message) => updates(message as DeleteCommunityRequest)) as DeleteCommunityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteCommunityRequest create() => DeleteCommunityRequest._();
  DeleteCommunityRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCommunityRequest> createRepeated() => $pb.PbList<DeleteCommunityRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCommunityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCommunityRequest>(create);
  static DeleteCommunityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteCommunityResponse extends $pb.GeneratedMessage {
  factory DeleteCommunityResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  DeleteCommunityResponse._() : super();
  factory DeleteCommunityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCommunityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteCommunityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCommunityResponse clone() => DeleteCommunityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCommunityResponse copyWith(void Function(DeleteCommunityResponse) updates) => super.copyWith((message) => updates(message as DeleteCommunityResponse)) as DeleteCommunityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteCommunityResponse create() => DeleteCommunityResponse._();
  DeleteCommunityResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCommunityResponse> createRepeated() => $pb.PbList<DeleteCommunityResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCommunityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCommunityResponse>(create);
  static DeleteCommunityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class AdminServiceApi {
  $pb.RpcClient _client;
  AdminServiceApi(this._client);

  $async.Future<LoginResponse> login($pb.ClientContext? ctx, LoginRequest request) =>
    _client.invoke<LoginResponse>(ctx, 'AdminService', 'Login', request, LoginResponse())
  ;
  $async.Future<GetUsersResponse> getUsers($pb.ClientContext? ctx, GetUsersRequest request) =>
    _client.invoke<GetUsersResponse>(ctx, 'AdminService', 'GetUsers', request, GetUsersResponse())
  ;
  $async.Future<UpsertUserResponse> upsertUser($pb.ClientContext? ctx, UpsertUserRequest request) =>
    _client.invoke<UpsertUserResponse>(ctx, 'AdminService', 'UpsertUser', request, UpsertUserResponse())
  ;
  $async.Future<GetSectorsResponse> getSectors($pb.ClientContext? ctx, GetSectorsRequest request) =>
    _client.invoke<GetSectorsResponse>(ctx, 'AdminService', 'GetSectors', request, GetSectorsResponse())
  ;
  $async.Future<GetCommunitiesResponse> getCommunities($pb.ClientContext? ctx, GetCommunitiesRequest request) =>
    _client.invoke<GetCommunitiesResponse>(ctx, 'AdminService', 'GetCommunities', request, GetCommunitiesResponse())
  ;
  $async.Future<GetCustomersResponse> getCustomers($pb.ClientContext? ctx, GetCustomersRequest request) =>
    _client.invoke<GetCustomersResponse>(ctx, 'AdminService', 'GetCustomers', request, GetCustomersResponse())
  ;
  $async.Future<GetReadingsResponse> getReadings($pb.ClientContext? ctx, GetReadingsRequest request) =>
    _client.invoke<GetReadingsResponse>(ctx, 'AdminService', 'GetReadings', request, GetReadingsResponse())
  ;
  $async.Future<GetSettingsResponse> getSettings($pb.ClientContext? ctx, GetSettingsRequest request) =>
    _client.invoke<GetSettingsResponse>(ctx, 'AdminService', 'GetSettings', request, GetSettingsResponse())
  ;
  $async.Future<UpdateSettingsResponse> updateSettings($pb.ClientContext? ctx, UpdateSettingsRequest request) =>
    _client.invoke<UpdateSettingsResponse>(ctx, 'AdminService', 'UpdateSettings', request, UpdateSettingsResponse())
  ;
  $async.Future<UpsertCustomerResponse> upsertCustomer($pb.ClientContext? ctx, UpsertCustomerRequest request) =>
    _client.invoke<UpsertCustomerResponse>(ctx, 'AdminService', 'UpsertCustomer', request, UpsertCustomerResponse())
  ;
  $async.Future<DeleteCustomerResponse> deleteCustomer($pb.ClientContext? ctx, DeleteCustomerRequest request) =>
    _client.invoke<DeleteCustomerResponse>(ctx, 'AdminService', 'DeleteCustomer', request, DeleteCustomerResponse())
  ;
  $async.Future<GetDashboardStatsResponse> getDashboardStats($pb.ClientContext? ctx, GetDashboardStatsRequest request) =>
    _client.invoke<GetDashboardStatsResponse>(ctx, 'AdminService', 'GetDashboardStats', request, GetDashboardStatsResponse())
  ;
  $async.Future<ListPeriodsResponse> listPeriods($pb.ClientContext? ctx, ListPeriodsRequest request) =>
    _client.invoke<ListPeriodsResponse>(ctx, 'AdminService', 'ListPeriods', request, ListPeriodsResponse())
  ;
  $async.Future<GetPeriodStatsResponse> getPeriodStats($pb.ClientContext? ctx, GetPeriodStatsRequest request) =>
    _client.invoke<GetPeriodStatsResponse>(ctx, 'AdminService', 'GetPeriodStats', request, GetPeriodStatsResponse())
  ;
  $async.Future<OpenPeriodResponse> openPeriod($pb.ClientContext? ctx, OpenPeriodRequest request) =>
    _client.invoke<OpenPeriodResponse>(ctx, 'AdminService', 'OpenPeriod', request, OpenPeriodResponse())
  ;
  $async.Future<ClosePeriodResponse> closePeriod($pb.ClientContext? ctx, ClosePeriodRequest request) =>
    _client.invoke<ClosePeriodResponse>(ctx, 'AdminService', 'ClosePeriod', request, ClosePeriodResponse())
  ;
  $async.Future<UpsertSectorResponse> upsertSector($pb.ClientContext? ctx, UpsertSectorRequest request) =>
    _client.invoke<UpsertSectorResponse>(ctx, 'AdminService', 'UpsertSector', request, UpsertSectorResponse())
  ;
  $async.Future<DeleteSectorResponse> deleteSector($pb.ClientContext? ctx, DeleteSectorRequest request) =>
    _client.invoke<DeleteSectorResponse>(ctx, 'AdminService', 'DeleteSector', request, DeleteSectorResponse())
  ;
  $async.Future<UpsertCommunityResponse> upsertCommunity($pb.ClientContext? ctx, UpsertCommunityRequest request) =>
    _client.invoke<UpsertCommunityResponse>(ctx, 'AdminService', 'UpsertCommunity', request, UpsertCommunityResponse())
  ;
  $async.Future<DeleteCommunityResponse> deleteCommunity($pb.ClientContext? ctx, DeleteCommunityRequest request) =>
    _client.invoke<DeleteCommunityResponse>(ctx, 'AdminService', 'DeleteCommunity', request, DeleteCommunityResponse())
  ;
  $async.Future<TogglePaymentStatusResponse> togglePaymentStatus($pb.ClientContext? ctx, TogglePaymentStatusRequest request) =>
    _client.invoke<TogglePaymentStatusResponse>(ctx, 'AdminService', 'TogglePaymentStatus', request, TogglePaymentStatusResponse())
  ;
  $async.Future<GetCollectionsResponse> getCollections($pb.ClientContext? ctx, GetCollectionsRequest request) =>
    _client.invoke<GetCollectionsResponse>(ctx, 'AdminService', 'GetCollections', request, GetCollectionsResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
