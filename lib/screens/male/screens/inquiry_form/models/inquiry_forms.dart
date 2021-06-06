import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class InquiryForms extends Equatable {
  InquiryForms({
    // this.uuid,
    this.inquiryDate,
    this.inquiryTime,
    this.budget,
    this.duration,
    this.serviceType,
  });

  // String uuid;
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

  // Map<String, dynamic> toJson() => {
  //       'card_number': cardNumber,
  //       'name': name,
  //       'month': month,
  //       'year': year,
  //       'cvv': cvv,
  //       'prime': prime,
  //       'package_id': packageId,
  //     };
}
