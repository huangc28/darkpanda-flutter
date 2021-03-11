import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/services/service_apis.dart';

import 'package:darkpanda_flutter/screens/auth/services/auth_api_client.dart';
import 'package:darkpanda_flutter/screens/auth/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/screens/register/services/repository.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/screens/auth/bloc/send_login_verify_code_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/bloc/notify_service_confirmed_bloc.dart';

import './routes.dart';
import './config.dart';
import './theme.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';
import './bloc/auth_user_bloc.dart';

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
  final AppConfig appConfig;
  final mainRoutes = MainRoutes();

  Future<void> _writeMockJwtToken() =>
      SecureStore().writeJwtToken(appConfig.token);

  @override
  Widget build(BuildContext context) {
    final List<Future> futures = [];

    if (!kReleaseMode) {
      futures.addAll([
        _writeMockJwtToken(),
      ]);
    }

    return FutureBuilder(
      future: Future.wait(futures),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError)
          return Text('Error occur when initialize App: ${snapshot.error}');

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

            // Inquiry chatroom related blocs
            BlocProvider(
              create: (context) => InquiryChatMessagesBloc(),
            ),
            BlocProvider(
              create: (context) => InquiryChatroomsBloc(
                inquiryChatMesssagesBloc:
                    BlocProvider.of<InquiryChatMessagesBloc>(context),
                inquiryChatroomApis: InquiryChatroomApis(),
              ),
            ),
            BlocProvider(
              create: (context) => LoadUserBloc(userApis: UserApis()),
            ),

            // Current chatroom related blocs
            BlocProvider(
              create: (context) => CurrentServiceBloc(
                serviceApis: ServiceAPIs(),
              ),
            ),

            BlocProvider(
              create: (context) => NotifyServiceConfirmedBloc(),
            ),

            BlocProvider(
              create: (context) => CurrentChatroomBloc(
                inquiryChatroomApis: InquiryChatroomApis(),
                inquiryChatroomsBloc:
                    BlocProvider.of<InquiryChatroomsBloc>(context),
                currentServiceBloc:
                    BlocProvider.of<CurrentServiceBloc>(context),
                notifyServiceConfirmedBloc:
                    BlocProvider.of<NotifyServiceConfirmedBloc>(context),
              ),
            ),

            BlocProvider(
              create: (context) => SendMessageBloc(
                inquiryChatroomApis: InquiryChatroomApis(),
              ),
            ),
          ],
          child: SecureStoreProvider(
            secureStorage: SecureStore().fsc,
            child: MaterialApp(
              theme: ThemeManager.getTheme(),
              initialRoute: MainRoutes.auth,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    if (settings.name == MainRoutes.chatroom) {
                      final routeBuilder =
                          mainRoutes.routeBuilder(context, settings.arguments);

                      return routeBuilder[settings.name](context);
                    }

                    return mainRoutes
                        .routeBuilder(context)[settings.name](context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
