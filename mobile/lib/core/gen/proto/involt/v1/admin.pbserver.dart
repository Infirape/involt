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

import 'admin.pb.dart' as $2;
import 'admin.pbjson.dart';
import 'payments.pb.dart' as $1;

export 'admin.pb.dart';

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$2.LoginResponse> login($pb.ServerContext ctx, $2.LoginRequest request);
  $async.Future<$2.GetUsersResponse> getUsers($pb.ServerContext ctx, $2.GetUsersRequest request);
  $async.Future<$2.UpsertUserResponse> upsertUser($pb.ServerContext ctx, $2.UpsertUserRequest request);
  $async.Future<$2.GetSectorsResponse> getSectors($pb.ServerContext ctx, $2.GetSectorsRequest request);
  $async.Future<$2.GetCommunitiesResponse> getCommunities($pb.ServerContext ctx, $2.GetCommunitiesRequest request);
  $async.Future<$2.GetCustomersResponse> getCustomers($pb.ServerContext ctx, $2.GetCustomersRequest request);
  $async.Future<$2.GetReadingsResponse> getReadings($pb.ServerContext ctx, $2.GetReadingsRequest request);
  $async.Future<$2.GetSettingsResponse> getSettings($pb.ServerContext ctx, $2.GetSettingsRequest request);
  $async.Future<$2.UpdateSettingsResponse> updateSettings($pb.ServerContext ctx, $2.UpdateSettingsRequest request);
  $async.Future<$2.UpsertCustomerResponse> upsertCustomer($pb.ServerContext ctx, $2.UpsertCustomerRequest request);
  $async.Future<$2.DeleteCustomerResponse> deleteCustomer($pb.ServerContext ctx, $2.DeleteCustomerRequest request);
  $async.Future<$2.GetDashboardStatsResponse> getDashboardStats($pb.ServerContext ctx, $2.GetDashboardStatsRequest request);
  $async.Future<$2.ListPeriodsResponse> listPeriods($pb.ServerContext ctx, $2.ListPeriodsRequest request);
  $async.Future<$2.GetPeriodStatsResponse> getPeriodStats($pb.ServerContext ctx, $2.GetPeriodStatsRequest request);
  $async.Future<$2.OpenPeriodResponse> openPeriod($pb.ServerContext ctx, $2.OpenPeriodRequest request);
  $async.Future<$2.ClosePeriodResponse> closePeriod($pb.ServerContext ctx, $2.ClosePeriodRequest request);
  $async.Future<$2.UpsertSectorResponse> upsertSector($pb.ServerContext ctx, $2.UpsertSectorRequest request);
  $async.Future<$2.DeleteSectorResponse> deleteSector($pb.ServerContext ctx, $2.DeleteSectorRequest request);
  $async.Future<$2.UpsertCommunityResponse> upsertCommunity($pb.ServerContext ctx, $2.UpsertCommunityRequest request);
  $async.Future<$2.DeleteCommunityResponse> deleteCommunity($pb.ServerContext ctx, $2.DeleteCommunityRequest request);
  $async.Future<$2.TogglePaymentStatusResponse> togglePaymentStatus($pb.ServerContext ctx, $2.TogglePaymentStatusRequest request);
  $async.Future<$2.GetCollectionsResponse> getCollections($pb.ServerContext ctx, $2.GetCollectionsRequest request);
  $async.Future<$1.GetCustomerAccountResponse> getCustomerAccount($pb.ServerContext ctx, $1.GetCustomerAccountRequest request);
  $async.Future<$1.RegisterPaymentResponse> registerPayment($pb.ServerContext ctx, $1.RegisterPaymentRequest request);
  $async.Future<$1.VoidPaymentResponse> voidPayment($pb.ServerContext ctx, $1.VoidPaymentRequest request);
  $async.Future<$1.CreateFlatChargeResponse> createFlatCharge($pb.ServerContext ctx, $1.CreateFlatChargeRequest request);
  $async.Future<$1.GetCashClosingResponse> getCashClosing($pb.ServerContext ctx, $1.GetCashClosingRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $2.LoginRequest();
      case 'GetUsers': return $2.GetUsersRequest();
      case 'UpsertUser': return $2.UpsertUserRequest();
      case 'GetSectors': return $2.GetSectorsRequest();
      case 'GetCommunities': return $2.GetCommunitiesRequest();
      case 'GetCustomers': return $2.GetCustomersRequest();
      case 'GetReadings': return $2.GetReadingsRequest();
      case 'GetSettings': return $2.GetSettingsRequest();
      case 'UpdateSettings': return $2.UpdateSettingsRequest();
      case 'UpsertCustomer': return $2.UpsertCustomerRequest();
      case 'DeleteCustomer': return $2.DeleteCustomerRequest();
      case 'GetDashboardStats': return $2.GetDashboardStatsRequest();
      case 'ListPeriods': return $2.ListPeriodsRequest();
      case 'GetPeriodStats': return $2.GetPeriodStatsRequest();
      case 'OpenPeriod': return $2.OpenPeriodRequest();
      case 'ClosePeriod': return $2.ClosePeriodRequest();
      case 'UpsertSector': return $2.UpsertSectorRequest();
      case 'DeleteSector': return $2.DeleteSectorRequest();
      case 'UpsertCommunity': return $2.UpsertCommunityRequest();
      case 'DeleteCommunity': return $2.DeleteCommunityRequest();
      case 'TogglePaymentStatus': return $2.TogglePaymentStatusRequest();
      case 'GetCollections': return $2.GetCollectionsRequest();
      case 'GetCustomerAccount': return $1.GetCustomerAccountRequest();
      case 'RegisterPayment': return $1.RegisterPaymentRequest();
      case 'VoidPayment': return $1.VoidPaymentRequest();
      case 'CreateFlatCharge': return $1.CreateFlatChargeRequest();
      case 'GetCashClosing': return $1.GetCashClosingRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $2.LoginRequest);
      case 'GetUsers': return this.getUsers(ctx, request as $2.GetUsersRequest);
      case 'UpsertUser': return this.upsertUser(ctx, request as $2.UpsertUserRequest);
      case 'GetSectors': return this.getSectors(ctx, request as $2.GetSectorsRequest);
      case 'GetCommunities': return this.getCommunities(ctx, request as $2.GetCommunitiesRequest);
      case 'GetCustomers': return this.getCustomers(ctx, request as $2.GetCustomersRequest);
      case 'GetReadings': return this.getReadings(ctx, request as $2.GetReadingsRequest);
      case 'GetSettings': return this.getSettings(ctx, request as $2.GetSettingsRequest);
      case 'UpdateSettings': return this.updateSettings(ctx, request as $2.UpdateSettingsRequest);
      case 'UpsertCustomer': return this.upsertCustomer(ctx, request as $2.UpsertCustomerRequest);
      case 'DeleteCustomer': return this.deleteCustomer(ctx, request as $2.DeleteCustomerRequest);
      case 'GetDashboardStats': return this.getDashboardStats(ctx, request as $2.GetDashboardStatsRequest);
      case 'ListPeriods': return this.listPeriods(ctx, request as $2.ListPeriodsRequest);
      case 'GetPeriodStats': return this.getPeriodStats(ctx, request as $2.GetPeriodStatsRequest);
      case 'OpenPeriod': return this.openPeriod(ctx, request as $2.OpenPeriodRequest);
      case 'ClosePeriod': return this.closePeriod(ctx, request as $2.ClosePeriodRequest);
      case 'UpsertSector': return this.upsertSector(ctx, request as $2.UpsertSectorRequest);
      case 'DeleteSector': return this.deleteSector(ctx, request as $2.DeleteSectorRequest);
      case 'UpsertCommunity': return this.upsertCommunity(ctx, request as $2.UpsertCommunityRequest);
      case 'DeleteCommunity': return this.deleteCommunity(ctx, request as $2.DeleteCommunityRequest);
      case 'TogglePaymentStatus': return this.togglePaymentStatus(ctx, request as $2.TogglePaymentStatusRequest);
      case 'GetCollections': return this.getCollections(ctx, request as $2.GetCollectionsRequest);
      case 'GetCustomerAccount': return this.getCustomerAccount(ctx, request as $1.GetCustomerAccountRequest);
      case 'RegisterPayment': return this.registerPayment(ctx, request as $1.RegisterPaymentRequest);
      case 'VoidPayment': return this.voidPayment(ctx, request as $1.VoidPaymentRequest);
      case 'CreateFlatCharge': return this.createFlatCharge(ctx, request as $1.CreateFlatChargeRequest);
      case 'GetCashClosing': return this.getCashClosing(ctx, request as $1.GetCashClosingRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AdminServiceBase$messageJson;
}

