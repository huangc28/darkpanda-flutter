import './message.dart';

class PaymentCompletedMessage extends Message {
  PaymentCompletedMessage({
    String content,
    String from,
    DateTime createdAt,
    this.username,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  String username;

  factory PaymentCompletedMessage.fromMap(Map<String, dynamic> data) {
    return PaymentCompletedMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
      username: data['username'],
    );
  }
}
