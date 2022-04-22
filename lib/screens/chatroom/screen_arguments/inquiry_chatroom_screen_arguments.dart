// TODO what the fuck is route types?
import 'package:darkpanda_flutter/enums/route_types.dart';

class InquiryChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceType;
  final RouteTypes routeTypes;
  final String serviceUUID;

  InquiryChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.serviceType,
    this.routeTypes,
    this.serviceUUID,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(serviceType != null),
        assert(routeTypes != null),
        assert(serviceUUID != null);
}
