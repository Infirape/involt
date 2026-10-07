//
//  Generated code. Do not modify.
//  source: involt/v1/admin.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pb.dart' as $1;
import 'admin.pbjson.dart';

export 'admin.pb.dart';

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$1.LoginResponse> login($pb.ServerContext ctx, $1.LoginRequest request);
  $async.Future<$1.GetUsersResponse> getUsers($pb.ServerContext ctx, $1.GetUsersRequest request);
  $async.Future<$1.UpsertUserResponse> upsertUser($pb.ServerContext ctx, $1.UpsertUserRequest request);
  $async.Future<$1.GetSectorsResponse> getSectors($pb.ServerContext ctx, $1.GetSectorsRequest request);
  $async.Future<$1.GetCommunitiesResponse> getCommunities($pb.ServerContext ctx, $1.GetCommunitiesRequest request);
  $async.Future<$1.GetCustomersResponse> getCustomers($pb.ServerContext ctx, $1.GetCustomersRequest request);
  $async.Future<$1.GetReadingsResponse> getReadings($pb.ServerContext ctx, $1.GetReadingsRequest request);
  $async.Future<$1.GetSettingsResponse> getSettings($pb.ServerContext ctx, $1.GetSettingsRequest request);
  $async.Future<$1.UpdateSettingsResponse> updateSettings($pb.ServerContext ctx, $1.UpdateSettingsRequest request);
  $async.Future<$1.UpsertCustomerResponse> upsertCustomer($pb.ServerContext ctx, $1.UpsertCustomerRequest request);
  $async.Future<$1.DeleteCustomerResponse> deleteCustomer($pb.ServerContext ctx, $1.DeleteCustomerRequest request);
  $async.Future<$1.GetDashboardStatsResponse> getDashboardStats($pb.ServerContext ctx, $1.GetDashboardStatsRequest request);
  $async.Future<$1.ListPeriodsResponse> listPeriods($pb.ServerContext ctx, $1.ListPeriodsRequest request);
  $async.Future<$1.GetPeriodStatsResponse> getPeriodStats($pb.ServerContext ctx, $1.GetPeriodStatsRequest request);
  $async.Future<$1.OpenPeriodResponse> openPeriod($pb.ServerContext ctx, $1.OpenPeriodRequest request);
  $async.Future<$1.ClosePeriodResponse> closePeriod($pb.ServerContext ctx, $1.ClosePeriodRequest request);
  $async.Future<$1.UpsertSectorResponse> upsertSector($pb.ServerContext ctx, $1.UpsertSectorRequest request);
  $async.Future<$1.DeleteSectorResponse> deleteSector($pb.ServerContext ctx, $1.DeleteSectorRequest request);
  $async.Future<$1.UpsertCommunityResponse> upsertCommunity($pb.ServerContext ctx, $1.UpsertCommunityRequest request);
  $async.Future<$1.DeleteCommunityResponse> deleteCommunity($pb.ServerContext ctx, $1.DeleteCommunityRequest request);
  $async.Future<$1.TogglePaymentStatusResponse> togglePaymentStatus($pb.ServerContext ctx, $1.TogglePaymentStatusRequest request);
  $async.Future<$1.GetCollectionsResponse> getCollections($pb.ServerContext ctx, $1.GetCollectionsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $1.LoginRequest();
      case 'GetUsers': return $1.GetUsersRequest();
      case 'UpsertUser': return $1.UpsertUserRequest();
      case 'GetSectors': return $1.GetSectorsRequest();
      case 'GetCommunities': return $1.GetCommunitiesRequest();
      case 'GetCustomers': return $1.GetCustomersRequest();
      case 'GetReadings': return $1.GetReadingsRequest();
      case 'GetSettings': return $1.GetSettingsRequest();
      case 'UpdateSettings': return $1.UpdateSettingsRequest();
      case 'UpsertCustomer': return $1.UpsertCustomerRequest();
      case 'DeleteCustomer': return $1.DeleteCustomerRequest();
      case 'GetDashboardStats': return $1.GetDashboardStatsRequest();
      case 'ListPeriods': return $1.ListPeriodsRequest();
      case 'GetPeriodStats': return $1.GetPeriodStatsRequest();
      case 'OpenPeriod': return $1.OpenPeriodRequest();
      case 'ClosePeriod': return $1.ClosePeriodRequest();
      case 'UpsertSector': return $1.UpsertSectorRequest();
      case 'DeleteSector': return $1.DeleteSectorRequest();
      case 'UpsertCommunity': return $1.UpsertCommunityRequest();
      case 'DeleteCommunity': return $1.DeleteCommunityRequest();
      case 'TogglePaymentStatus': return $1.TogglePaymentStatusRequest();
      case 'GetCollections': return $1.GetCollectionsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $1.LoginRequest);
      case 'GetUsers': return this.getUsers(ctx, request as $1.GetUsersRequest);
      case 'UpsertUser': return this.upsertUser(ctx, request as $1.UpsertUserRequest);
      case 'GetSectors': return this.getSectors(ctx, request as $1.GetSectorsRequest);
      case 'GetCommunities': return this.getCommunities(ctx, request as $1.GetCommunitiesRequest);
      case 'GetCustomers': return this.getCustomers(ctx, request as $1.GetCustomersRequest);
      case 'GetReadings': return this.getReadings(ctx, request as $1.GetReadingsRequest);
      case 'GetSettings': return this.getSettings(ctx, request as $1.GetSettingsRequest);
      case 'UpdateSettings': return this.updateSettings(ctx, request as $1.UpdateSettingsRequest);
      case 'UpsertCustomer': return this.upsertCustomer(ctx, request as $1.UpsertCustomerRequest);
      case 'DeleteCustomer': return this.deleteCustomer(ctx, request as $1.DeleteCustomerRequest);
      case 'GetDashboardStats': return this.getDashboardStats(ctx, request as $1.GetDashboardStatsRequest);
      case 'ListPeriods': return this.listPeriods(ctx, request as $1.ListPeriodsRequest);
      case 'GetPeriodStats': return this.getPeriodStats(ctx, request as $1.GetPeriodStatsRequest);
      case 'OpenPeriod': return this.openPeriod(ctx, request as $1.OpenPeriodRequest);
      case 'ClosePeriod': return this.closePeriod(ctx, request as $1.ClosePeriodRequest);
      case 'UpsertSector': return this.upsertSector(ctx, request as $1.UpsertSectorRequest);
      case 'DeleteSector': return this.deleteSector(ctx, request as $1.DeleteSectorRequest);
      case 'UpsertCommunity': return this.upsertCommunity(ctx, request as $1.UpsertCommunityRequest);
      case 'DeleteCommunity': return this.deleteCommunity(ctx, request as $1.DeleteCommunityRequest);
      case 'TogglePaymentStatus': return this.togglePaymentStatus(ctx, request as $1.TogglePaymentStatusRequest);
      case 'GetCollections': return this.getCollections(ctx, request as $1.GetCollectionsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AdminServiceBase$messageJson;
}

