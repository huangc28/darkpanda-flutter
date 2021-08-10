part of '../chatroom.dart';

class ChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceType;
  final RouteTypes routeTypes;
  final String serviceUUID;

  ChatroomScreenArguments({
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
