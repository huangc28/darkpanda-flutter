part of '../chatroom.dart';

class ChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String serviceType;
  final UserProfile inquirerProfile;

  ChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.serviceType,
    this.inquirerProfile,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(serviceType != null),
        assert(inquirerProfile != null);
}
