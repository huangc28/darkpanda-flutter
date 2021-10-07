import 'dart:developer' as developer;

class FemaleUser {
  FemaleUser({
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

  factory FemaleUser.fromMap(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.now();

    if (data['appointment_time'] != null) {
      parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    return FemaleUser(
      serviceUuid: data['service_uuid'],
      status: data['status'],
      appointmentTime: parsedAppointmentTime.toLocal(),
      channelUuid: data['channel_uuid'],
      inquiryUuid: data['inquiry_uuid'],
      inquirerUuid: data['inquirer_uuid'],
      chatPartnerAvatarUrl: data['chat_partner_avatar_url'],
      chatPartnerUsername: data['chat_partner_username'],
      chatPartnerUserUuid: data['chat_partner_user_uuid'],
    );
  }

  FemaleUser copyWith({
    String serviceUuid,
    String status,
    DateTime appointmentTime,
    String channelUuid,
    String inquiryUuid,
    String inquirerUuid,
    String chatPartnerAvatarUrl,
    String chatPartnerUsername,
    String chatPartnerUserUuid,
  }) {
    return FemaleUser(
      serviceUuid: serviceUuid ?? this.serviceUuid,
      status: status ?? this.status,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      channelUuid: channelUuid ?? this.channelUuid,
      inquiryUuid: inquiryUuid ?? this.inquiryUuid,
      inquirerUuid: inquirerUuid ?? this.inquirerUuid,
      chatPartnerAvatarUrl: chatPartnerAvatarUrl ?? this.chatPartnerAvatarUrl,
      chatPartnerUsername: chatPartnerUsername ?? this.chatPartnerUsername,
      chatPartnerUserUuid: chatPartnerUserUuid ?? this.chatPartnerUserUuid,
    );
  }
}

class FemaleUserList {
  FemaleUserList({this.femaleUsers});

  List<FemaleUser> femaleUsers;

  Map<String, dynamic> toJson() => {
        'services': femaleUsers,
      };

  static FemaleUserList fromJson(Map<String, dynamic> data) {
    List<FemaleUser> serviceList = [];

    if (data['services'] != null) {
      serviceList = data['services'].map<FemaleUser>((v) {
        return FemaleUser.fromMap(v);
      }).toList();
    }

    return FemaleUserList(
      femaleUsers: serviceList,
    );
  }
}
