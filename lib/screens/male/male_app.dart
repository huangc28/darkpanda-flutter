import 'package:flutter/material.dart';

import './bottom_navigation.dart';
import './tab_navigator.dart';

Map<MaleAppTabItem, GlobalKey<NavigatorState>> _tabGlobalKeyMap = {
  MaleAppTabItem.waitingInquiry: GlobalKey<NavigatorState>(),
  MaleAppTabItem.manage: GlobalKey<NavigatorState>(),
  MaleAppTabItem.settings: GlobalKey<NavigatorState>(),
  MaleAppTabItem.profile: GlobalKey<NavigatorState>(),
};

class MaleApp extends StatefulWidget {
  const MaleApp({Key key}) : super(key: key);

  @override
  _MaleAppState createState() => _MaleAppState();
}

class _MaleAppState extends State<MaleApp> {
  MaleAppTabItem _currentTab = MaleAppTabItem.waitingInquiry;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _tabGlobalKeyMap[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _handleSelectTab,
        ),
      ),
    );
  }

  _handleSelectTab(MaleAppTabItem item) {
    setState(
      () {
        if (_currentTab != item) {
          _currentTab = item;
        } else {
          _tabGlobalKeyMap[_currentTab]
              .currentState
              .popUntil((route) => route.isFirst);
        }
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildOffstageNavigator(MaleAppTabItem.waitingInquiry),
      ],
    );
  }

  Widget _buildOffstageNavigator(MaleAppTabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _tabGlobalKeyMap[tabItem],
        tabItem: tabItem,
        currentTab: _currentTab,
      ),
    );
  }
}
