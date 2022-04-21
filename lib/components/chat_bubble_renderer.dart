import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/enums/gender.dart';

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';
import 'package:darkpanda_flutter/models/payment_completed_message.dart';
import 'package:darkpanda_flutter/models/cancel_service_message.dart';
import 'package:darkpanda_flutter/models/image_message.dart';
import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';

import 'package:darkpanda_flutter/screens/chatroom/components/confirmed_service_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chat_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/update_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/disagree_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/quit_chatroom_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/payment_completed_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/cancel_service_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/image_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/bot_invitation_chat_bubble.dart';

/// ChatroomMessageRendererMixin encapsulate logic that renders different types of message bubble.
/// Chatroom can incorporate this mixin to render message properly.
/// There are 4 types of chatroom in the app that needs to use this class at the moment
///   - Girl's inquiry chatroom
///   - Girl's service chatroom
///   - Boy's inquiry chatroom
///   - Boy's service chatroom
class ChatBubbleRenderer extends StatelessWidget {
  const ChatBubbleRenderer({
    this.message,
    this.isMe,
    this.onTabUpdateInquiryBubble,
    this.onTabImageBubble,
    this.myGender,
    this.avatarURL,
  });

  final Message message;
  final bool isMe;

  final ValueChanged<UpdateInquiryMessage> onTabUpdateInquiryBubble;
  final ValueChanged<ImageMessage> onTabImageBubble;

  /// BotInvitationChatMessage specific.
  final Gender myGender;
  final String avatarURL;

  Widget _renderBubble() {
    switch (message.runtimeType) {
      case ServiceConfirmedMessage:
        return ConfirmedServiceBubble(
          message: message,
          isMe: isMe,
        );

        break;
      case UpdateInquiryMessage:
        return UpdateInquiryBubble(
          message: message,
          isMe: isMe,
          onTapMessage: onTabUpdateInquiryBubble,
        );
      case DisagreeInquiryMessage:
        return DisagreeInquiryBubble(
          isMe: isMe,
          message: message,
        );
      case QuitChatroomMessage:
        return QuitChatroomBubble(
          isMe: isMe,
          message: message,
        );
      case PaymentCompletedMessage:
        return PaymentCompletedBubble(
          isMe: isMe,
          message: message,
        );
      case CancelServiceMessage:
        return CancelServiceBubble(
          isMe: isMe,
          message: message,
        );
      case ImageMessage:
        return ImageBubble(
          isMe: isMe,
          message: message,
          onEnlarge: () => onTabImageBubble(message),
        );
      case BotInvitationChatMessage:
        return BotInvitationChatBubble(
          isMe: isMe,
          myGender: myGender,
          message: message,
          avatarUrl: avatarURL,
        );
      default:
        return ChatBubble(
          message: message,
          isMe: isMe,
          avatarUrl: avatarURL,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _renderBubble();
  }
}
