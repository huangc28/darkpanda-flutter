import './message.dart';

class ServiceConfirmedMessage extends Message {
  ServiceConfirmedMessage({
    String content,
    String from,
    String to,
    DateTime createdAt,
    this.price,
    this.duration,
    this.serviceTime,
    this.serviceType,
    this.username,
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
  final String username;

  factory ServiceConfirmedMessage.fromMap(Map<String, dynamic> data) {
    return ServiceConfirmedMessage(
      serviceType: data['service_type'],
      content: data['content'],
      from: data['from'],
      to: data['to'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      price: data['price'].toDouble() ?? 0,
      duration: data['duration'],
      serviceTime: DateTime.fromMicrosecondsSinceEpoch(data['service_time']),
      username: data['username'],
    );
  }
}
