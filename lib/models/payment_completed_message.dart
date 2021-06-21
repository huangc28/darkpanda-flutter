import './message.dart';

class PaymentCompletedMessage extends Message {
  PaymentCompletedMessage({
    String content,
    String from,
    DateTime createdAt,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  factory PaymentCompletedMessage.fromMap(Map<String, dynamic> data) {
    return PaymentCompletedMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
