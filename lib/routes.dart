import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/female/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/male/bottom_navigation.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

import './screens/login/login_navigator.dart';
import './screens/register/auth_navigator.dart';

import './contracts/chatroom.dart';
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

  static const femaleInquiryChatroom = '/female-inquiry-chatroom';
  static const maleInquiryChatroom = '/male-inquiry-chatroom';

  static const femaleServiceChatroom = '/female-service-chatroom';
  static const maleServiceChatroom = '/male-service-chatroom';

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
          args = FemaleTabItem.inquiries;
          BlocProvider.of<AuthUserBloc>(context).add(
            FetchUserInfo(),
          );
        }

        BlocProvider.of<InquiryChatroomsBloc>(context)..add(FetchChatrooms());

        return BlocConsumer<InquiryChatroomsBloc, InquiryChatroomsState>(
          listener: (context, state) {
            if (state.status == AsyncLoadingStatus.error) {
              // TODO use i18n for error text
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('failed to fetch chatrooms list'),
                ),
              );
            }
          },
          builder: (context, state) {
            // TODO display a loading icon when fetching inqury chatrooms
            return FemaleApp(selectedTab: args);
          },
        );
      },
      MainRoutes.male: (context) {
        if (args == null) {
          args = MaleAppTabItem.waitingInquiry;
          BlocProvider.of<AuthUserBloc>(context).add(
            FetchUserInfo(),
          );
        }

        BlocProvider.of<InquiryChatroomsBloc>(context)..add(FetchChatrooms());

        return BlocConsumer<InquiryChatroomsBloc, InquiryChatroomsState>(
          listener: (context, state) {
            if (state.status == AsyncLoadingStatus.error) {
              // TODO use i18n for error text
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('failed to fetch chatrooms list'),
                ),
              );
            }
          },
          builder: (context, state) {
            // TODO display a loading icon when fetching inqury chatrooms
            return MaleApp(selectedTab: args);
          },
        );
      },
      MainRoutes.femaleInquiryChatroom: (context) {
        FemaleInquiryChatroomScreenArguments iqArgs = args;
        return FemaleInquiryChatroom(args: iqArgs);
      },
      MainRoutes.maleInquiryChatroom: (context) {
        // Fetch inquiry chatrooms before proceeds
        MaleInquiryChatroomScreenArguments iqArgs = args;
        return MaleInquiryChatroom(args: iqArgs);
      },

      MainRoutes.femaleServiceChatroom: (context) {
        ServiceChatroomScreenArguments chatroomArgs = args;

        return ServiceChatroom(args: chatroomArgs);
      },

      MainRoutes.maleServiceChatroom: (context) {
        ServiceChatroomScreenArguments chatroomArgs = args;

        return ServiceChatroom(args: chatroomArgs);
      },

      //--------------------------- Deprecating ------------------------------
      MainRoutes.maleChatroom: (context) {
        return Container();
        // final MaleChatroomScreenArguments maleChatroomArgs = args;

        // return InquiryChatroom(args: maleChatroomArgs);
      },
      MainRoutes.directChatroom: (context) {
        return Container();
        // final DirectChatroomScreenArguments maleChatroomArgs = args;

        // return DirectChatroom(args: maleChatroomArgs);
      }
    };
  }
}
