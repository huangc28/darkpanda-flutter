class Message {
  final String content;

  const Message({
    this.content,
  });

  factory Message.fromMap(Map<String, dynamic> data) => Message(
        content: data['content'] ?? '',
      );
}
