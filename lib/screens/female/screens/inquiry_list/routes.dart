import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/private_chats_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';

import './inquiry_list.dart';
import './bloc/inquiries_bloc.dart';
import './bloc/pickup_inquiry_bloc.dart';
import './bloc/picked_inquiries_dart_bloc.dart';
import './services/api_client.dart';
import './screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import './screens/inquirer_profile/inquirer_profile.dart';
import '../inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';

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
      InquiriesRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => InquiriesBloc(
                  apiClient: ApiClient(),
                )..add(FetchInquiries(nextPage: 1)),
              ),
              BlocProvider(
                create: (context) => PickupInquiryBloc(
                  apiClient: ApiClient(),
                  pickedInquiriesBloc:
                      BlocProvider.of<PickedInquiriesDartBloc>(context),
                ),
              ),
            ],
            child: InqiuryList(
              onPush: (String routeName, args) =>
                  this._push(context, routeName, args),
            ),
          ),
      InquiriesRoutes.inquirerProfile: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadUserImagesBloc(
                  userApi: UserApis(),
                ),
              ),
              BlocProvider(
                create: (context) => LoadHistoricalServicesBloc(
                  userApi: UserApis(),
                ),
              ),
            ],
            child: InquirerProfile(
              loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
              uuid: args['uuid'],
            ),
          )
    };
  }
}
