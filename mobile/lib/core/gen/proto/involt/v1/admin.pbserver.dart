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

import 'admin.pb.dart' as $4;
import 'admin.pbjson.dart';
import 'agreements.pb.dart' as $1;
import 'payments.pb.dart' as $2;
import 'reports.pb.dart' as $3;

export 'admin.pb.dart';

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$4.LoginResponse> login($pb.ServerContext ctx, $4.LoginRequest request);
  $async.Future<$4.GetUsersResponse> getUsers($pb.ServerContext ctx, $4.GetUsersRequest request);
  $async.Future<$4.UpsertUserResponse> upsertUser($pb.ServerContext ctx, $4.UpsertUserRequest request);
  $async.Future<$4.GetSectorsResponse> getSectors($pb.ServerContext ctx, $4.GetSectorsRequest request);
  $async.Future<$4.GetCommunitiesResponse> getCommunities($pb.ServerContext ctx, $4.GetCommunitiesRequest request);
  $async.Future<$4.GetCustomersResponse> getCustomers($pb.ServerContext ctx, $4.GetCustomersRequest request);
  $async.Future<$4.GetReadingsResponse> getReadings($pb.ServerContext ctx, $4.GetReadingsRequest request);
  $async.Future<$4.GetSettingsResponse> getSettings($pb.ServerContext ctx, $4.GetSettingsRequest request);
  $async.Future<$4.UpdateSettingsResponse> updateSettings($pb.ServerContext ctx, $4.UpdateSettingsRequest request);
  $async.Future<$4.UpsertCustomerResponse> upsertCustomer($pb.ServerContext ctx, $4.UpsertCustomerRequest request);
  $async.Future<$4.DeleteCustomerResponse> deleteCustomer($pb.ServerContext ctx, $4.DeleteCustomerRequest request);
  $async.Future<$4.GetDashboardStatsResponse> getDashboardStats($pb.ServerContext ctx, $4.GetDashboardStatsRequest request);
  $async.Future<$4.ListPeriodsResponse> listPeriods($pb.ServerContext ctx, $4.ListPeriodsRequest request);
  $async.Future<$4.GetPeriodStatsResponse> getPeriodStats($pb.ServerContext ctx, $4.GetPeriodStatsRequest request);
  $async.Future<$4.OpenPeriodResponse> openPeriod($pb.ServerContext ctx, $4.OpenPeriodRequest request);
  $async.Future<$4.ClosePeriodResponse> closePeriod($pb.ServerContext ctx, $4.ClosePeriodRequest request);
  $async.Future<$4.UpsertSectorResponse> upsertSector($pb.ServerContext ctx, $4.UpsertSectorRequest request);
  $async.Future<$4.DeleteSectorResponse> deleteSector($pb.ServerContext ctx, $4.DeleteSectorRequest request);
  $async.Future<$4.MoveSectorResponse> moveSector($pb.ServerContext ctx, $4.MoveSectorRequest request);
  $async.Future<$4.UpsertCommunityResponse> upsertCommunity($pb.ServerContext ctx, $4.UpsertCommunityRequest request);
  $async.Future<$4.DeleteCommunityResponse> deleteCommunity($pb.ServerContext ctx, $4.DeleteCommunityRequest request);
  $async.Future<$4.TogglePaymentStatusResponse> togglePaymentStatus($pb.ServerContext ctx, $4.TogglePaymentStatusRequest request);
  $async.Future<$4.GetCollectionsResponse> getCollections($pb.ServerContext ctx, $4.GetCollectionsRequest request);
  $async.Future<$2.GetCustomerAccountResponse> getCustomerAccount($pb.ServerContext ctx, $2.GetCustomerAccountRequest request);
  $async.Future<$2.RegisterPaymentResponse> registerPayment($pb.ServerContext ctx, $2.RegisterPaymentRequest request);
  $async.Future<$2.VoidPaymentResponse> voidPayment($pb.ServerContext ctx, $2.VoidPaymentRequest request);
  $async.Future<$2.CreateFlatChargeResponse> createFlatCharge($pb.ServerContext ctx, $2.CreateFlatChargeRequest request);
  $async.Future<$2.GetCashClosingResponse> getCashClosing($pb.ServerContext ctx, $2.GetCashClosingRequest request);
  $async.Future<$3.GetCollectionsDashboardResponse> getCollectionsDashboard($pb.ServerContext ctx, $3.GetCollectionsDashboardRequest request);
  $async.Future<$3.GetDebtorsResponse> getDebtors($pb.ServerContext ctx, $3.GetDebtorsRequest request);
  $async.Future<$1.GetCollectionPolicyResponse> getCollectionPolicy($pb.ServerContext ctx, $1.GetCollectionPolicyRequest request);
  $async.Future<$1.UpdateCollectionPolicyResponse> updateCollectionPolicy($pb.ServerContext ctx, $1.UpdateCollectionPolicyRequest request);
  $async.Future<$1.WaiveLateFeeResponse> waiveLateFee($pb.ServerContext ctx, $1.WaiveLateFeeRequest request);
  $async.Future<$1.PreviewAgreementResponse> previewAgreement($pb.ServerContext ctx, $1.AgreementRequest request);
  $async.Future<$1.CreateAgreementResponse> createAgreement($pb.ServerContext ctx, $1.AgreementRequest request);
  $async.Future<$1.CancelAgreementResponse> cancelAgreement($pb.ServerContext ctx, $1.CancelAgreementRequest request);
  $async.Future<$4.SetCustomerServiceStatusResponse> setCustomerServiceStatus($pb.ServerContext ctx, $4.SetCustomerServiceStatusRequest request);
  $async.Future<$4.GetCustomerStatusHistoryResponse> getCustomerStatusHistory($pb.ServerContext ctx, $4.GetCustomerStatusHistoryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $4.LoginRequest();
      case 'GetUsers': return $4.GetUsersRequest();
      case 'UpsertUser': return $4.UpsertUserRequest();
      case 'GetSectors': return $4.GetSectorsRequest();
      case 'GetCommunities': return $4.GetCommunitiesRequest();
      case 'GetCustomers': return $4.GetCustomersRequest();
      case 'GetReadings': return $4.GetReadingsRequest();
      case 'GetSettings': return $4.GetSettingsRequest();
      case 'UpdateSettings': return $4.UpdateSettingsRequest();
      case 'UpsertCustomer': return $4.UpsertCustomerRequest();
      case 'DeleteCustomer': return $4.DeleteCustomerRequest();
      case 'GetDashboardStats': return $4.GetDashboardStatsRequest();
      case 'ListPeriods': return $4.ListPeriodsRequest();
      case 'GetPeriodStats': return $4.GetPeriodStatsRequest();
      case 'OpenPeriod': return $4.OpenPeriodRequest();
      case 'ClosePeriod': return $4.ClosePeriodRequest();
      case 'UpsertSector': return $4.UpsertSectorRequest();
      case 'DeleteSector': return $4.DeleteSectorRequest();
      case 'MoveSector': return $4.MoveSectorRequest();
      case 'UpsertCommunity': return $4.UpsertCommunityRequest();
      case 'DeleteCommunity': return $4.DeleteCommunityRequest();
      case 'TogglePaymentStatus': return $4.TogglePaymentStatusRequest();
      case 'GetCollections': return $4.GetCollectionsRequest();
      case 'GetCustomerAccount': return $2.GetCustomerAccountRequest();
      case 'RegisterPayment': return $2.RegisterPaymentRequest();
      case 'VoidPayment': return $2.VoidPaymentRequest();
      case 'CreateFlatCharge': return $2.CreateFlatChargeRequest();
      case 'GetCashClosing': return $2.GetCashClosingRequest();
      case 'GetCollectionsDashboard': return $3.GetCollectionsDashboardRequest();
      case 'GetDebtors': return $3.GetDebtorsRequest();
      case 'GetCollectionPolicy': return $1.GetCollectionPolicyRequest();
      case 'UpdateCollectionPolicy': return $1.UpdateCollectionPolicyRequest();
      case 'WaiveLateFee': return $1.WaiveLateFeeRequest();
      case 'PreviewAgreement': return $1.AgreementRequest();
      case 'CreateAgreement': return $1.AgreementRequest();
      case 'CancelAgreement': return $1.CancelAgreementRequest();
      case 'SetCustomerServiceStatus': return $4.SetCustomerServiceStatusRequest();
      case 'GetCustomerStatusHistory': return $4.GetCustomerStatusHistoryRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $4.LoginRequest);
      case 'GetUsers': return this.getUsers(ctx, request as $4.GetUsersRequest);
      case 'UpsertUser': return this.upsertUser(ctx, request as $4.UpsertUserRequest);
      case 'GetSectors': return this.getSectors(ctx, request as $4.GetSectorsRequest);
      case 'GetCommunities': return this.getCommunities(ctx, request as $4.GetCommunitiesRequest);
      case 'GetCustomers': return this.getCustomers(ctx, request as $4.GetCustomersRequest);
      case 'GetReadings': return this.getReadings(ctx, request as $4.GetReadingsRequest);
      case 'GetSettings': return this.getSettings(ctx, request as $4.GetSettingsRequest);
      case 'UpdateSettings': return this.updateSettings(ctx, request as $4.UpdateSettingsRequest);
      case 'UpsertCustomer': return this.upsertCustomer(ctx, request as $4.UpsertCustomerRequest);
      case 'DeleteCustomer': return this.deleteCustomer(ctx, request as $4.DeleteCustomerRequest);
      case 'GetDashboardStats': return this.getDashboardStats(ctx, request as $4.GetDashboardStatsRequest);
      case 'ListPeriods': return this.listPeriods(ctx, request as $4.ListPeriodsRequest);
      case 'GetPeriodStats': return this.getPeriodStats(ctx, request as $4.GetPeriodStatsRequest);
      case 'OpenPeriod': return this.openPeriod(ctx, request as $4.OpenPeriodRequest);
      case 'ClosePeriod': return this.closePeriod(ctx, request as $4.ClosePeriodRequest);
      case 'UpsertSector': return this.upsertSector(ctx, request as $4.UpsertSectorRequest);
      case 'DeleteSector': return this.deleteSector(ctx, request as $4.DeleteSectorRequest);
      case 'MoveSector': return this.moveSector(ctx, request as $4.MoveSectorRequest);
      case 'UpsertCommunity': return this.upsertCommunity(ctx, request as $4.UpsertCommunityRequest);
      case 'DeleteCommunity': return this.deleteCommunity(ctx, request as $4.DeleteCommunityRequest);
      case 'TogglePaymentStatus': return this.togglePaymentStatus(ctx, request as $4.TogglePaymentStatusRequest);
      case 'GetCollections': return this.getCollections(ctx, request as $4.GetCollectionsRequest);
      case 'GetCustomerAccount': return this.getCustomerAccount(ctx, request as $2.GetCustomerAccountRequest);
      case 'RegisterPayment': return this.registerPayment(ctx, request as $2.RegisterPaymentRequest);
      case 'VoidPayment': return this.voidPayment(ctx, request as $2.VoidPaymentRequest);
      case 'CreateFlatCharge': return this.createFlatCharge(ctx, request as $2.CreateFlatChargeRequest);
      case 'GetCashClosing': return this.getCashClosing(ctx, request as $2.GetCashClosingRequest);
      case 'GetCollectionsDashboard': return this.getCollectionsDashboard(ctx, request as $3.GetCollectionsDashboardRequest);
      case 'GetDebtors': return this.getDebtors(ctx, request as $3.GetDebtorsRequest);
      case 'GetCollectionPolicy': return this.getCollectionPolicy(ctx, request as $1.GetCollectionPolicyRequest);
      case 'UpdateCollectionPolicy': return this.updateCollectionPolicy(ctx, request as $1.UpdateCollectionPolicyRequest);
      case 'WaiveLateFee': return this.waiveLateFee(ctx, request as $1.WaiveLateFeeRequest);
      case 'PreviewAgreement': return this.previewAgreement(ctx, request as $1.AgreementRequest);
      case 'CreateAgreement': return this.createAgreement(ctx, request as $1.AgreementRequest);
      case 'CancelAgreement': return this.cancelAgreement(ctx, request as $1.CancelAgreementRequest);
      case 'SetCustomerServiceStatus': return this.setCustomerServiceStatus(ctx, request as $4.SetCustomerServiceStatusRequest);
      case 'GetCustomerStatusHistory': return this.getCustomerStatusHistory(ctx, request as $4.GetCustomerStatusHistoryRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AdminServiceBase$messageJson;
}

