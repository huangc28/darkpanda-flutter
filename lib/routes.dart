import 'package:darkpanda_flutter/screens/female/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/male/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/male/screens/chats/screens/direct_chatroom/direct_chatroom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';

import './screens/login/login_navigator.dart';
import './screens/register/auth_navigator.dart';

import 'screens/chatroom/screens/inquiry/chatroom.dart';
import 'screens/chatroom/screens/service/service_chatroom.dart';

import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/inquiry_chatroom.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/screen_arguments/service_chatroom_screen_arguments.dart';

import './screens/female/female_app.dart';
import './screens/male/male_app.dart';

import 'landing.dart';

class MainRoutes extends BaseRoutes {
  static const landing = '/';
  static const login = '/login';
  static const register = '/register';

  ///  App routes to serve female user.
  static const female = '/female';

  /// App routes to serve male user.
  static const male = '/male';

  static const chatroom = '/chatroom';
  static const serviceChatroom = '/service-chatroom';

  static const maleChatroom = '/male-chatroom';

  static const directChatroom = '/direct-chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      MainRoutes.landing: (context) => Landing(args: args),
      MainRoutes.login: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<AuthUserBloc>(context),
          child: LoginNavigator(),
        );
      },
      MainRoutes.register: (context) => AuthNavigator(),
      MainRoutes.female: (context) {
        if (args == null) {
          args = TabItem.inquiries;
          BlocProvider.of<AuthUserBloc>(context).add(
            FetchUserInfo(),
          );
        }

        return FemaleApp(selectedTab: args);
      },
      MainRoutes.male: (context) {
        if (args == null) {
          args = MaleAppTabItem.waitingInquiry;
          BlocProvider.of<AuthUserBloc>(context).add(
            FetchUserInfo(),
          );
        }

        return MaleApp(selectedTab: args);
      },
      MainRoutes.chatroom: (context) {
        final ChatroomScreenArguments chatroomArgs = args;

        return Chatroom(args: chatroomArgs);
      },
      MainRoutes.serviceChatroom: (context) {
        final ServiceChatroomScreenArguments serviceChatroomArgs = args;

        return ServiceChatroom(args: serviceChatroomArgs);
      },
      MainRoutes.maleChatroom: (context) {
        final MaleChatroomScreenArguments maleChatroomArgs = args;

        return InquiryChatroom(args: maleChatroomArgs);
      },
      MainRoutes.directChatroom: (context) {
        final MaleChatroomScreenArguments maleChatroomArgs = args;

        return DirectChatroom(args: maleChatroomArgs);
      }
    };
  }
}
