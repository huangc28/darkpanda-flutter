import 'package:darkpanda_flutter/enums/inquiry_status.dart';

class ActiveInquiry {
  ActiveInquiry({
    this.uuid,
    this.appointmentTime,
    this.serviceType,
    this.price,
    this.duration,
    this.address,
    this.inquiryStatus,
    this.pickerUuid,
    this.budget,
    this.fcmTopic,
  });

  String uuid;
  String appointmentTime;
  String serviceType;
  double price;
  int duration;
  String address;
  InquiryStatus inquiryStatus;
  String pickerUuid;
  double budget;
  String fcmTopic;

  ActiveInquiry.fromMap(Map<String, dynamic> data)
      : uuid = data['uuid'],
        appointmentTime = data['appointment_time'],
        serviceType = data['service_type'],
        price = data['price']?.toDouble(),
        duration = data['duration'],
        address = data['address'],
        inquiryStatus = data['inquiry_status'].toString().toInquiryStatusEnum(),
        pickerUuid = data['picker_uuid'],
        budget = data['budget']?.toDouble(),
        fcmTopic = data['fcm_topic'];

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'appointment_time': appointmentTime,
        'service_type': serviceType,
        'price': price,
        'duration': duration,
        'address': address,
        'inquiry_status': inquiryStatus,
        'picker_uuid': pickerUuid,
        'budget': budget,
        'fcm_topic': fcmTopic,
      };

  ActiveInquiry copyWith({
    String uuid,
    String serviceType,
    double price,
    Duration duration,
    DateTime appointmentTime,
    InquiryStatus inquiryStatus,
    String address,
    String pickerUuid,
    double budget,
    String fcmTopic,
  }) {
    return ActiveInquiry(
      uuid: uuid ?? this.uuid,
      serviceType: serviceType ?? this.serviceType,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      inquiryStatus: inquiryStatus ?? this.inquiryStatus,
      address: address ?? this.address,
      pickerUuid: pickerUuid ?? this.pickerUuid,
      budget: budget ?? this.budget,
      fcmTopic: fcmTopic ?? this.fcmTopic,
    );
  }
}
