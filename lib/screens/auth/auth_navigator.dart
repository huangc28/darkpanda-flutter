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
import './screens/register/screens/phone_verify/send_register_verify_code.dart';
import './screens/register/screens/verify_register_code/verify_register_code.dart';

import './screens/register/screens/verify_register_code/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/verify_register_code/services/apis.dart';
import './screens/register/screens/verify_register_code/models/verify_register_code_args.dart';

// import '../screens/auth/screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/phone_verify/bloc/send_sms_code_bloc.dart';
import 'screens/register/screens/verify_register_code/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/phone_verify/services/data_provider.dart';

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class SomeArgs {
  SomeArgs(this.name);

  final String name;
}

class AuthNavigatorState extends State<AuthNavigator> {
  String _currentRoute = '/register';

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _push(BuildContext context, String routeName,
      [Map<String, dynamic> args]) {
    if (routeName == _currentRoute) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _routeBuilder(args)[routeName](context),
      ),
    );

    setState(() {
      _currentRoute = routeName;
    });
  }

  Map<String, WidgetBuilder> _routeBuilder([Map<String, dynamic> args]) {
    return {
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
      '/register/send-verify-code': (context) => SendRegisterVerifyCode(
            onPush: (String routeName, [Map<String, dynamic> args]) =>
                _push(context, routeName, args),
          ),
      '/register/verify-register-code': (context) => BlocProvider(
            create: (context) => MobileVerifyBloc(
              dataProvider: VerifyRegisterCodeAPIs(),
              authUserBloc: BlocProvider.of<AuthUserBloc>(context),
              userApis: UserApis(),
            ),
            child: VerifyRegisterCode(
              countryCode: args['country_code'],
              mobile: args['mobile'],
              verifyChars: args['verify_chars'],
              uuid: args['uuid'],
            ),
          ),
    };
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(
            ticker: Timer(),
          ),
        ),
        BlocProvider(
          create: (context) => SendSmsCodeBloc(
            dataProvider: PhoneVerifyDataProvider(),
            timerBloc: BlocProvider.of<TimerBloc>(context),
          ),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
        child: Navigator(
            key: _navigatorKey,
            initialRoute: _currentRoute,

            /// Generate route according to route name
            onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (context) => _routeBuilder()[settings.name](context),
                )),
      ),
    );
  }
}
