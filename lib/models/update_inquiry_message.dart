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
    this.address,
    this.matchingFee,
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
  int matchingFee;

  factory UpdateInquiryMessage.fromMap(Map<String, dynamic> data) {
    return UpdateInquiryMessage(
      serviceType: data['service_type'],
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price']?.toDouble(),
      duration: Duration(
        minutes: data['duration'] ?? 0,
      ),
      serviceTime:
          DateTime.fromMicrosecondsSinceEpoch(data['appointment_time']),
      address: data['address'],
      matchingFee: data['matching_fee'],
    );
  }
}
