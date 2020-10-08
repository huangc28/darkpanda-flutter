import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

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
import './bloc/auth_user_bloc.dart';

// When is in debugging environment, write mocked jwt token
void main() async {
  runApp(DarkPandaApp());
}

class DarkPandaApp extends StatelessWidget {
  final mockedJwtToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYWI4YmUwOTktZTBlZS00ZTg1LTljYTUtZmI2MDVlNmYwMjJmIiwiYXV0aG9yaXplZCI6ZmFsc2UsImV4cCI6MTYwMjI2MzYyNn0.hbDRQwjjxb1GNbuoqlv1Fi2X6wDqntJ5rXrZ43eOsP4';

  Future<void> _writeMockJwtToken() async {
    if (!kReleaseMode) {
      await SecureStore().writeJwtToken(mockedJwtToken);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _writeMockJwtToken(),
      ]),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text(
              'unable to write mocked jwt token in secure storage: ${snapshot.error}');
        }

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
              initialRoute: '/app',
              routes: {
                '/': (context) => AuthNavigator(),
                '/app': (context) => App(),
              },
            ),
          ),
        );
      },
    );
  }
}
