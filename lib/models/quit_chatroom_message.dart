import './message.dart';

class QuitChatroomMessage extends Message {
  QuitChatroomMessage({
    String content,
    String from,
    DateTime createdAt,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  factory QuitChatroomMessage.fromMap(Map<String, dynamic> data) {
    return QuitChatroomMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
