import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';

import './screens/register/register.dart';
import './screens/register/screens/verify_register_code/verify_register_code.dart';
import './screens/register/screens/verify_register_code/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/verify_register_code/services/apis.dart';
import './screens/register/screens/send_register_verify_code/send_register_verify_code.dart';
import './screens/register/screens/send_register_verify_code/services/data_provider.dart';
import './screens/terms/terms.dart';
import './screens/choose_gender/choose_gender.dart';
import './screens/verify_referral_code/verify_referral_code.dart';
import './screens/verify_referral_code/bloc/verify_referral_code_bloc.dart';

import './screens/register/bloc/send_sms_code_bloc.dart';

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class AuthNavigatorState extends State<AuthNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _push(BuildContext context, String routeName,
      [Map<String, dynamic> args]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _routeBuilder(args)[routeName](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilder([Map<String, dynamic> args]) {
    return {
      '/': (context) => Terms(
            onPush: (String routeName) => _push(context, routeName),
          ),
      '/register/choose-gender': (context) => ChooseGender(
            onPush: (String routeName) => _push(context, routeName),
          ),
      '/register/verify-referral-code': (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => VerifyReferralCodeBloc()),
            ],
            child: VerifyReferralCode(
              onPush: (String routeName) => _push(context, routeName),
            ),
          ),
      '/register/send-verify-code': (context) => SendRegisterVerifyCode(
            onPush: (String routeName, [Map<String, dynamic> args]) =>
                _push(context, routeName, args),
          ),
      '/register': (context) => Register(
            onPush: (String routeName) => _push(context, routeName),
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
          initialRoute: '/register/verify-referral-code',

          /// Generate route according to route name
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (context) => _routeBuilder()[settings.name](context),
          ),
        ),
      ),
    );
  }
}
