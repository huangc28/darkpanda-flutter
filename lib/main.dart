import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/repository.dart';

import './screens/login/login.dart';
import './screens/register/register.dart' as RegisterScreen;
import './screens/register/screens/phone_verify/phone_verify.dart';
import './screens/register/screens/data_provider.dart';

import './screens/register/screens/bloc/mobile_verify_bloc.dart';

void main() => runApp(DarkPandaApp());

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterBloc(RegisterRepository()),
        child: MaterialApp(
          initialRoute: '/register',
          routes: {
            '/login': (context) => Login(),
            '/register': (context) => RegisterScreen.Register(),
            '/register/verify-phone': (context) => BlocProvider(
                  create: (context) => MobileVerifyBloc(
											dataProvider : PhoneVerifyDataProvider(),
									),
                  child: RegisterPhoneVerify(),
                ),
          },
        ));
  }
}
// (context) => RegisterPhoneVerify()
