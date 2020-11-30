import './message.dart';

class ConfirmedServiceMessage extends Message {
  ConfirmedServiceMessage({
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

  factory ConfirmedServiceMessage.fromMap(Map<String, dynamic> data) {
    return ConfirmedServiceMessage(
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
