import './message.dart';

class UpdateInquiryMessage extends Message {
  UpdateInquiryMessage({
    String content,
    String from,
    DateTime createdAt,
    this.price,
    this.duration,
    this.serviceTime,
    this.serviceType,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  final double price;
  final int duration;
  final DateTime serviceTime;
  final String serviceType;

  factory UpdateInquiryMessage.fromMap(Map<String, dynamic> data) {
    return UpdateInquiryMessage(
      serviceType: data['service_type'],
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price'].toDouble() ?? 0,
      duration: data['duration'],
      serviceTime:
          DateTime.fromMicrosecondsSinceEpoch(data['appointment_time']),
    );
  }
}
