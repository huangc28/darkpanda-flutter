import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class ServiceDetail extends Equatable {
  ServiceDetail({
    this.uuid,
    this.price,
    this.duration,
    this.appointmentTime,
    this.serviceType,
    this.serviceStatus,
    this.address,
    this.startTime,
    this.endTime,
    this.matchingFee,
  });

  final String uuid;
  final double price;
  final Duration duration;
  final DateTime appointmentTime;
  final String serviceType;
  final String serviceStatus;
  final String address;
  final DateTime startTime;
  final DateTime endTime;
  final double matchingFee;

  @override
  List<Object> get props => [
        uuid,
        price,
        duration,
        appointmentTime,
        serviceType,
        serviceStatus,
        address,
        address,
        startTime,
        endTime,
        matchingFee,
      ];

  @override
  bool get stringify => true;

  ServiceDetail copyWith({
    String uuid,
    double price,
    Duration duration,
    DateTime appointmentTime,
    String serviceType,
    String serviceStatus,
    String address,
    DateTime startTime,
    DateTime endTime,
    double matchingFee,
  }) {
    return ServiceDetail(
      uuid: uuid ?? this.uuid,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      serviceType: serviceType ?? this.serviceType,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      address: address ?? this.address,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      matchingFee: matchingFee ?? this.matchingFee,
    );
  }

  factory ServiceDetail.fromMap(Map<String, dynamic> data) {
    final DateTime at = tryParseToDateTime(data['appointment_time']);
    final DateTime st = tryParseToDateTime(data['start_time']);
    final DateTime et = tryParseToDateTime(data['end_time']);

    return ServiceDetail(
      uuid: data['uuid'] ?? '',
      price: data['price']?.toDouble(),
      duration: Duration(
        minutes: data['duration'] ?? 0,
      ),
      appointmentTime: at,
      serviceType: data['service_type'] ?? '',
      serviceStatus: data['service_status'] ?? '',
      address: data['address'] ?? '',
      startTime: st,
      endTime: et,
      matchingFee: data['matching_fee']?.toDouble(),
    );
  }
}
