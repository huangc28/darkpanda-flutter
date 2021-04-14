import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/setting/screens/setting.dart';
import 'package:flutter/material.dart';

class SettingRoutes extends BaseRoutes {
  static const root = '/';
  static const setting = '/setting';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SettingRoutes.root: (context) => Setting(),
      // ProfileRoutes.editProfile: (context) => EditProfile(),
    };
  }
}
