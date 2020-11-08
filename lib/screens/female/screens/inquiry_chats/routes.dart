import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom.dart';

import './chatrooms.dart';
import './screens/chatroom.dart';

class InquiryChatsRoutes extends BaseRoutes {
  // List of inquiry chats.
  static const root = '/';

  // Page of specific chatroom chatroom.
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
      [Map<String, dynamic> args]) {
    return {
      InquiryChatsRoutes.root: (context) => ChatRooms(
            onPush: (String routeName, [Map<String, dynamic> args]) => push(
              context,
              routeName,
              args,
            ),
          ),
      InquiryChatsRoutes.chatroom: (context) => BlocProvider(
            create: (context) => CurrentChatroomBloc(
              inquiryChatroomApis: InquiryChatroomApis(),
            ),
            child: Chatroom(
              channelUUID: args['channel_uuid'],
            ),
          ),
    };
  }
}
