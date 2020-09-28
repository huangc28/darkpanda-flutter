// Each tag keeps it's own navigator instance to track navigation history.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bottom_navigation.dart';
import './screens/female/screens/inquiry_list/inquiry_list.dart';
import './screens/female/screens/service_list/services_list.dart';
import './screens/female/screens/inquiry_list/bloc/inquiries_bloc.dart';
import './screens/female/screens/inquiry_list/services/api_client.dart';

class TabInquiriesNavigatorRoutes {
  static const String root = '/';
}

class TabServicesNavigatorRoutes {
  static const String root = '/';
}

final Map<TabItem, String> initialRouteMap = {
  TabItem.inquiries: TabInquiriesNavigatorRoutes.root,
  TabItem.services: TabServicesNavigatorRoutes.root,
};

class TabNavigator extends StatelessWidget {
  TabNavigator({
    this.navigatorKey,
    this.tabItem,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  final TabItem tabItem;

  final InquiriesBloc inquiriesBloc = InquiriesBloc(apiClient: ApiClient());

  // Retrieve route builders by current tab item.
  Map<String, WidgetBuilder> _getRouteBuildersByTab(TabItem tabItem) {
    if (tabItem == TabItem.inquiries) {
      return _inquiriesRouteBuilders();
    }

    if (tabItem == TabItem.services) {
      return _servicesRouteBuilders();
    }

    return {
      '/': (context) => Center(child: Text('route builder not exists yet')),
    };
  }

  Map<String, WidgetBuilder> _inquiriesRouteBuilders() {
    return {
      TabInquiriesNavigatorRoutes.root: (context) => InqiuryList(),
    };
  }

  Map<String, WidgetBuilder> _servicesRouteBuilders() {
    return {
      TabServicesNavigatorRoutes.root: (context) => ServiceList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _getRouteBuildersByTab(tabItem);

    return Navigator(
      key: navigatorKey,
      initialRoute: initialRouteMap[tabItem],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) => InquiriesBloc(apiClient: ApiClient())
                ..add(FetchInquiries(nextPage: 1)),
              child: routeBuilders[settings.name](context),
            );
          },
        );
      },
    );
  }
}
