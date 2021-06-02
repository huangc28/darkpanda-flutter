part of '../chatroom.dart';

class ChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String inquirerUUID;
  final String serviceType;
  final bool isInquiry;

  ChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.inquirerUUID,
    this.serviceType,
    this.isInquiry,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(inquirerUUID != null),
        assert(serviceType != null),
        assert(isInquiry != null);
}
