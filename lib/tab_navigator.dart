// Each tag keeps it's own navigator instance to track navigation history.
import 'package:flutter/material.dart';

import './bottom_navigation.dart';

import './screens/female/screens/inquiry_list/routes.dart';
import './screens/female/screens/inquiry_chats/routes.dart';
import './screens/female/screens/service_list/routes.dart';

final Map<TabItem, String> initialRouteMap = {
  TabItem.inquiries: InquiriesRoutes.root,
  TabItem.inquiryChats: InquiryChatsRoutes.root,
  TabItem.services: ServiceRoutes.root,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({
    this.navigatorKey,
    this.tabItem,
    this.currentTab,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  final TabItem tabItem;

  final TabItem currentTab;

  final InquiriesRoutes _inquiriesRoutes = InquiriesRoutes();

  final InquiryChatsRoutes _inquiryChatsRoutes = InquiryChatsRoutes();

  final ServiceRoutes _servicesRoutes = ServiceRoutes();

  // Retrieve route builders by current tab item.
  Map<String, WidgetBuilder> _getRouteBuildersByTab(context, TabItem tabItem) {
    if (tabItem == TabItem.inquiries) {
      return _inquiriesRoutes.routeBuilder(context);
    } else if (tabItem == TabItem.inquiryChats) {
      return _inquiryChatsRoutes.routeBuilder(context);
    } else if (tabItem == TabItem.services) {
      return _servicesRoutes.routeBuilder(context);
    }

    return {
      '/': (context) => Center(
            child: Text('route builder doesn\'t  exists'),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (tabItem == currentTab) {
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

    return Container();
  }
}
