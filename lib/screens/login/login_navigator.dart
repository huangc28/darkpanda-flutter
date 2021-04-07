import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';

import './bloc/send_login_verify_code_bloc.dart';
import './bloc/verify_login_code_bloc.dart';
import './services/login_api_client.dart';
import './screens/login/login.dart';
import './screens/verify_login_pin/verify_login_code.dart';
import './screen_arguments/args.dart';

class LoginNavigator extends StatefulWidget {
  LoginNavigator({Key key}) : super(key: key);

  @override
  LoginNavigatorState createState() => LoginNavigatorState();
}

class LoginNavigatorState extends State<LoginNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _push(BuildContext context, String routeName, [Object args]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _routeBuilder(args)[routeName](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilder([Object args]) {
    return {
      '/': (context) => Login(
            onPush: (String routeName, VerifyLoginPinArguments args) =>
                _push(context, routeName, args),
          ),
      '/login/verify-login-ping': (context) {
        final screenArgs = args as VerifyLoginPinArguments;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => VerifyLoginCodeBloc(
                loginAPIClient: LoginAPIClient(),
                userApis: UserApis(),
                authUserBloc: BlocProvider.of<AuthUserBloc>(context),
              ),
            ),
          ],
          child: VerifyLoginCode(
            args: screenArgs,
          ),
        );
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TimerBloc(ticker: Timer()),
          ),
          BlocProvider(
            create: (context) => SendLoginVerifyCodeBloc(
              authApiClient: LoginAPIClient(),
              timerBloc: BlocProvider.of<TimerBloc>(context),
            ),
          )
        ],
        child: WillPopScope(
          onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: settings,
              builder: (context) => _routeBuilder()[settings.name](context),
            ),
          ),
        ));
  }
}
