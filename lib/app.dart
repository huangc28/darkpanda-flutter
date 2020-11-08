// App is a stateful widget that contains an app scaffold that holds an bottom navigation bar.
// Each navigation tab holds it's own [Navigator] class. It holds the navigation history
// of that tab.
import 'package:flutter/material.dart';

import './bottom_navigation.dart';
import './tab_navigator.dart';

Map<TabItem, GlobalKey<NavigatorState>> tabGlobalKeyMap = {
  TabItem.inquiries: GlobalKey<NavigatorState>(),
  TabItem.inquiryChats: GlobalKey<NavigatorState>(),
  TabItem.services: GlobalKey<NavigatorState>(),
  TabItem.profile: GlobalKey<NavigatorState>(),
};

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

// @TODO
// We need to check if user has logged in or not.
// If user has not logged in, we need to navigate user
// to perform login / registration process before proceeding
class _AppState extends State<App> {
  TabItem _currentTab = TabItem.inquiryChats;
  // TabItem _currentTab = TabItem.inquiries;

  @override
  Widget build(BuildContext context) {
    print('DEBUG trigger app rebuild');

    return WillPopScope(
      onWillPop: () async =>
          !await tabGlobalKeyMap[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _handleSelectTab,
        ),
        // bottomNavigationBar: null,
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildOffstageNavigator(TabItem.inquiries),
        _buildOffstageNavigator(TabItem.inquiryChats),
        _buildOffstageNavigator(TabItem.services),
      ],
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: tabGlobalKeyMap[tabItem],
        tabItem: tabItem,
        currentTab: _currentTab,
      ),
    );
  }

  void _handleSelectTab(TabItem item) {
    setState(() {
      if (_currentTab != item) {
        _currentTab = item;
      } else {
        tabGlobalKeyMap[_currentTab]
            .currentState
            .popUntil((route) => route.isFirst);
      }
    });
  }
}
