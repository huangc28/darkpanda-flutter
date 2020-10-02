import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';

import './bloc/verify_login_code_bloc.dart';
import './services/auth_api_client.dart';
import './screens/verify_login_code/verify_login_code.dart';
import './screens/send_login_code/auth.dart';
import './screens/register/register.dart';
import './screens/register/screens/phone_verify/phone_verify.dart';
import './screens/register/screens/verify_register_code/verify_register_code.dart';

// import '../../screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
// import '../screens/auth/screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/phone_verify/bloc/send_sms_code_bloc.dart';
import './screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/phone_verify/services/data_provider.dart';

// Each auth route should have it's own navigator unique key
Map<String, GlobalKey<NavigatorState>> authNavKeyMap = {
  '/': GlobalKey<NavigatorState>(),
  '/verify-login-code': GlobalKey<NavigatorState>(),
  '/register': GlobalKey<NavigatorState>(),
  '/register/send-verify-code': GlobalKey<NavigatorState>(),
  '/register/verify-register-code': GlobalKey<NavigatorState>(),
};

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class AuthNavigatorState extends State<AuthNavigator> {
  @override
  String _currentRoute = '/register';

  void _push(BuildContext context, String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _routeBuilder(context, routeName),
      ),
    );

    setState(() {
      _currentRoute = routeName;
    });
  }

  Widget _routeBuilder(BuildContext context, String routeName) {
    final routeMap = {
      '/': (context) => Auth(
            onPush: (String routeName) => _push(context, routeName),
          ),
      '/verify-login-code': (context) => BlocProvider(
            create: (context) => VerifyLoginCodeBloc(
              authAPIClient: AuthAPIClient(),
              userApis: UserApis(),
              authUserBloc: BlocProvider.of<AuthUserBloc>(context),
            ),
            child: VerifyLoginCode(),
          ),
      '/register': (context) => Register(
            onPush: (String routeName) => _push(context, routeName),
          ),
      '/register/send-verify-code': (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MobileVerifyBloc(
                  dataProvider: PhoneVerifyDataProvider(),
                  userApis: UserApis(),
                  authUserBloc: BlocProvider.of<AuthUserBloc>(context),
                ),
              ),
              BlocProvider(
                create: (context) => SendSmsCodeBloc(
                  timerBloc: TimerBloc(
                    ticker: Timer(),
                  ),
                  dataProvider: PhoneVerifyDataProvider(),
                ),
              ),
            ],
            child: RegisterPhoneVerify(
              onPush: (String routeName) => _push(context, routeName),
            ),
          ),
      '/register/verify-register-code': (context) => VerifyRegisterCode(),
    };

    return routeMap[routeName](context);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async =>
            !await authNavKeyMap[_currentRoute].currentState.maybePop(),
        child: Navigator(
          key: authNavKeyMap[_currentRoute],
          initialRoute: _currentRoute,
          onGenerateRoute: (settings) {
            // Generate route according to route name
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => _routeBuilder(context, settings.name),
            );
          },
        ));
  }
}
