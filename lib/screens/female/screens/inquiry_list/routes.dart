import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

import './inquiry_list.dart';
import './bloc/inquiries_bloc.dart';
import './bloc/pickup_inquiry_bloc.dart';
import './services/api_client.dart';
import './screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import './screens/inquirer_profile/inquirer_profile.dart';
import '../inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';

class InquiriesRoutes extends BaseRoutes {
  static const root = '/';
  static const inquirerProfile = '/inquirer-profile';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
      [Map<String, dynamic> args]) {
    return {
      InquiriesRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => InquiriesBloc(
                  apiClient: ApiClient(),
                )..add(
                    FetchInquiries(nextPage: 1),
                  ),
              ),
              BlocProvider(
                create: (context) => PickupInquiryBloc(
                  apiClient: ApiClient(),
                  inquiriesBloc: BlocProvider.of<InquiriesBloc>(context),
                ),
              ),
            ],
            child: InqiuryList(
              onPush: (String routeName, args) =>
                  this.push(context, routeName, args),
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
