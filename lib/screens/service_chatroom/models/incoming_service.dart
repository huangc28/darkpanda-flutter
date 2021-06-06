import 'dart:developer' as developer;

import 'package:darkpanda_flutter/models/message.dart';

class IncomingService {
  IncomingService({
    this.serviceUuid,
    this.serviceStatus,
    this.appointmentTime,
    this.channelUuid,
    this.inquiryUuid,
    this.inquirerUuid,
    this.messages,
    this.chatPartnerAvatarUrl,
    this.chatPartnerUsername,
    this.chatPartnerUserUuid,
    // this.expiredAt,
    // this.createdAt,
  });

  String serviceUuid;
  String serviceStatus;
  DateTime appointmentTime;
  String channelUuid;
  String inquiryUuid;
  String inquirerUuid;
  final List<Message> messages;
  String chatPartnerAvatarUrl;
  String chatPartnerUsername;
  String chatPartnerUserUuid;
  // final DateTime expiredAt;
  // final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'service_uuid': serviceUuid,
        'service_status': serviceStatus,
        'appointment_time': appointmentTime,
        'channel_uuid': channelUuid,
        'inquiry_uuid': inquiryUuid,
        'inquirer_uuid': inquirerUuid,
        'messages': messages,
        'chat_partner_avatar_url': chatPartnerAvatarUrl,
        'chat_partner_username': chatPartnerUsername,
        'chat_partner_user_uuid': chatPartnerUserUuid,
        // 'expired_at': expiredAt,
        // 'created_at': createdAt,
      };

  factory IncomingService.fromMap(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.now();
    List<Message> messages = [];

    if (data.containsKey('messages')) {
      messages = data['messages'].map<Message>((msg) {
        return Message.fromMap(msg);
      }).toList();
    }

    if (data['appointment_time'] != null) {
      parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    return IncomingService(
      serviceUuid: data['service_uuid'],
      serviceStatus: data['service_status'],
      appointmentTime: parsedAppointmentTime,
      channelUuid: data['channel_uuid'],
      inquiryUuid: data['inquiry_uuid'],
      inquirerUuid: data['inquirer_uuid'],
      messages: messages,
      chatPartnerAvatarUrl: data['chat_partner_avatar_url'],
      chatPartnerUsername: data['chat_partner_username'],
      chatPartnerUserUuid: data['chat_partner_user_uuid'],
      // expiredAt: DateTime.parse(data['expired_at']),
      // createdAt: DateTime.parse(data['created_at']),
    );
  }
}

class IncomingServiceList {
  IncomingServiceList({this.services});

  List<IncomingService> services;

  Map<String, dynamic> toJson() => {
        'services': services,
      };

  static IncomingServiceList fromJson(Map<String, dynamic> data) {
    List<IncomingService> serviceList = [];

    if (data['services'] != null) {
      serviceList = data['services'].map<IncomingService>((v) {
        return IncomingService.fromMap(v);
      }).toList();
    }

    return IncomingServiceList(
      services: serviceList,
    );
  }
}
