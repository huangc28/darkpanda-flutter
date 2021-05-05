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
    // We need to parse the message and push them into a list.
    // Since we are fetching chatroom list here, each chatroom should
    // only have the latest message in the list or no message
    // at all.

    List<Message> messages = [];

    if (data.containsKey('messages')) {
      messages = data['messages'].map<Message>((msg) {
        return Message.fromMap(msg);
      }).toList();
    }

    return Chatroom(
      serviceType: data['service_type'] ?? '',
      inquiryStatus: data['inquiry_status'] ?? '',
      inquiryUUID: data['inquiry_uuid'] ?? '',
      inquirerUUID: data['inquirer_uuid'] ?? '',
      username: data['username'] ?? '',
      avatarURL: data['avatar_url'] ?? '',
      channelUUID: data['channel_uuid'] ?? '',
      expiredAt: DateTime.parse(data['expired_at']),
      createdAt: DateTime.parse(data['created_at']),
      messages: messages,
    );
  }
}
