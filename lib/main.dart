import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/repository.dart';

import './screens/login/login.dart';
import './screens/register/register.dart' as RegisterScreen;
import './screens/register/screens/phone_verify/phone_verify.dart';
import './screens/register/screens/data_provider.dart';

import './screens/bloc/auth_user_bloc.dart';
import './screens/register/screens/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/bloc/send_sms_code_bloc.dart';
import './screens/bloc/timer_bloc.dart';

import './screens/pkg/timer.dart';

void main() => runApp(DarkPandaApp());

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc(RegisterRepository())),
        BlocProvider(create: (context) => AuthUserBloc()),
        BlocProvider(create: (context) => TimerBloc(ticker: Timer())),
      ],
      child: MaterialApp(
        initialRoute: '/register',
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => RegisterScreen.Register(),
          '/register/verify-phone': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => SendSmsCodeBloc(
                            dataProvider: PhoneVerifyDataProvider(),
                            timerBloc: BlocProvider.of<TimerBloc>(context),
                          )),
                  BlocProvider(
                      create: (context) => MobileVerifyBloc(
                            dataProvider: PhoneVerifyDataProvider(),
                            authUserBloc:
                                BlocProvider.of<AuthUserBloc>(context),
                          )),
                ],
                child: RegisterPhoneVerify(),
              ),
        },
      ),
    );
  }
}
