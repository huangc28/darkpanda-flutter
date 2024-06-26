import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/base_routes.dart';

import './chatrooms.dart';

class ChatRoutes extends BaseRoutes {
  static const root = '/';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      ChatRoutes.root: (context) {
        return Chatrooms();
      }
    };
  }
}
