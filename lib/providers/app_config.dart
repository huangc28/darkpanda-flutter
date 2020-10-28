import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/config.dart';

class AppConfigProvider extends InheritedWidget {
  final AppConfig appConfig;

  AppConfigProvider({this.appConfig, Widget child}) : super(child: child);

  static AppConfigProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfigProvider>();
  }

  // @override
  bool updateShouldNotify(AppConfigProvider oldWidget) =>
      oldWidget.appConfig != appConfig;
}
