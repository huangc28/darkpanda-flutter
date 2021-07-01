import './message.dart';

class StartServiceMessage extends Message {
  StartServiceMessage({
    String content,
    String from,
    DateTime createdAt,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  factory StartServiceMessage.fromMap(Map<String, dynamic> data) {
    return StartServiceMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
