import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Message {
  final String content;
  final String from;
  final String to;
  final DateTime createdAt;

  const Message({this.content, this.from, this.to, this.createdAt});

  factory Message.fromMap(Map<String, dynamic> data) {
    DateTime createdAt;

    if (data['created_at'] is firestore.Timestamp) {
      createdAt = data['created_at']?.toDate();
    } else if (data['created_at'] is String) {
      createdAt = DateTime.parse(data['created_at']);
    }

    return Message(
      content: data['content'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      createdAt: createdAt,
    );
  }
}
