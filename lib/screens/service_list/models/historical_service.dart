import 'dart:developer' as developer;

class HistoricalService {
  HistoricalService({
    this.serviceUuid,
    this.status,
    this.appointmentTime,
    this.channelUuid,
    this.inquiryUuid,
    this.inquirerUuid,
    this.chatPartnerAvatarUrl,
    this.chatPartnerUsername,
    this.chatPartnerUserUuid,
  });

  String serviceUuid;
  String status;
  DateTime appointmentTime;
  String channelUuid;
  String inquiryUuid;

  String inquirerUuid;
  String chatPartnerAvatarUrl;
  String chatPartnerUsername;
  String chatPartnerUserUuid;

  Map<String, dynamic> toMap() => {
        'service_uuid': serviceUuid,
        'status': status,
        'appointment_time': appointmentTime,
        'channel_uuid': channelUuid,
        'inquiry_uuid': inquiryUuid,
        'inquirer_uuid': inquirerUuid,
        'chat_partner_avatar_url': chatPartnerAvatarUrl,
        'chat_partner_username': chatPartnerUsername,
        'chat_partner_user_uuid': chatPartnerUserUuid,
      };

  factory HistoricalService.fromMap(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.now();

    if (data['appointment_time'] != null) {
      parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    return HistoricalService(
      serviceUuid: data['service_uuid'],
      status: data['status'],
      appointmentTime: parsedAppointmentTime.toLocal(),
      channelUuid: data['channel_uuid'],
      inquiryUuid: data['inquiry_uuid'],
      chatPartnerAvatarUrl: data['chat_partner_avatar_url'],
      chatPartnerUsername: data['chat_partner_username'],
      chatPartnerUserUuid: data['chat_partner_user_uuid'],
    );
  }
}

class HistoricalServiceList {
  HistoricalServiceList({this.services});

  List<HistoricalService> services;

  Map<String, dynamic> toJson() => {
        'services': services,
      };

  static HistoricalServiceList fromJson(Map<String, dynamic> data) {
    List<HistoricalService> serviceList = [];

    if (data['services'] != null) {
      serviceList = data['services'].map<HistoricalService>((v) {
        return HistoricalService.fromMap(v);
      }).toList();
    }

    return HistoricalServiceList(
      services: serviceList,
    );
  }
}
