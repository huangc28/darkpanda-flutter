import 'package:darkpanda_flutter/screens/register/screens/send_register_email/send_register_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';

import './screens/verify_register_code/verify_register_code.dart';

import './screens/verify_register_code/bloc/mobile_verify_bloc.dart';
import './screens/verify_register_code/services/apis.dart';

import './screens/send_register_verify_code/send_register_verify_code.dart';
import './screens/send_register_verify_code/services/data_provider.dart';

import './screens/terms/terms.dart';
import './screens/choose_gender/choose_gender.dart';
import './screens/verify_referral_code/verify_referral_code.dart';
import './screens/verify_referral_code/bloc/verify_referral_code_bloc.dart';

import './bloc/send_sms_code_bloc.dart';
import './bloc/register_bloc.dart';
import './services/register_api_client.dart';

import './screen_arguments/args.dart';
import 'screens/send_register_email/bloc/send_register_email_bloc.dart';
import 'screens/send_register_email/services/send_register_api_client.dart';

class AuthNavigator extends StatefulWidget {
  AuthNavigator();

  @override
  AuthNavigatorState createState() => AuthNavigatorState();
}

class AuthNavigatorState extends State<AuthNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static const root = '/';
  static const chooseGender = '/register/choose-gender';
  static const verifyReferralCode = '/register/verify-referral-code';
  static const sendVerifyCode = '/register/send-verify-code';
  static const sendRegisterEmail = '/register/send-register-email';
  static const verifyRegisterCode = '/register/verify-register-code';

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
      root: (context) => Terms(
            onPush: (String routeName) => _push(context, routeName),
          ),
      chooseGender: (context) => ChooseGender(
            onPush: (String routeName, VerifyReferralCodeArguments args) =>
                _push(context, routeName, args),
          ),
      verifyReferralCode: (context) {
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
      sendVerifyCode: (context) {
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
      sendRegisterEmail: (context) {
        // var screenArgs = args as SendRegisterVerifyCodeArguments;

        return BlocProvider(
          create: (context) => SendRegisterEmailBloc(
            sendRegisterApiClient: SendRegisterApiClient(),
            timerBloc: BlocProvider.of<TimerBloc>(context),
          ),
          child: SendRegisterEmail(
              // onPush: (String routeName, [VerifyRegisterCodeArguments args]) =>
              //     _push(context, routeName, args),
              // args: screenArgs,
              ),
        );
      },
      verifyRegisterCode: (context) {
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
