import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class InquiryForms extends Equatable {
  InquiryForms({
    this.inquiryDate,
    this.inquiryTime,
    this.budget,
    this.duration,
    this.serviceType,
  });

  DateTime inquiryDate;
  TimeOfDay inquiryTime;
  double budget;
  Duration duration;
  String serviceType;

  @override
  List<Object> get props => [
        // uuid,
        inquiryDate,
        inquiryTime,
        budget,
        duration,
        serviceType,

        // Inquiry date
        inquiryDate.year,
        inquiryDate.month,
        inquiryDate.day,

        // Inquiry time
        inquiryTime.hour,
        inquiryTime.minute,
      ];
}
