import 'package:flutter/widgets.dart';

import './services_list.dart';

class ServiceRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder() => {
        ServiceRoutes.root: (context) => ServiceList(),
      };
}
