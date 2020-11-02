import 'package:flutter/widgets.dart';

import 'package:darkpanda_flutter/base_routes.dart';

import './services_list.dart';

class ServiceRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
          [Map<String, dynamic> args]) =>
      {
        ServiceRoutes.root: (context) => ServiceList(),
      };
}
