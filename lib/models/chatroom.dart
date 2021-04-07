import 'package:darkpanda_flutter/models/message.dart';

class Chatroom {
  final String serviceType;
  final String inquiryStatus;
  final String inquirerUUID;
  final String inquiryUUID;
  final String username;
  final String avatarURL;
  final String channelUUID;
  final DateTime expiredAt;
  final DateTime createdAt;
  final List<Message> messages;

  const Chatroom({
    this.serviceType,
    this.inquiryStatus,
    this.inquirerUUID,
    this.inquiryUUID,
    this.username,
    this.avatarURL,
    this.channelUUID,
    this.expiredAt,
    this.createdAt,
    this.messages,
  });

  factory Chatroom.fromMap(Map<String, dynamic> data) {
    // We

    return Chatroom(
      serviceType: data['service_type'] ?? '',
      inquiryStatus: data['inquiry_status'] ?? '',
      inquiryUUID: data['inquiry_uuid'] ?? '',
      username: data['username'] ?? '',
      avatarURL: data['avatar_url'] ?? '',
      channelUUID: data['channel_uuid'] ?? '',
      expiredAt: DateTime.parse(data['expired_at']),
      createdAt: DateTime.parse(data['created_at']),
      // messages: data.containsKey('messages')
      //     ? Message.fromMap(data['latest_message'])
      //     : null,
    );
  }
}
