import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';

import 'package:darkpanda_flutter/screens/auth/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/screens/register/services/repository.dart';

import 'package:darkpanda_flutter/screens/auth/bloc/send_login_verify_code_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/services/auth_api_client.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

import './config.dart';
import './theme.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';
import './app.dart';
import './screens/auth/auth_navigator.dart';
import './bloc/auth_user_bloc.dart';

// When is in debugging environment, write mocked jwt token
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);

  final config = await AppConfig.forEnvironment('dev');

  runApp(DarkPandaApp(
    appConfig: config,
  ));
}

class DarkPandaApp extends StatelessWidget {
  DarkPandaApp({
    this.appConfig,
  });
  final mockedJwtToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiZDhhMTYzZjgtNjZlNy00ZjhkLWIyYTItMjA3OTY4YzFiZTA5IiwiYXV0aG9yaXplZCI6ZmFsc2UsImV4cCI6MTYwNDUyMzE2Mn0.GeeMG_PYzn6ul7tYKdufExE7NVgUIuAhgyediQnPV3I';
  final AppConfig appConfig;

  Future<void> _writeMockJwtToken() async {
    if (!kReleaseMode) {
      await SecureStore().writeJwtToken(mockedJwtToken);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _writeMockJwtToken(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Error occur when initialize App: ${snapshot.error}');
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
            BlocProvider(create: (context) => InquiryChatMessagesBloc()),
            BlocProvider(
              create: (context) => InquiryChatroomsBloc(
                inquiryChatMesssagesBloc:
                    BlocProvider.of<InquiryChatMessagesBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => LoadUserBloc(userApis: UserApis()),
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
