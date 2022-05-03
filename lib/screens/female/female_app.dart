// FemaleApp is a stateful widget that contains an app scaffold that holds an bottom navigation bar.
// Each navigation tab holds it's own [Navigator] class. It holds the navigation history
// of that tab.

import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/main.dart';
import 'package:darkpanda_flutter/components/navigate_to_login.dart';
import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';
import 'package:darkpanda_flutter/util/notification_service.dart';

import './bottom_navigation.dart';
import './tab_navigator.dart';

final Map<FemaleTabItem, GlobalKey<NavigatorState>> tabGlobalKeyMap = {
  FemaleTabItem.inquiries: GlobalKey<NavigatorState>(),
  FemaleTabItem.inquiryChats: GlobalKey<NavigatorState>(),
  FemaleTabItem.manage: GlobalKey<NavigatorState>(),
  FemaleTabItem.profile: GlobalKey<NavigatorState>(),
  FemaleTabItem.settings: GlobalKey<NavigatorState>(),
};

class FemaleApp extends StatefulWidget {
  const FemaleApp({
    Key key,
    this.selectedTab = FemaleTabItem.inquiries,
  }) : super(key: key);

  final FemaleTabItem selectedTab;

  @override
  _FemaleAppState createState() => _FemaleAppState();
}

// @TODO:
//   - We need to check if user has logged in or not.
//   - If user has not logged in, we need to navigate user
//   - To perform login / registration process before proceeding
class _FemaleAppState extends State<FemaleApp> {
  FemaleTabItem _currentTab;

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
          !await tabGlobalKeyMap[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: DarkPandaApp.valueNotifier,
          builder: (context, value, child) {
            // If value is true which means the token is expired
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

  Widget _buildBody() {
    return Stack(
      children: [
        _buildOffstageNavigator(FemaleTabItem.inquiries),
        _buildOffstageNavigator(FemaleTabItem.inquiryChats),
        _buildOffstageNavigator(FemaleTabItem.manage),
        _buildOffstageNavigator(FemaleTabItem.settings),
        _buildOffstageNavigator(FemaleTabItem.profile),
      ],
    );
  }

  Widget _buildOffstageNavigator(FemaleTabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: tabGlobalKeyMap[tabItem],
        tabItem: tabItem,
        currentTab: _currentTab,
      ),
    );
  }

  void _handleSelectTab(FemaleTabItem item) {
    setState(
      () {
        if (_currentTab != item) {
          _currentTab = item;
        } else {
          tabGlobalKeyMap[_currentTab]
              .currentState
              .popUntil((route) => route.isFirst);
        }
      },
    );
  }
}
