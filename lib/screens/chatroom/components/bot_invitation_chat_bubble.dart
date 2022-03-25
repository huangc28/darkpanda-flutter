import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';
import 'package:darkpanda_flutter/models/message.dart';
import './chat_bubble.dart';

class BotInvitationChatBubble extends StatelessWidget {
  const BotInvitationChatBubble({
    this.isMe = false,
    this.myGender = Gender.female,
    this.message,
  });

  final bool isMe;
  final Gender myGender;
  final BotInvitationChatMessage message;

  @override
  Widget build(BuildContext context) {
    // Check gender, if I am male, i'm talking to a picker
    // if I am female, i'm talking to an inquirer

    return ChatBubble(
      message: Message(
        content: AppLocalizations.of(context).botInvitationToChatContent(
          myGender == Gender.female
              ? message.inquirerUsername
              : message.pickerUsername,
        ),
        from: message.from,
        to: message.to,
        createdAt: message.createdAt,
      ),
      isMe: isMe,
    );
  }
}
