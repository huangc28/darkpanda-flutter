import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:darkpanda_flutter/base_routes.dart';

import './chatrooms.dart';

class InquiryChatsRoutes extends BaseRoutes {
  // List of inquiry chats.
  static const root = '/';

  // Specific chatroom.
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      InquiryChatsRoutes.root: (context) => ChatRooms(
            onPush: (String routeName, [Object args]) => push(
              context,
              routeName,
              args,
            ),
          ),
    };
  }
}
