import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/inquiry_status.dart';

class CreateInquiryResponse extends Equatable {
  const CreateInquiryResponse({
    this.inquiryUuid,
    this.budget,
    this.serviceType,
    this.inquiryStatus,
    this.fcmTopic,
    this.appointmentTime,
  });

  final String inquiryUuid;
  final double budget;
  final String serviceType;
  final InquiryStatus inquiryStatus;
  final String fcmTopic;
  final DateTime appointmentTime;

  factory CreateInquiryResponse.fromMap(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.now();

    if (data['appointment_time'] != null) {
      parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    String iqStatus = data['inquiry_status'] as String;

    return CreateInquiryResponse(
      inquiryUuid: data['inquiry_uuid'],
      budget: data['budget'].toDouble(),
      serviceType: data['service_type'],
      inquiryStatus: iqStatus?.toInquiryStatusEnum(),
      fcmTopic: data['fcm_topic'],
      appointmentTime: parsedAppointmentTime.toLocal(),
    );
  }

  Map<String, dynamic> toMap() => {
        'inquiry_uuid': inquiryUuid,
        'budget': budget,
        'service_type': serviceType,
        'inquiry_status': inquiryStatus,
        'fcm_topic': fcmTopic,
        'appointment_time': appointmentTime,
      };

  @override
  List<Object> get props => [
        inquiryUuid,
        budget,
        serviceType,
        inquiryStatus,
        fcmTopic,
        appointmentTime,
      ];
}
