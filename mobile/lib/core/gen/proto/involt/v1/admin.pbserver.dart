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

import 'admin.pb.dart' as $3;
import 'admin.pbjson.dart';
import 'payments.pb.dart' as $1;
import 'reports.pb.dart' as $2;

export 'admin.pb.dart';

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$3.LoginResponse> login($pb.ServerContext ctx, $3.LoginRequest request);
  $async.Future<$3.GetUsersResponse> getUsers($pb.ServerContext ctx, $3.GetUsersRequest request);
  $async.Future<$3.UpsertUserResponse> upsertUser($pb.ServerContext ctx, $3.UpsertUserRequest request);
  $async.Future<$3.GetSectorsResponse> getSectors($pb.ServerContext ctx, $3.GetSectorsRequest request);
  $async.Future<$3.GetCommunitiesResponse> getCommunities($pb.ServerContext ctx, $3.GetCommunitiesRequest request);
  $async.Future<$3.GetCustomersResponse> getCustomers($pb.ServerContext ctx, $3.GetCustomersRequest request);
  $async.Future<$3.GetReadingsResponse> getReadings($pb.ServerContext ctx, $3.GetReadingsRequest request);
  $async.Future<$3.GetSettingsResponse> getSettings($pb.ServerContext ctx, $3.GetSettingsRequest request);
  $async.Future<$3.UpdateSettingsResponse> updateSettings($pb.ServerContext ctx, $3.UpdateSettingsRequest request);
  $async.Future<$3.UpsertCustomerResponse> upsertCustomer($pb.ServerContext ctx, $3.UpsertCustomerRequest request);
  $async.Future<$3.DeleteCustomerResponse> deleteCustomer($pb.ServerContext ctx, $3.DeleteCustomerRequest request);
  $async.Future<$3.GetDashboardStatsResponse> getDashboardStats($pb.ServerContext ctx, $3.GetDashboardStatsRequest request);
  $async.Future<$3.ListPeriodsResponse> listPeriods($pb.ServerContext ctx, $3.ListPeriodsRequest request);
  $async.Future<$3.GetPeriodStatsResponse> getPeriodStats($pb.ServerContext ctx, $3.GetPeriodStatsRequest request);
  $async.Future<$3.OpenPeriodResponse> openPeriod($pb.ServerContext ctx, $3.OpenPeriodRequest request);
  $async.Future<$3.ClosePeriodResponse> closePeriod($pb.ServerContext ctx, $3.ClosePeriodRequest request);
  $async.Future<$3.UpsertSectorResponse> upsertSector($pb.ServerContext ctx, $3.UpsertSectorRequest request);
  $async.Future<$3.DeleteSectorResponse> deleteSector($pb.ServerContext ctx, $3.DeleteSectorRequest request);
  $async.Future<$3.UpsertCommunityResponse> upsertCommunity($pb.ServerContext ctx, $3.UpsertCommunityRequest request);
  $async.Future<$3.DeleteCommunityResponse> deleteCommunity($pb.ServerContext ctx, $3.DeleteCommunityRequest request);
  $async.Future<$3.TogglePaymentStatusResponse> togglePaymentStatus($pb.ServerContext ctx, $3.TogglePaymentStatusRequest request);
  $async.Future<$3.GetCollectionsResponse> getCollections($pb.ServerContext ctx, $3.GetCollectionsRequest request);
  $async.Future<$1.GetCustomerAccountResponse> getCustomerAccount($pb.ServerContext ctx, $1.GetCustomerAccountRequest request);
  $async.Future<$1.RegisterPaymentResponse> registerPayment($pb.ServerContext ctx, $1.RegisterPaymentRequest request);
  $async.Future<$1.VoidPaymentResponse> voidPayment($pb.ServerContext ctx, $1.VoidPaymentRequest request);
  $async.Future<$1.CreateFlatChargeResponse> createFlatCharge($pb.ServerContext ctx, $1.CreateFlatChargeRequest request);
  $async.Future<$1.GetCashClosingResponse> getCashClosing($pb.ServerContext ctx, $1.GetCashClosingRequest request);
  $async.Future<$2.GetCollectionsDashboardResponse> getCollectionsDashboard($pb.ServerContext ctx, $2.GetCollectionsDashboardRequest request);
  $async.Future<$2.GetDebtorsResponse> getDebtors($pb.ServerContext ctx, $2.GetDebtorsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $3.LoginRequest();
      case 'GetUsers': return $3.GetUsersRequest();
      case 'UpsertUser': return $3.UpsertUserRequest();
      case 'GetSectors': return $3.GetSectorsRequest();
      case 'GetCommunities': return $3.GetCommunitiesRequest();
      case 'GetCustomers': return $3.GetCustomersRequest();
      case 'GetReadings': return $3.GetReadingsRequest();
      case 'GetSettings': return $3.GetSettingsRequest();
      case 'UpdateSettings': return $3.UpdateSettingsRequest();
      case 'UpsertCustomer': return $3.UpsertCustomerRequest();
      case 'DeleteCustomer': return $3.DeleteCustomerRequest();
      case 'GetDashboardStats': return $3.GetDashboardStatsRequest();
      case 'ListPeriods': return $3.ListPeriodsRequest();
      case 'GetPeriodStats': return $3.GetPeriodStatsRequest();
      case 'OpenPeriod': return $3.OpenPeriodRequest();
      case 'ClosePeriod': return $3.ClosePeriodRequest();
      case 'UpsertSector': return $3.UpsertSectorRequest();
      case 'DeleteSector': return $3.DeleteSectorRequest();
      case 'UpsertCommunity': return $3.UpsertCommunityRequest();
      case 'DeleteCommunity': return $3.DeleteCommunityRequest();
      case 'TogglePaymentStatus': return $3.TogglePaymentStatusRequest();
      case 'GetCollections': return $3.GetCollectionsRequest();
      case 'GetCustomerAccount': return $1.GetCustomerAccountRequest();
      case 'RegisterPayment': return $1.RegisterPaymentRequest();
      case 'VoidPayment': return $1.VoidPaymentRequest();
      case 'CreateFlatCharge': return $1.CreateFlatChargeRequest();
      case 'GetCashClosing': return $1.GetCashClosingRequest();
      case 'GetCollectionsDashboard': return $2.GetCollectionsDashboardRequest();
      case 'GetDebtors': return $2.GetDebtorsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $3.LoginRequest);
      case 'GetUsers': return this.getUsers(ctx, request as $3.GetUsersRequest);
      case 'UpsertUser': return this.upsertUser(ctx, request as $3.UpsertUserRequest);
      case 'GetSectors': return this.getSectors(ctx, request as $3.GetSectorsRequest);
      case 'GetCommunities': return this.getCommunities(ctx, request as $3.GetCommunitiesRequest);
      case 'GetCustomers': return this.getCustomers(ctx, request as $3.GetCustomersRequest);
      case 'GetReadings': return this.getReadings(ctx, request as $3.GetReadingsRequest);
      case 'GetSettings': return this.getSettings(ctx, request as $3.GetSettingsRequest);
      case 'UpdateSettings': return this.updateSettings(ctx, request as $3.UpdateSettingsRequest);
      case 'UpsertCustomer': return this.upsertCustomer(ctx, request as $3.UpsertCustomerRequest);
      case 'DeleteCustomer': return this.deleteCustomer(ctx, request as $3.DeleteCustomerRequest);
      case 'GetDashboardStats': return this.getDashboardStats(ctx, request as $3.GetDashboardStatsRequest);
      case 'ListPeriods': return this.listPeriods(ctx, request as $3.ListPeriodsRequest);
      case 'GetPeriodStats': return this.getPeriodStats(ctx, request as $3.GetPeriodStatsRequest);
      case 'OpenPeriod': return this.openPeriod(ctx, request as $3.OpenPeriodRequest);
      case 'ClosePeriod': return this.closePeriod(ctx, request as $3.ClosePeriodRequest);
      case 'UpsertSector': return this.upsertSector(ctx, request as $3.UpsertSectorRequest);
      case 'DeleteSector': return this.deleteSector(ctx, request as $3.DeleteSectorRequest);
      case 'UpsertCommunity': return this.upsertCommunity(ctx, request as $3.UpsertCommunityRequest);
      case 'DeleteCommunity': return this.deleteCommunity(ctx, request as $3.DeleteCommunityRequest);
      case 'TogglePaymentStatus': return this.togglePaymentStatus(ctx, request as $3.TogglePaymentStatusRequest);
      case 'GetCollections': return this.getCollections(ctx, request as $3.GetCollectionsRequest);
      case 'GetCustomerAccount': return this.getCustomerAccount(ctx, request as $1.GetCustomerAccountRequest);
      case 'RegisterPayment': return this.registerPayment(ctx, request as $1.RegisterPaymentRequest);
      case 'VoidPayment': return this.voidPayment(ctx, request as $1.VoidPaymentRequest);
      case 'CreateFlatCharge': return this.createFlatCharge(ctx, request as $1.CreateFlatChargeRequest);
      case 'GetCashClosing': return this.getCashClosing(ctx, request as $1.GetCashClosingRequest);
      case 'GetCollectionsDashboard': return this.getCollectionsDashboard(ctx, request as $2.GetCollectionsDashboardRequest);
      case 'GetDebtors': return this.getDebtors(ctx, request as $2.GetDebtorsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AdminServiceBase$messageJson;
}

