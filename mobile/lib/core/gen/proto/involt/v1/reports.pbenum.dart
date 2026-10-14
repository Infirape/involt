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

class AgingBucket extends $pb.ProtobufEnum {
  static const AgingBucket AGING_BUCKET_UNSPECIFIED = AgingBucket._(0, _omitEnumNames ? '' : 'AGING_BUCKET_UNSPECIFIED');
  static const AgingBucket AGING_BUCKET_CURRENT = AgingBucket._(1, _omitEnumNames ? '' : 'AGING_BUCKET_CURRENT');
  static const AgingBucket AGING_BUCKET_1_30 = AgingBucket._(2, _omitEnumNames ? '' : 'AGING_BUCKET_1_30');
  static const AgingBucket AGING_BUCKET_31_60 = AgingBucket._(3, _omitEnumNames ? '' : 'AGING_BUCKET_31_60');
  static const AgingBucket AGING_BUCKET_61_90 = AgingBucket._(4, _omitEnumNames ? '' : 'AGING_BUCKET_61_90');
  static const AgingBucket AGING_BUCKET_OVER_90 = AgingBucket._(5, _omitEnumNames ? '' : 'AGING_BUCKET_OVER_90');

  static const $core.List<AgingBucket> values = <AgingBucket> [
    AGING_BUCKET_UNSPECIFIED,
    AGING_BUCKET_CURRENT,
    AGING_BUCKET_1_30,
    AGING_BUCKET_31_60,
    AGING_BUCKET_61_90,
    AGING_BUCKET_OVER_90,
  ];

  static final $core.Map<$core.int, AgingBucket> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AgingBucket? valueOf($core.int value) => _byValue[value];

  const AgingBucket._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
