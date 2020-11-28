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

  factory ServiceDetailMessage.fromMap(Map<String, dynamic> data) {
    return ServiceDetailMessage(
      content: data['content'],
      from: data['from'],
      to: data['to'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price'] ?? 0,
      duration: data['duration'],
      serviceTime: DateTime.fromMicrosecondsSinceEpoch(data['service_time']),
    );
    // serviceTime: Message.fieldToDateTime(data['service_time']));
  }
}
