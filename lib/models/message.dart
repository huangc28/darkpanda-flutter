import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class Message extends Equatable {
  Message({
    this.content,
    this.from,
    this.to,
    this.createdAt,
    this.isRead,
  });

  final String content;
  final String from;
  final String to;
  final DateTime createdAt;
  bool isRead;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
            content: data['content'] ?? '',
            from: data['from'] ?? '',
            to: data['to'] ?? '',
            createdAt: Message.fieldToDateTime(data['created_at']),
            isRead: data['is_read']) ??
        true;
  }

  @override
  List<Object> get props => [
        content,
        from,
        to,
        createdAt,
        isRead,
      ];
}
