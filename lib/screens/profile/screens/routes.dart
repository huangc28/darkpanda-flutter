import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/profile/screens/profile.dart';
import 'package:flutter/material.dart';

class ProfileRoutes extends BaseRoutes {
  static const root = '/';
  static const myProfile = '/my-profile';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
          [Object args]) =>
      {
        ProfileRoutes.root: (context) => Profile(),
      };
}
