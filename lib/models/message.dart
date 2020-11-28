import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class Message {
  Message({
    this.content,
    this.from,
    this.to,
    this.createdAt,
  });

  String content;
  final String from;
  final String to;
  final DateTime createdAt;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      content: data['content'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      createdAt: Message.fieldToDateTime(data['created_at']),
    );
  }
}
