import 'package:darkpanda_flutter/screens/profile/screens/routes.dart';
import 'package:flutter/material.dart';

import './bottom_navigation.dart';

import './screens/female/screens/inquiry_list/routes.dart';
import './screens/female/screens/inquiry_chats/routes.dart';
import './screens/female/screens/service_list/routes.dart';

// Each tag keeps it's own navigator instance to track navigation history.
final Map<TabItem, String> initialRouteMap = {
  TabItem.inquiries: InquiriesRoutes.root,
  TabItem.inquiryChats: InquiryChatsRoutes.root,
  TabItem.manage: ServiceRoutes.root,
  TabItem.profile: ProfileRoutes.root,
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

  final ProfileRoutes _profileRoutes = ProfileRoutes();

  // Retrieve route builders by current tab item.
  Map<String, WidgetBuilder> _getRouteBuildersByTab(context, TabItem tabItem) {
    if (tabItem == TabItem.inquiries) {
      return _inquiriesRoutes.routeBuilder(context);
    } else if (tabItem == TabItem.inquiryChats) {
      return _inquiryChatsRoutes.routeBuilder(context);
    } else if (tabItem == TabItem.manage) {
      return _servicesRoutes.routeBuilder(context);
    } else if (tabItem == TabItem.profile) {
      return _profileRoutes.routeBuilder(context);
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
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => routeBuilders[settings.name](context),
            );
          });
    }

    return Container();
  }
}
