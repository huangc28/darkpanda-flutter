import './message.dart';

class ServiceDetailMessage extends Message {
  ServiceDetailMessage({
    String content,
    String from,
    String to,
    DateTime createdAt,
    this.price,
    this.duration,
    this.serviceTime,
    this.serviceType,
    this.address,
  }) : super(
          content: content,
          from: from,
          to: to,
          createdAt: createdAt,
        );

  final double price;
  final int duration;
  final DateTime serviceTime;
  final String serviceType;
  final String address;

  factory ServiceDetailMessage.fromMap(Map<String, dynamic> data) {
    return ServiceDetailMessage(
      serviceType: data['service_type'],
      content: data['content'],
      from: data['from'],
      to: data['to'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price'].toDouble() ?? 0,
      duration: data['duration'],
      serviceTime: DateTime.fromMicrosecondsSinceEpoch(data['service_time']),
    );
  }
}
