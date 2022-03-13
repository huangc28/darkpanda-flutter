import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';
import 'package:darkpanda_flutter/models/message.dart';
import './chat_bubble.dart';

class BotInvitationChatBubble extends StatelessWidget {
  const BotInvitationChatBubble({
    this.isMe = false,
    this.message,
  });

  final bool isMe;
  final BotInvitationChatMessage message;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      message: Message(
        content: AppLocalizations.of(context)
            .botInvitationToChatContent(message.counterPartUsername),
        from: message.from,
        to: message.to,
        createdAt: message.createdAt,
      ),
      isMe: isMe,
    );
  }
}
