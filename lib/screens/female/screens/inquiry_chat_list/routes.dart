import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/base_routes.dart';

import 'inquiry_chat_list.dart';
import 'screens/direct_inquiry_request/bloc/load_direct_inquiry_request_bloc.dart';
import 'services/inquiry_chat_list_api_client.dart';

class InquiryChatListRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      InquiryChatListRoutes.root: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadDirectInquiryRequestBloc(
                inquiryChatListApiClient: InquiryChatListApiClient(),
              )..add(
                  FetchDirectInquiries(nextPage: 1),
                ),
            ),
          ],
          child: InquiryChatList(
              // onPush: (String routeName, InquirerProfileArguments args) =>
              //     this.push(context, routeName, args),
              ),
        );
      },
    };
  }
}
