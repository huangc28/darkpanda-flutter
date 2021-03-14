import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/send_login_verify_code_bloc.dart';
import './services/login_api_client.dart';
import './screens/login/login.dart';
import './screens/verify_login_pin/verify_login_code.dart';

class LoginNavigator extends StatefulWidget {
  LoginNavigator({Key key}) : super(key: key);

  @override
  LoginNavigatorState createState() => LoginNavigatorState();
}

class LoginNavigatorState extends State<LoginNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Map<String, WidgetBuilder> _routeBuilder() {
    return {
      '/': (context) => BlocProvider(
            create: (context) => SendLoginVerifyCodeBloc(
              authApiClient: LoginAPIClient(),
            ),
            child: Login(),
          ),
      '/login/verify-login-ping': (context) => VerifyLoginCode(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => _routeBuilder()[settings.name](context),
        ),
      ),
    );
  }
}
