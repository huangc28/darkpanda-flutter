import './message.dart';

class BotInvitationChatMessage extends Message {
  BotInvitationChatMessage({
    String content,
    String from,
    DateTime createdAt,
    this.counterPartUsername,
    this.inquirerUsername,
    this.pickerUsername,
  }) : super(
          content: content,
          from: from,
          createdAt: createdAt,
        );

  final String counterPartUsername;
  final String inquirerUsername;
  final String pickerUsername;

  factory BotInvitationChatMessage.fromMap(Map<String, dynamic> data) {
    return BotInvitationChatMessage(
      content: data["content"],
      from: data["from"],
      createdAt: data["create_at"],
      counterPartUsername: data["counter_part_username"],
      inquirerUsername: data["inquirer_username"],
      pickerUsername: data["picker_username"],
    );
  }

  @override
  List<Object> get props => [
        content,
        from,
        counterPartUsername,
        inquirerUsername,
        pickerUsername,
      ];
}
