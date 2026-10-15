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

/// ConnectionType defines the electrical connection setup.
class ConnectionType extends $pb.ProtobufEnum {
  static const ConnectionType CONNECTION_TYPE_UNSPECIFIED = ConnectionType._(0, _omitEnumNames ? '' : 'CONNECTION_TYPE_UNSPECIFIED');
  static const ConnectionType CONNECTION_TYPE_MONOFASICA = ConnectionType._(1, _omitEnumNames ? '' : 'CONNECTION_TYPE_MONOFASICA');
  static const ConnectionType CONNECTION_TYPE_TRIFASICA = ConnectionType._(2, _omitEnumNames ? '' : 'CONNECTION_TYPE_TRIFASICA');

  static const $core.List<ConnectionType> values = <ConnectionType> [
    CONNECTION_TYPE_UNSPECIFIED,
    CONNECTION_TYPE_MONOFASICA,
    CONNECTION_TYPE_TRIFASICA,
  ];

  static final $core.Map<$core.int, ConnectionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConnectionType? valueOf($core.int value) => _byValue[value];

  const ConnectionType._($core.int v, $core.String n) : super(v, n);
}

/// ServiceStatus is whether a supply currently has electricity (set by admins).
class ServiceStatus extends $pb.ProtobufEnum {
  static const ServiceStatus SERVICE_STATUS_UNSPECIFIED = ServiceStatus._(0, _omitEnumNames ? '' : 'SERVICE_STATUS_UNSPECIFIED');
  static const ServiceStatus SERVICE_STATUS_ACTIVE = ServiceStatus._(1, _omitEnumNames ? '' : 'SERVICE_STATUS_ACTIVE');
  static const ServiceStatus SERVICE_STATUS_TEMPORARY_CUT = ServiceStatus._(2, _omitEnumNames ? '' : 'SERVICE_STATUS_TEMPORARY_CUT');
  static const ServiceStatus SERVICE_STATUS_NO_POWER = ServiceStatus._(3, _omitEnumNames ? '' : 'SERVICE_STATUS_NO_POWER');

  static const $core.List<ServiceStatus> values = <ServiceStatus> [
    SERVICE_STATUS_UNSPECIFIED,
    SERVICE_STATUS_ACTIVE,
    SERVICE_STATUS_TEMPORARY_CUT,
    SERVICE_STATUS_NO_POWER,
  ];

  static final $core.Map<$core.int, ServiceStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ServiceStatus? valueOf($core.int value) => _byValue[value];

  const ServiceStatus._($core.int v, $core.String n) : super(v, n);
}

class PeriodStatus extends $pb.ProtobufEnum {
  static const PeriodStatus PERIOD_STATUS_UNSPECIFIED = PeriodStatus._(0, _omitEnumNames ? '' : 'PERIOD_STATUS_UNSPECIFIED');
  static const PeriodStatus PERIOD_STATUS_OPEN = PeriodStatus._(1, _omitEnumNames ? '' : 'PERIOD_STATUS_OPEN');
  static const PeriodStatus PERIOD_STATUS_CLOSED = PeriodStatus._(2, _omitEnumNames ? '' : 'PERIOD_STATUS_CLOSED');

  static const $core.List<PeriodStatus> values = <PeriodStatus> [
    PERIOD_STATUS_UNSPECIFIED,
    PERIOD_STATUS_OPEN,
    PERIOD_STATUS_CLOSED,
  ];

  static final $core.Map<$core.int, PeriodStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PeriodStatus? valueOf($core.int value) => _byValue[value];

  const PeriodStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
