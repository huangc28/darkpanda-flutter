import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';

import './inquiry_list.dart';
import './bloc/inquiries_bloc.dart';
import './services/api_client.dart';
import 'screens/inquirer_profile.dart';

class InquiriesRoutes {
  static const root = '/';
  static const inquirerProfile = '/inquirer-profile';

  void _push(BuildContext context, String routeName,
      [Map<String, dynamic> args]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilder(context, args)[routeName](context),
      ),
    );
  }

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
      [Map<String, dynamic> args]) {
    return {
      InquiriesRoutes.root: (context) => BlocProvider(
            create: (context) => InquiriesBloc(
              apiClient: ApiClient(),
            )..add(FetchInquiries(nextPage: 1)),
            child: InqiuryList(
              onPush: (String routeName, args) =>
                  this._push(context, routeName, args),
            ),
          ),
      InquiriesRoutes.inquirerProfile: (context) => InquirerProfile(
            loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
            uuid: args['uuid'],
          ),
    };
  }
}
