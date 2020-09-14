import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/repository.dart';

import './services/apis.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';

import './screens/home/home.dart';
import './screens/register/register.dart' as RegisterScreen;
import './screens/register/screens/phone_verify/phone_verify.dart';
import './screens/register/screens/phone_verify/services/data_provider.dart';

import './screens/female/screens/inquiry_list/inquiry_list.dart';

import './pkg/timer.dart';
import './bloc/timer_bloc.dart';
import './bloc/auth_user_bloc.dart';
import './screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
import './screens/register/screens/phone_verify/bloc/send_sms_code_bloc.dart';

void main() => runApp(DarkPandaApp());

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc(RegisterRepository())),
        BlocProvider(
            create: (context) => AuthUserBloc(dataProvider: UserApis())),
        BlocProvider(create: (context) => TimerBloc(ticker: Timer())),
      ],
      child: SecureStoreProvider(
        secureStorage: SecureStore().fsc,
        child: MaterialApp(
          initialRoute: '/register',
          routes: {
            '/': (context) => Home(),
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
            '/female/inquiry': (context) => InqiuryList(),
          },
        ),
      ),
    );
  }
}
