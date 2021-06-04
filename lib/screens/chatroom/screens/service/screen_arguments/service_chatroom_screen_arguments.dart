part of '../service_chatroom.dart';

class ServiceChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceUUID;

  ServiceChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.serviceUUID,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(serviceUUID != null);
}
