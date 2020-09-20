import 'package:equatable/equatable.dart';

import './inquirer.dart';

class Inquiry extends Equatable {
  final String uuid;
  final double budget;
  final String serviceType;
  final double price;
  final int duration;
  final String appointmentTime;
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

  factory Inquiry.fromJson(Map<String, dynamic> data) => Inquiry(
        uuid: data['uuid'],
        budget: data['budget'].toDouble(),
        serviceType: data['service_type'],
        price: data['price'].toDouble(),
        duration: data['duration'],
        appointmentTime: data['appoinment_time'],
        lng: data['lng'].toDouble(),
        lat: data['lat'].toDouble(),
        inquirer: Inquirer.fromJson(data['inquirer']),
      );

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
