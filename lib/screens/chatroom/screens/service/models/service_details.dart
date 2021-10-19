import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class ServiceDetails extends Equatable {
  ServiceDetails({
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
    this.createdAt,
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
  final DateTime createdAt;

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
        createdAt
      ];

  @override
  bool get stringify => true;

  ServiceDetails copyWith({
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
    DateTime createdAt,
  }) {
    return ServiceDetails(
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
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ServiceDetails.fromMap(Map<String, dynamic> data) {
    final DateTime at = tryParseToDateTime(data['appointment_time']);
    final DateTime st = tryParseToDateTime(data['start_time']);
    final DateTime et = tryParseToDateTime(data['end_time']);
    final DateTime ct = tryParseToDateTime(data['created_at']);

    return ServiceDetails(
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
      createdAt: ct,
    );
  }
}
