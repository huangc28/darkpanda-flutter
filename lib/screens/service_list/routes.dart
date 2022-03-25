import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/load_historical_service_bloc.dart';
import 'bloc/load_incoming_service_bloc.dart';
import 'service_list.dart';
import './services/service_chatroom_api.dart';

class ServiceChatroomRoutes extends BaseRoutes {
  static const root = '/';

  ///  Redirect user to service chatroom routeBuilder. This route will reuse the routes
  ///  from service chatroom routeBuilder domain.
  static const serviceChatroom = '/service_chatroom';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ServiceChatroomRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: BlocProvider.of<LoadIncomingServiceBloc>(context)
                  ..add(
                    LoadIncomingService(),
                  ),
              ),
              BlocProvider(
                create: (context) => LoadHistoricalServiceBloc(
                  apiClient: ServiceChatroomClient(),
                ),
              ),
            ],
            child: ServiceList(
              onPush: (String routeName) => this.push(context, routeName),
            ),
          ),
    };
  }
}
