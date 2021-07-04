import './message.dart';

class CancelServiceMessage extends Message {
  CancelServiceMessage({
    String content,
    String from,
    DateTime createdAt,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  factory CancelServiceMessage.fromMap(Map<String, dynamic> data) {
    return CancelServiceMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
