import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';

class ServiceSettings {
  ServiceSettings({
    this.serviceDate,
    this.serviceTime,
    this.price,
    this.duration,
    this.serviceType,
    this.uuid,
  });

  String uuid;
  DateTime serviceDate;
  TimeOfDay serviceTime;
  double price;
  Duration duration;
  String serviceType;

  ServiceSettings.fromServiceDetailMessage(ServiceDetailMessage msg)
      : price = msg.price,
        duration = Duration(minutes: msg.duration),
        serviceDate = msg.serviceTime,
        serviceTime = TimeOfDay.fromDateTime(msg.serviceTime),
        serviceType = msg.serviceType;

  factory ServiceSettings.fromMap(Map<String, dynamic> data) {
    final DateTime ap = tryParseToDateTime(data['appointment_time']);

    return ServiceSettings(
      uuid: data['uuid'] ?? '',
      serviceType: data['service_type'] ?? '',
      price: data['price']?.toDouble(),
      duration: Duration(
        minutes: data['duration'] ?? 0,
      ),
      serviceDate: ap,
      serviceTime: TimeOfDay.fromDateTime(ap),
    );
  }
}
