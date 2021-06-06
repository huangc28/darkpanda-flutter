import 'package:darkpanda_flutter/screens/service_chatroom/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/service_chatroom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/service_chatroom_api.dart';

class ServiceChatroomRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ServiceChatroomRoutes.root: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<LoadIncomingServiceBloc>(context)
            ..add(LoadIncomingService()),
          child: ServiceChatroom(),
        );
      }
    };
  }
}
