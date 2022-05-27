import 'package:flutter/material.dart';

import './bottom_navigation.dart';

import './screens/inquiry_list/routes.dart';

import '../profile/screens/routes.dart';
import '../setting/routes.dart';
import '../service_list/routes.dart';
import 'screens/inquiry_chat_list/routes.dart';

// Each tag keeps it's own navigator instance to track navigation history.
final Map<FemaleTabItem, String> initialRouteMap = {
  FemaleTabItem.inquiries: InquiriesRoutes.root,
  FemaleTabItem.inquiryChats: InquiryChatListRoutes.root,
  FemaleTabItem.manage: ServiceChatroomRoutes.root,
  FemaleTabItem.settings: SettingRoutes.root,
  FemaleTabItem.profile: ProfileRoutes.root,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({
    this.navigatorKey,
    this.tabItem,
    this.currentTab,
  });

  /// Navigator key that holds female app routing history.
  final GlobalKey<NavigatorState> navigatorKey;

  final FemaleTabItem tabItem;
  final FemaleTabItem currentTab;

  final InquiriesRoutes _inquiriesRoutes = InquiriesRoutes();
  final InquiryChatListRoutes _inquiryChatsRoutes = InquiryChatListRoutes();
  final ServiceChatroomRoutes _servicesRoutes = ServiceChatroomRoutes();
  final ProfileRoutes _profileRoutes = ProfileRoutes();
  final SettingRoutes _settingRoutes = SettingRoutes();

  // Retrieve route builders by current tab item.
  Map<String, WidgetBuilder> _getRouteBuildersByTab(
      context, FemaleTabItem tabItem) {
    if (tabItem == FemaleTabItem.inquiries) {
      return _inquiriesRoutes.routeBuilder(context);
    } else if (tabItem == FemaleTabItem.inquiryChats) {
      return _inquiryChatsRoutes.routeBuilder(context);
    } else if (tabItem == FemaleTabItem.manage) {
      return _servicesRoutes.routeBuilder(context);
    } else if (tabItem == FemaleTabItem.profile) {
      return _profileRoutes.routeBuilder(context);
    } else if (tabItem == FemaleTabItem.settings) {
      return _settingRoutes.routeBuilder(context);
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
      final routeBuilder = _getRouteBuildersByTab(context, tabItem);

      return Navigator(
          key: navigatorKey,
          initialRoute: initialRouteMap[tabItem],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => routeBuilder[settings.name](context),
            );
          });
    }

    return Container();
  }
}
