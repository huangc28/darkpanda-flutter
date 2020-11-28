import 'package:darkpanda_flutter/base_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/get_service_bloc.dart';
import 'package:darkpanda_flutter/services/service_apis.dart';

import './screens/auth/auth_navigator.dart';
import './screens/chatroom/chatroom.dart';
import './app.dart';

class MainRoutes extends BaseRoutes {
  static const auth = '/';
  static const app = '/app';
  static const chatroom = '/chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      MainRoutes.auth: (context) => AuthNavigator(),
      MainRoutes.app: (context) => App(),
      MainRoutes.chatroom: (context) {
        final ChatroomScreenArguments chatroomArgs = args;

        return BlocProvider(
          create: (context) => GetServiceBloc(
            serviceApis: ServiceAPIs(),
          ),
          child: Chatroom(args: chatroomArgs),
        );
      }
    };
  }
}
