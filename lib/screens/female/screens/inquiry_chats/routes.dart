import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

import './chatrooms.dart';
import './bloc/fetch_chats_bloc.dart';
import './services/inquiry_chats_apis.dart';

class InquiryChatsRoutes extends BaseRoutes {
  // List of inquiry chats.
  static const root = '/';

  // Page of specific chatroom chatroom.
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
      [Map<String, dynamic> args]) {
    return {
      InquiryChatsRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => FetchChatsBloc(
                  inquiryChatsApis: InquiryChatsApis(),
                  inquiryChatroomBloc:
                      BlocProvider.of<InquiryChatroomsBloc>(context),
                )..add(FetchChats()),
              )
            ],
            child: ChatRooms(
              onPush: (String routeName, Map<String, dynamic> args) => push(
                context,
                routeName,
                args,
              ),
            ),
          )
    };
  }
}
