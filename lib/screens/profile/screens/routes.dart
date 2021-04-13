import 'package:darkpanda_flutter/base_routes.dart';
import 'package:flutter/material.dart';

import 'edit_profile/edit_profile.dart';
import 'profile.dart';

class ProfileRoutes extends BaseRoutes {
  static const root = '/';
  static const myProfile = '/my-profile';
  static const editProfile = '/edit-profile';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ProfileRoutes.root: (context) => Profile(),
      ProfileRoutes.editProfile: (context) => EditProfile(),
    };
  }
}
