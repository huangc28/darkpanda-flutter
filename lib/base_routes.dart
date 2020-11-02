import 'package:flutter/material.dart';

abstract class BaseRoutes {
  static const root = '/';

  void push(BuildContext context, String routeName,
      [Map<String, dynamic> args]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilder(context, args)[routeName](context),
      ),
    );
  }

  Map<String, WidgetBuilder> routeBuilder(BuildContext context,
      [Map<String, dynamic> args]);
}
