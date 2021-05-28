part of '../chatroom.dart';

class ChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String serviceType;
  final UserProfile inquirerProfile;
  final bool isInquiry;

  ChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.serviceType,
    this.inquirerProfile,
    this.isInquiry,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(serviceType != null),
        assert(inquirerProfile != null),
        assert(isInquiry != null);
}
