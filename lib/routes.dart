import 'package:darkpanda_flutter/base_routes.dart';
import 'package:flutter/widgets.dart';

import './screens/auth/auth_navigator.dart';
import './screens/chatroom/chatroom.dart';
import './app.dart';

class MainRoutes extends BaseRoutes {
  static const auth = '/';
  static const login = '/login';
  static const app = '/app';
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      MainRoutes.auth: (context) => AuthNavigator(),
      MainRoutes.app: (context) => App(),
      MainRoutes.chatroom: (context) {
        final ChatroomScreenArguments chatroomArgs = args;

        return Chatroom(args: chatroomArgs);
      }
    };
  }
}
