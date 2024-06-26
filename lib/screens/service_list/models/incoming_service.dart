import 'dart:developer' as developer;
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/message.dart';

class IncomingService extends Equatable {
  const IncomingService({
    this.serviceUuid,
    this.status,
    this.appointmentTime,
    this.channelUuid,
    this.inquiryUuid,
    this.inquirerUuid,
    this.messages,
    this.chatPartnerAvatarUrl,
    this.chatPartnerUsername,
    this.chatPartnerUserUuid,
  });

  final String serviceUuid;
  final String status;
  final DateTime appointmentTime;
  final String channelUuid;
  final String inquiryUuid;
  final String inquirerUuid;
  final List<Message> messages;
  final String chatPartnerAvatarUrl;
  final String chatPartnerUsername;
  final String chatPartnerUserUuid;

  @override
  List<Object> get props => [
        this.serviceUuid,
        this.status,
        this.appointmentTime,
        this.channelUuid,
        this.inquiryUuid,
        this.inquirerUuid,
        this.messages,
        this.chatPartnerAvatarUrl,
        this.chatPartnerUsername,
        this.chatPartnerUserUuid,
      ];

  Map<String, dynamic> toMap() => {
        'service_uuid': serviceUuid,
        'status': status,
        'appointment_time': appointmentTime,
        'channel_uuid': channelUuid,
        'inquiry_uuid': inquiryUuid,
        'inquirer_uuid': inquirerUuid,
        'messages': messages,
        'chat_partner_avatar_url': chatPartnerAvatarUrl,
        'chat_partner_username': chatPartnerUsername,
        'chat_partner_user_uuid': chatPartnerUserUuid,
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
      status: data['status'],
      appointmentTime: parsedAppointmentTime.toLocal(),
      channelUuid: data['channel_uuid'],
      inquiryUuid: data['inquiry_uuid'],
      inquirerUuid: data['inquirer_uuid'],
      messages: messages,
      chatPartnerAvatarUrl: data['chat_partner_avatar_url'],
      chatPartnerUsername: data['chat_partner_username'],
      chatPartnerUserUuid: data['chat_partner_user_uuid'],
    );
  }

  IncomingService copyWith({
    String serviceUuid,
    String status,
    DateTime appointmentTime,
    String channelUuid,
    String inquiryUuid,
    String inquirerUuid,
    final List<Message> messages,
    String chatPartnerAvatarUrl,
    String chatPartnerUsername,
    String chatPartnerUserUuid,
  }) {
    return IncomingService(
      serviceUuid: serviceUuid ?? this.serviceUuid,
      status: status ?? this.status,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      channelUuid: channelUuid ?? this.channelUuid,
      inquiryUuid: inquiryUuid ?? this.inquiryUuid,
      inquirerUuid: inquirerUuid ?? this.inquirerUuid,
      messages: messages ?? this.messages,
      chatPartnerAvatarUrl: chatPartnerAvatarUrl ?? this.chatPartnerAvatarUrl,
      chatPartnerUsername: chatPartnerUsername ?? this.chatPartnerUsername,
      chatPartnerUserUuid: chatPartnerUserUuid ?? this.chatPartnerUserUuid,
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
