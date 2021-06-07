import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/screens/setting/routes.dart';

import 'screens/search_inquiry/routes.dart';

import './bottom_navigation.dart';

// Each tag keeps it's own navigator instance to track navigation history.
final Map<MaleAppTabItem, String> _initialRouteMap = {
  MaleAppTabItem.waitingInquiry: SearchInquiryRoutes.root,
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
  final SettingRoutes _settingRoutes = SettingRoutes();

  Map<String, WidgetBuilder> _getRouteBuildersByTab(
      BuildContext context, MaleAppTabItem tabItem) {
    if (tabItem == MaleAppTabItem.waitingInquiry) {
      return _searchInquiryRoutes.routeBuilder(context);
    }

    if (tabItem == MaleAppTabItem.settings) {
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
