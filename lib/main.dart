import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/auth/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/screens/register/services/repository.dart';

import 'package:darkpanda_flutter/screens/auth/bloc/send_login_verify_code_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/services/auth_api_client.dart';

import './theme.dart';
import './services/apis.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';

import './app.dart';

import './screens/auth/auth_navigator.dart';

// import './screens/auth/auth.dart';
// import './screens/auth/bloc/send_login_verify_code_bloc.dart';
// import './screens/auth/services/auth_api_client.dart';
// import './screens/register/register.dart' as RegisterScreen;
// import './screens/register/screens/phone_verify/phone_verify.dart';
// import './screens/register/screens/phone_verify/services/data_provider.dart';

// import './screens/male/screens/search_inquiry/search_inquiry.dart';

import './pkg/timer.dart';
import './bloc/timer_bloc.dart';
import './bloc/auth_user_bloc.dart';

void main() {
  // runApp(StoryboardApp([]));

  runApp(DarkPandaApp());
}

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            RegisterRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthUserBloc(
            dataProvider: UserApis(),
          ),
        ),
        BlocProvider(
          create: (context) => SendLoginVerifyCodeBloc(
            authApiClient: AuthAPIClient(),
          ),
        ),
      ],
      child: SecureStoreProvider(
        secureStorage: SecureStore().fsc,
        child: MaterialApp(
          theme: ThemeManager.getTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => AuthNavigator(),
            '/app': (context) => App(),
          },
        ),
      ),
    );
  }
}
