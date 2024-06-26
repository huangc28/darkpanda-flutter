import 'package:darkpanda_flutter/enums/route_types.dart';

class ServiceChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceUUID;
  final RouteTypes routeTypes;

  ServiceChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.serviceUUID,
    this.routeTypes,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(serviceUUID != null),
        assert(routeTypes != null);
}
