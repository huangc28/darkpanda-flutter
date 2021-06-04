import 'package:darkpanda_flutter/base_routes.dart';

import 'package:flutter/widgets.dart';

import './screens/login/login_navigator.dart';
import './screens/register/auth_navigator.dart';
import 'screens/chatroom/screens/inquiry/chatroom.dart';
import 'screens/chatroom/screens/service/service_chatroom.dart';
import './app.dart';

class MainRoutes extends BaseRoutes {
  static const login = '/';
  static const register = '/register';
  static const app = '/app';
  static const chatroom = '/chatroom';
  static const serviceChatroom = '/service-chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      MainRoutes.login: (context) => LoginNavigator(),
      MainRoutes.register: (context) => AuthNavigator(),
      MainRoutes.app: (context) => App(),
      MainRoutes.chatroom: (context) {
        final ChatroomScreenArguments chatroomArgs = args;

        return Chatroom(args: chatroomArgs);
      },
      MainRoutes.serviceChatroom: (context) {
        final ServiceChatroomScreenArguments serviceChatroomArgs = args;

        return ServiceChatroom(args: serviceChatroomArgs);
      }
    };
  }
}
