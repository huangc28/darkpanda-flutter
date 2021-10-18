import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/main.dart';
import 'package:darkpanda_flutter/components/navigate_to_login.dart';

import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';
import 'package:darkpanda_flutter/util/notification_service.dart';

import './bottom_navigation.dart';
import './tab_navigator.dart';

Map<MaleAppTabItem, GlobalKey<NavigatorState>> _tabGlobalKeyMap = {
  MaleAppTabItem.waitingInquiry: GlobalKey<NavigatorState>(),
  MaleAppTabItem.chat: GlobalKey<NavigatorState>(),
  MaleAppTabItem.manage: GlobalKey<NavigatorState>(),
  MaleAppTabItem.settings: GlobalKey<NavigatorState>(),
  MaleAppTabItem.profile: GlobalKey<NavigatorState>(),
};

class MaleApp extends StatefulWidget {
  const MaleApp({
    Key key,
    this.selectedTab = MaleAppTabItem.waitingInquiry,
  }) : super(key: key);

  final MaleAppTabItem selectedTab;

  @override
  _MaleAppState createState() => _MaleAppState();
}

class _MaleAppState extends State<MaleApp> {
  MaleAppTabItem _currentTab;

  @override
  void initState() {
    super.initState();

    _currentTab = widget.selectedTab;

    NotificationService().init();
    FirebaseMessagingService().init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _tabGlobalKeyMap[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: DarkPandaApp.valueNotifier,
          builder: (context, value, child) {
            // If value is true which mean token is expired
            if (value == true) {
              return NavitgateToLogin();
            }
            return _buildBody();
          },
        ),
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
        _buildOffstageNavigator(MaleAppTabItem.chat),
        _buildOffstageNavigator(MaleAppTabItem.manage),
        _buildOffstageNavigator(MaleAppTabItem.settings),
        _buildOffstageNavigator(MaleAppTabItem.profile),
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
