import './message.dart';

class BotInvitationChatMessage extends Message {
  BotInvitationChatMessage({
    String content,
    String from,
    DateTime createdAt,
    this.counterPartUsername,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  final String counterPartUsername;

  factory BotInvitationChatMessage.fromMap(Map<String, dynamic> data) {
    return BotInvitationChatMessage(
      content: data["content"],
      from: data["from"],
      createdAt: data["create_at"],
      counterPartUsername: data["counter_part_username"],
    );
  }

  @override
  List<Object> get props => [
        content,
        from,
        counterPartUsername,
      ];
}
