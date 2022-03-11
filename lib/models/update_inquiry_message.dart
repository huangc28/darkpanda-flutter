import './message.dart';
import 'dart:developer' as developer;

class UpdateInquiryMessage extends Message {
  UpdateInquiryMessage({
    String content,
    String from,
    DateTime createdAt,
    this.price,
    this.duration,
    this.serviceTime,
    this.serviceType,
    this.address,
    this.matchingFee,
    this.username,
    this.currency,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  double price;
  Duration duration;
  DateTime serviceTime;
  String serviceType;
  String address;
  double matchingFee;
  String username;
  String currency;

  factory UpdateInquiryMessage.fromMap(Map<String, dynamic> data) {
    DateTime parsedStartTime = DateTime.now();

    if (data['appointment_time'] != null) {
      parsedStartTime =
          DateTime.fromMicrosecondsSinceEpoch(data['appointment_time']);
    } else {
      developer.log(
        '${data['appointment_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    return UpdateInquiryMessage(
      serviceType: data['service_type'],
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price']?.toDouble(),
      duration: Duration(
        minutes: data['duration'] ?? 0,
      ),
      serviceTime: parsedStartTime,
      address: data['address'],
      matchingFee: data['matching_fee']?.toDouble(),
      username: data['username'],
      currency: data['currency'],
    );
  }
}
