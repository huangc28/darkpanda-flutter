import 'package:darkpanda_flutter/enums/route_types.dart';

class DirectChatroomScreenArguments {
  // Chatroom relative data
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final RouteTypes routeTypes;
  final String serviceUUID;

  DirectChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.routeTypes,
    this.serviceUUID,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(routeTypes != null),
        assert(serviceUUID != null);
}
