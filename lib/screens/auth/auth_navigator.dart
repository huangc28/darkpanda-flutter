import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';

import './screens/register/screens/verify_register_code/verify_register_code.dart';
import './screens/register/screens/verify_register_code/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/verify_register_code/services/apis.dart';

import './screens/send_register_verify_code/send_register_verify_code.dart';

import './screens/register/screens/send_register_verify_code/services/data_provider.dart';
import './screens/terms/terms.dart';
import './screens/choose_gender/choose_gender.dart';
import './screens/verify_referral_code/verify_referral_code.dart';
import './screens/verify_referral_code/bloc/verify_referral_code_bloc.dart';

import './screens/register/bloc/send_sms_code_bloc.dart';
import './screens/register/bloc/register_bloc.dart';
import './screens/register/services/register_api_client.dart';

import './screen_arguments/args.dart';

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class AuthNavigatorState extends State<AuthNavigator> {
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
      '/': (context) => Terms(
            onPush: (String routeName) => _push(context, routeName),
          ),
      '/register/choose-gender': (context) => ChooseGender(
            onPush: (String routeName, VerifyReferralCodeArguments args) =>
                _push(context, routeName, args),
          ),
      '/register/verify-referral-code': (context) {
        var screenArgs = args as VerifyReferralCodeArguments;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => VerifyReferralCodeBloc(),
            ),
            BlocProvider(
              create: (context) => RegisterBloc(
                registerAPI: RegisterAPIClient(),
              ),
            ),
          ],
          child: VerifyReferralCode(
            onPush: (String routeName,
                    [SendRegisterVerifyCodeArguments args]) =>
                _push(context, routeName, args),
            args: screenArgs,
          ),
        );
      },
      '/register/send-verify-code': (context) {
        var screenArgs = args as SendRegisterVerifyCodeArguments;

        return BlocProvider(
          create: (context) => SendSmsCodeBloc(
            dataProvider: PhoneVerifyDataProvider(),
            timerBloc: BlocProvider.of<TimerBloc>(context),
          ),
          child: SendRegisterVerifyCode(
            onPush: (String routeName, [VerifyRegisterCodeArguments args]) =>
                _push(context, routeName, args),
            args: screenArgs,
          ),
        );
      },
      '/register/verify-register-code': (context) {
        var screenArgs = args as VerifyRegisterCodeArguments;

        return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MobileVerifyBloc(
                  dataProvider: VerifyRegisterCodeAPIs(),
                  authUserBloc: BlocProvider.of<AuthUserBloc>(context),
                  userApis: UserApis(),
                ),
              ),
              BlocProvider(
                create: (context) => SendSmsCodeBloc(
                  dataProvider: PhoneVerifyDataProvider(),
                  timerBloc: BlocProvider.of<TimerBloc>(context),
                ),
              ),
            ],
            child: VerifyRegisterCode(
              args: screenArgs,
            ));
      },
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
          // initialRoute: '/register/send-verify-code',
          initialRoute: '/',

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
