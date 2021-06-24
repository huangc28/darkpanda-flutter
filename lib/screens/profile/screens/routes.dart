import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/profile_api_client.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import 'edit_profile/edit_profile.dart';
import 'profile.dart';

class ProfileRoutes extends BaseRoutes {
  static const root = '/';
  static const myProfile = '/my-profile';
  static const editProfile = '/edit-profile';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ProfileRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadUserImagesBloc(
                  userApi: UserApis(),
                ),
              ),
              BlocProvider(
                create: (context) => LoadRateBloc(
                  rateApiClient: RateApiClient(),
                ),
              ),
            ],
            child: Profile(
              loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
              onPush: (String routeName, UserProfile args) =>
                  this.push(context, routeName, args),
            ),
          ),
      ProfileRoutes.editProfile: (context) {
        final screenArgs = args as UserProfile;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UpdateProfileBloc(
                profileApiClient: ProfileApiClient(),
              ),
            ),
          ],
          child: EditProfile(
            args: screenArgs,
          ),
        );
      }
    };
  }
}
