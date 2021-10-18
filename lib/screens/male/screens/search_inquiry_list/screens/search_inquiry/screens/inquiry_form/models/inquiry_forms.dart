import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class InquiryForms extends Equatable {
  InquiryForms({
    this.inquiryDate,
    this.inquiryTime,
    this.budget,
    this.duration,
    this.serviceType,
    this.uuid,
    this.address,
  });

  DateTime inquiryDate;
  TimeOfDay inquiryTime;
  double budget;
  Duration duration;
  String serviceType;
  String uuid;
  String address;

  @override
  List<Object> get props => [
        uuid,
        inquiryDate,
        inquiryTime,
        budget,
        duration,
        serviceType,
        address,

        // Inquiry date
        inquiryDate.year,
        inquiryDate.month,
        inquiryDate.day,

        // Inquiry time
        inquiryTime.hour,
        inquiryTime.minute,
      ];
}
