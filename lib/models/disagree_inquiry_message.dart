import './message.dart';

class DisagreeInquiryMessage extends Message {
  DisagreeInquiryMessage({
    String content,
    String from,
    DateTime createdAt,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  factory DisagreeInquiryMessage.fromMap(Map<String, dynamic> data) {
    return DisagreeInquiryMessage(
      content: data['content'],
      from: data['from'],
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
