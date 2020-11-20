import 'package:flutter/material.dart';
import 'dart:core';

class ServiceSettings {
  ServiceSettings({
    this.serviceDate,
    this.serviceTime,
    this.price,
    this.duration,
  });

  DateTime serviceDate;
  TimeOfDay serviceTime;
  double price;
  Duration duration;
}
