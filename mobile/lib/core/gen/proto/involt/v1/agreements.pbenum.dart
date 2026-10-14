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

import 'package:protobuf/protobuf.dart' as $pb;

class LateFeeMode extends $pb.ProtobufEnum {
  static const LateFeeMode LATE_FEE_MODE_UNSPECIFIED = LateFeeMode._(0, _omitEnumNames ? '' : 'LATE_FEE_MODE_UNSPECIFIED');
  static const LateFeeMode LATE_FEE_MODE_NONE = LateFeeMode._(1, _omitEnumNames ? '' : 'LATE_FEE_MODE_NONE');
  static const LateFeeMode LATE_FEE_MODE_FIXED = LateFeeMode._(2, _omitEnumNames ? '' : 'LATE_FEE_MODE_FIXED');
  static const LateFeeMode LATE_FEE_MODE_PERCENT = LateFeeMode._(3, _omitEnumNames ? '' : 'LATE_FEE_MODE_PERCENT');
  static const LateFeeMode LATE_FEE_MODE_MONTHLY_INTEREST = LateFeeMode._(4, _omitEnumNames ? '' : 'LATE_FEE_MODE_MONTHLY_INTEREST');

  static const $core.List<LateFeeMode> values = <LateFeeMode> [
    LATE_FEE_MODE_UNSPECIFIED,
    LATE_FEE_MODE_NONE,
    LATE_FEE_MODE_FIXED,
    LATE_FEE_MODE_PERCENT,
    LATE_FEE_MODE_MONTHLY_INTEREST,
  ];

  static final $core.Map<$core.int, LateFeeMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LateFeeMode? valueOf($core.int value) => _byValue[value];

  const LateFeeMode._($core.int v, $core.String n) : super(v, n);
}

class AgreementStatus extends $pb.ProtobufEnum {
  static const AgreementStatus AGREEMENT_STATUS_UNSPECIFIED = AgreementStatus._(0, _omitEnumNames ? '' : 'AGREEMENT_STATUS_UNSPECIFIED');
  static const AgreementStatus AGREEMENT_STATUS_ACTIVE = AgreementStatus._(1, _omitEnumNames ? '' : 'AGREEMENT_STATUS_ACTIVE');
  static const AgreementStatus AGREEMENT_STATUS_IN_DEFAULT = AgreementStatus._(2, _omitEnumNames ? '' : 'AGREEMENT_STATUS_IN_DEFAULT');
  static const AgreementStatus AGREEMENT_STATUS_COMPLETED = AgreementStatus._(3, _omitEnumNames ? '' : 'AGREEMENT_STATUS_COMPLETED');
  static const AgreementStatus AGREEMENT_STATUS_CANCELLED = AgreementStatus._(4, _omitEnumNames ? '' : 'AGREEMENT_STATUS_CANCELLED');

  static const $core.List<AgreementStatus> values = <AgreementStatus> [
    AGREEMENT_STATUS_UNSPECIFIED,
    AGREEMENT_STATUS_ACTIVE,
    AGREEMENT_STATUS_IN_DEFAULT,
    AGREEMENT_STATUS_COMPLETED,
    AGREEMENT_STATUS_CANCELLED,
  ];

  static final $core.Map<$core.int, AgreementStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AgreementStatus? valueOf($core.int value) => _byValue[value];

  const AgreementStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
