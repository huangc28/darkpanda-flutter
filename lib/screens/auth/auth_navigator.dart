import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';

import './bloc/verify_login_code_bloc.dart';
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
  String _currentRoute = '/';

  void _push(BuildContext context, String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _routeBuilder(context, routeName)),
    );
  }

  Widget _routeBuilder(BuildContext context, String routeName) {
    final routeMap = {
      '/': (context) => Auth(
            onPush: (context, String routeName) => _push(context, routeName),
          ),
      '/verify-login-code': (context) => BlocProvider(
            create: (context) => VerifyLoginCodeBloc(
              authAPIClient: AuthAPIClient(),
              userApis: UserApis(),
              authUserBloc: BlocProvider.of<AuthUserBloc>(context),
            ),
            child: VerifyLoginCode(),
          ),
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
          builder: (context) => _routeBuilder(context, settings.name),
        );
      },
    );
  }
}
