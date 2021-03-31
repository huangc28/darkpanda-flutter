import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

import './inquirer.dart';

class Inquiry extends Equatable {
  final String uuid;
  final double budget;
  final String serviceType;
  final double price;
  final int duration;
  final DateTime appointmentTime;
  final double lng;
  final double lat;
  final Inquirer inquirer;

  const Inquiry({
    this.uuid,
    this.budget,
    this.serviceType,
    this.price,
    this.duration,
    this.appointmentTime,
    this.lng,
    this.lat,
    this.inquirer,
  });

  factory Inquiry.fromJson(Map<String, dynamic> data) {
    var parsedAppointmentTime = DateTime.tryParse(data['appointment_time']);

    // The appointment time may be `null`. If the parsed result is `null`, we use
    // current date as the `appointmentTime` and log the errorneous datetime
    if (parsedAppointmentTime == null) {
      parsedAppointmentTime = DateTime.now();
      developer.log(
        '${data['uuid']}: ${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    return Inquiry(
      uuid: data['uuid'],
      budget: data['budget'].toDouble(),
      serviceType: data['service_type'],
      price: data['price'].toDouble(),
      duration: data['duration'],
      appointmentTime: parsedAppointmentTime,
      lng: data['lng'].toDouble(),
      lat: data['lat'].toDouble(),
      inquirer: Inquirer.fromJson(data['inquirer']),
    );
  }
  @override
  List<Object> get props => [
        uuid,
        budget,
        serviceType,
        price,
        duration,
        appointmentTime,
        lng,
        lat,
      ];
}
