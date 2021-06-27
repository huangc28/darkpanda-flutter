import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/inquiry.dart';

class ServiceSettings extends Equatable {
  ServiceSettings({
    this.uuid,
    this.serviceDate,
    this.serviceTime,
    this.price,
    this.budget,
    this.duration,
    this.serviceType,
    this.address,
  });

  final String uuid;
  final DateTime serviceDate;
  final TimeOfDay serviceTime;
  final double price;
  final double budget;
  final Duration duration;
  final String serviceType;
  final String address;

  @override
  List<Object> get props => [
        uuid,
        serviceDate,
        serviceTime,
        price,
        budget,
        duration,
        serviceType,
        address,

        // Service date
        serviceDate.year,
        serviceDate.month,
        serviceDate.day,

        // Service time
        serviceTime.hour,
        serviceTime.minute,
      ];

  @override
  bool get stringify => true;

  ServiceSettings copyWith({
    String uuid,
    DateTime serviceDate,
    TimeOfDay serviceTime,
    double price,
    double budget,
    Duration duration,
    String serviceType,
    String address,
  }) {
    return ServiceSettings(
      uuid: uuid ?? this.uuid,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceTime: serviceTime ?? this.serviceTime,
      price: price ?? this.price,
      budget: budget ?? this.budget,
      duration: duration ?? this.duration,
      serviceType: serviceType ?? this.serviceType,
      address: address ?? this.address,
    );
  }

  factory ServiceSettings.fromServiceDetailMessage(ServiceDetailMessage msg) =>
      ServiceSettings(
        price: msg.price,
        duration: Duration(minutes: msg.duration),
        serviceDate: msg.serviceTime.toLocal(),
        serviceTime: TimeOfDay.fromDateTime(msg.serviceTime),
        serviceType: msg.serviceType,
      );

  factory ServiceSettings.fromInquiry(Inquiry inquiry) => ServiceSettings(
        uuid: inquiry.uuid,
        serviceType: inquiry.serviceType,
        price: inquiry.price,
        budget: inquiry.budget,
        duration: inquiry.duration,
        serviceDate: inquiry.appointmentTime.toLocal(),
        serviceTime: TimeOfDay.fromDateTime(inquiry.appointmentTime.toLocal()),
        address: inquiry.address,
      );

  factory ServiceSettings.fromMap(Map<String, dynamic> data) {
    final DateTime ap = tryParseToDateTime(data['appointment_time']);
    return ServiceSettings(
      address: data['address'] ?? '',
      uuid: data['uuid'] ?? '',
      serviceType: data['service_type'] ?? '',
      price: data['price']?.toDouble(),
      duration: Duration(
        minutes: data['duration'] ?? 0,
      ),
      serviceDate: ap,
      serviceTime: TimeOfDay.fromDateTime(ap.toLocal()),
    );
  }
}
