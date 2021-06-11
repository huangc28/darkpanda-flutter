import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/inquiry_chat_messages_bloc.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/load_incoming_service_bloc.dart';
import './bloc/load_historical_service_bloc.dart';
import 'service_list.dart';
import './services/service_chatroom_api.dart';

class ServiceChatroomRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ServiceChatroomRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadIncomingServiceBloc(
                    apiClient: ServiceChatroomClient(),
                    inquiryChatMesssagesBloc: InquiryChatMessagesBloc()),
              ),
              BlocProvider(
                create: (context) => LoadHistoricalServiceBloc(
                    apiClient: ServiceChatroomClient()),
              ),
            ],
            child: ServiceList(),
          )
    };
  }
}
