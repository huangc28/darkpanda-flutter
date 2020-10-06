// Each tag keeps it's own navigator instance to track navigation history.
import 'package:flutter/material.dart';

import './bottom_navigation.dart';

import './screens/female/screens/inquiry_list/routes.dart';
import './screens/female/screens/service_list/routes.dart';

class TabServicesNavigatorRoutes {
  static const String root = '/';
}

final Map<TabItem, String> initialRouteMap = {
  TabItem.inquiries: InquiriesRoutes.root,
  TabItem.services: ServiceRoutes.root,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({
    this.navigatorKey,
    this.tabItem,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  final TabItem tabItem;

  final InquiriesRoutes _inquiriesRoutes = InquiriesRoutes();

  final ServiceRoutes _servicesRoutes = ServiceRoutes();

  // Retrieve route builders by current tab item.
  Map<String, WidgetBuilder> _getRouteBuildersByTab(context, TabItem tabItem) {
    if (tabItem == TabItem.inquiries) {
      return _inquiriesRoutes.routeBuilder(context);
    }

    if (tabItem == TabItem.services) {
      return _servicesRoutes.routeBuilder();
    }

    return {
      '/': (context) =>
          Center(child: Text('route builder doesn\'t  exists yet')),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _getRouteBuildersByTab(context, tabItem);

    return Navigator(
      key: navigatorKey,
      initialRoute: initialRouteMap[tabItem],
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => routeBuilders[settings.name](context),
      ),
    );
  }
}
