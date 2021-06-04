part of '../chatroom.dart';

class ChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceType;

  ChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.serviceType,
    // this.serviceUUID,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(serviceType != null);
  // assert(serviceUUID != null);
}
