import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/enums/message_types.dart';

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';

class Chatroom extends Equatable {
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
  final String serviceUUID;
  final String pickerUUID;

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
    this.serviceUUID,
    this.pickerUUID,
  });

  factory Chatroom.fromMap(Map<String, dynamic> data) {
    // We need to parse the message and push them into a list.
    // Since we are fetching chatroom list here, each chatroom should
    // only have the latest message in the list or no message
    // at all.
    // TODO: We need to parse message based on message type so that we can compose appropriate content.
    List<Message> messages = [];

    if (data.containsKey('messages')) {
      messages = data['messages'].map<Message>((data) {
        if (data['type'] == MessageType.bot_invitation_chat_text.name) {
          return BotInvitationChatMessage.fromMap(data);
        }
        return Message.fromMap(data);
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
      serviceUUID: data['service_uuid'],
      pickerUUID: data['picker_uuid'],
    );
  }

  @override
  List<Object> get props => [
        serviceType,
        inquiryStatus,
        inquirerUUID,
        inquiryUUID,
        username,
        avatarURL,
        channelUUID,
        expiredAt,
        createdAt,
        messages,
        serviceUUID,
        pickerUUID,
      ];
}
