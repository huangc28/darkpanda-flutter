import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/bloc/inquiries_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/base_routes.dart';

import 'inquiry_chat_list.dart';

class InquiryChatListRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      InquiryChatListRoutes.root: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => InquiriesBloc(
                apiClient: ApiClient(),
              )..add(
                  FetchInquiries(nextPage: 1),
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
