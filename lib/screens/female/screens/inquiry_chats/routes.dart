import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/base_routes.dart';

import './chatrooms.dart';

class InquiryChatsRoutes extends BaseRoutes {
  // List of inquiry chats.
  static const root = '/';

  // Specific chatroom.
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      InquiryChatsRoutes.root: (context) {
        // BlocProvider.of<InquiryChatroomsBloc>(context).add(FetchChatrooms());

        // return BlocProvider.value(
        //   value: BlocProvider.of<InquiryChatroomsBloc>(context)
        //     ..add(FetchChatrooms()),
        //   child: ChatRooms(
        //     onPush: (String routeName, [Object args]) => push(
        //       context,
        //       routeName,
        //       args,
        //     ),
        //   ),
        // );

        return BlocProvider<InquiryChatroomsBloc>(
          create: (context) => InquiryChatroomsBloc(
            inquiryChatMesssagesBloc:
                BlocProvider.of<InquiryChatMessagesBloc>(context),
            inquiryChatroomApis: InquiryChatroomApis(),
          )..add(FetchChatrooms()),
          child: ChatRooms(
            onPush: (String routeName, [Object args]) => push(
              context,
              routeName,
              args,
            ),
          ),
        );
      }
    };
  }
}
