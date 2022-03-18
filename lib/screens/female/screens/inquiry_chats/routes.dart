import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';

import './chatrooms.dart';

class InquiryChatsRoutes extends BaseRoutes {
  // List of inquiry chats.
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      InquiryChatsRoutes.root: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<InquiryChatroomsBloc>(context)
            ..add(FetchChatrooms()),
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
