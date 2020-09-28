import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/send_login_verify_code_bloc.dart';
import './services/auth_api_client.dart';
import './auth.dart';
import './screens/verify_login_code.dart';

// Each auth route should have it's own navigator unique key
Map<String, GlobalKey<NavigatorState>> authNavKeyMap = {
  '/': GlobalKey<NavigatorState>(),
};

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class AuthNavigatorState extends State<AuthNavigator> {
  @override
  String _currentRoute = '/verify-login-code';

  void _push(BuildContext context, String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _routeBuilder(context, routeName)),
    );
  }

  Widget _routeBuilder(BuildContext context, String routeName) {
    final routeMap = {
      '/': (context) =>
          Auth(onPush: (String routeName) => _push(context, routeName)),
      '/verify-login-code': (context) => VerifyLoginCode(),
    };
    return routeMap[routeName](context);
  }

  Widget build(BuildContext context) {
    return Navigator(
      key: authNavKeyMap[_currentRoute],
      initialRoute: _currentRoute,
      onGenerateRoute: (settings) {
        // Generate route according to route name
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider(
                create: (context) => SendLoginVerifyCodeBloc(
                  authApiClient: AuthAPIClient(),
                ),
                child: _routeBuilder(context, settings.name),
              );
            });
      },
    );
  }
}
