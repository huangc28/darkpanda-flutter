import 'package:darkpanda_flutter/screens/profile/screens/routes.dart';
import 'package:darkpanda_flutter/screens/service_list/routes.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/screens/setting/routes.dart';

import 'screens/routes.dart';

import './bottom_navigation.dart';

// Each tag keeps it's own navigator instance to track navigation history.
final Map<MaleAppTabItem, String> _initialRouteMap = {
  MaleAppTabItem.waitingInquiry: SearchInquiryRoutes.root,
  MaleAppTabItem.manage: ServiceChatroomRoutes.root,
  MaleAppTabItem.settings: SettingRoutes.root,
  MaleAppTabItem.profile: ProfileRoutes.root,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({
    @required this.navigatorKey,
    @required this.tabItem,
    @required this.currentTab,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  final MaleAppTabItem tabItem;
  final MaleAppTabItem currentTab;

  final SearchInquiryRoutes _searchInquiryRoutes = SearchInquiryRoutes();
  final ServiceChatroomRoutes _servicesRoutes = ServiceChatroomRoutes();
  final SettingRoutes _settingRoutes = SettingRoutes();
  final ProfileRoutes _profileRoutes = ProfileRoutes();

  Map<String, WidgetBuilder> _getRouteBuildersByTab(
      BuildContext context, MaleAppTabItem tabItem) {
    if (tabItem == MaleAppTabItem.waitingInquiry) {
      return _searchInquiryRoutes.routeBuilder(context);
    }

    if (tabItem == MaleAppTabItem.manage) {
      return _servicesRoutes.routeBuilder(context);
    }

    if (tabItem == MaleAppTabItem.settings) {
      return _settingRoutes.routeBuilder(context);
    }

    if (tabItem == MaleAppTabItem.profile) {
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
      final routeBuilder = _getRouteBuildersByTab(context, tabItem);

      return Navigator(
          key: navigatorKey,
          initialRoute: _initialRouteMap[tabItem],
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
