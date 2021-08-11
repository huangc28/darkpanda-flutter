import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import 'inquirer.dart';

class Inquiry extends Equatable {
  final String uuid;
  final double budget;
  final String serviceType;
  final double price;
  final Duration duration;
  final DateTime appointmentTime;
  final double lng;
  final double lat;
  final InquiryStatus inquiryStatus;
  final Inquirer inquirer;
  final String address;
  final String channelUuid;
  final String serviceUuid;

  const Inquiry({
    this.uuid,
    this.budget,
    this.serviceType,
    this.price,
    this.duration,
    this.appointmentTime,
    this.lng,
    this.lat,
    this.inquiryStatus,
    this.inquirer,
    this.address,
    this.channelUuid,
    this.serviceUuid,
  });

  factory Inquiry.fromJson(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.now();

    // The appointment time may be `null`. If the parsed result is `null`, we use
    // current date as the `appointmentTime` and log the errorneous datetime
    if (data['appointment_time'] != null) {
      parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    var parsedDuration = Duration(minutes: 60);

    if (data['duration'] != null) {
      parsedDuration = Duration(minutes: data['duration']);
    } else {
      developer.log(
        '${data['uuid']}: ${data['duration']} can not be parse to Duration object',
        name: 'Failed to parse datetime string to Duration object',
      );
    }

    // Convert the value of `inquiry_status` from enum to string.
    String iqStatus = data['inquiry_status'] as String;

    return Inquiry(
      uuid: data['uuid'],
      budget: data['budget'].toDouble(),
      serviceType: data['service_type'],
      price: data['price'].toDouble(),
      duration: parsedDuration,
      appointmentTime: parsedAppointmentTime.toLocal(),
      lng: data['lng'].toDouble(),
      lat: data['lat'].toDouble(),
      inquiryStatus: iqStatus.toInquiryStatusEnum(),
      inquirer: data.containsKey('inquirer')
          ? Inquirer.fromJson(data['inquirer'])
          : Inquirer(),
      address: data['address'],
      channelUuid: data['channel_uuid'],
      serviceUuid: data['service_uuid'],
    );
  }

  Inquiry copyWith({
    String uuid,
    double budget,
    String serviceType,
    double price,
    Duration duration,
    DateTime appointmentTime,
    double lng,
    double lat,
    InquiryStatus inquiryStatus,
    Inquirer inquirer,
    String address,
    String channelUuid,
    String serviceUUID,
  }) {
    return Inquiry(
      uuid: uuid ?? this.uuid,
      budget: budget ?? this.budget,
      serviceType: serviceType ?? this.serviceType,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      lng: lng ?? this.lng,
      lat: lng ?? this.lat,
      inquiryStatus: inquiryStatus ?? this.inquiryStatus,
      inquirer: inquirer ?? this.inquirer,
      address: address ?? this.address,
      channelUuid: channelUuid ?? this.channelUuid,
      serviceUuid: serviceUUID ?? this.serviceUuid,
    );
  }

  @override
  List<Object> get props => [
        inquiryStatus,
        uuid,
        budget,
        serviceType,
        price,
        duration,
        appointmentTime,
        lng,
        lat,
        address,
        channelUuid,
        serviceUuid,
      ];
}
