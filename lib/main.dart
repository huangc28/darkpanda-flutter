import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/services/service_apis.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/register_api_client.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/bloc/notify_service_confirmed_bloc.dart';
import 'package:darkpanda_flutter/bloc/get_inquiry_bloc.dart';

import './routes.dart';
import './theme.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';
import './bloc/auth_user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);

  await DotEnv.load(fileName: '.env');

  runApp(
    DarkPandaApp(),
  );
}

class DarkPandaApp extends StatelessWidget {
  DarkPandaApp();

  final mainRoutes = MainRoutes();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            registerAPI: RegisterAPIClient(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthUserBloc(
            dataProvider: UserApis(),
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
            currentServiceBloc: BlocProvider.of<CurrentServiceBloc>(context),
            notifyServiceConfirmedBloc:
                BlocProvider.of<NotifyServiceConfirmedBloc>(context),
          ),
        ),

        BlocProvider(
          create: (_) => SendMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(create: (_) => GetInquiryBloc()),
      ],
      child: SecureStoreProvider(
        secureStorage: SecureStore().fsc,
        child: MaterialApp(
          supportedLocales: [
            Locale.fromSubtags(languageCode: 'zh'),
          ],

          /// CupertinoLocalization: https://github.com/flutter/flutter/issues/13452
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeManager.getTheme(),
          initialRoute: MainRoutes.login,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                if (settings.name == MainRoutes.chatroom) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                return mainRoutes.routeBuilder(context)[settings.name](context);
              },
            );
          },
        ),
      ),
    );
  }
}
