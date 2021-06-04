import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/services/service_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_apis.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/register_api_client.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/current_service_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/get_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/update_inquiry_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/current_service_bloc.dart';

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

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

        BlocProvider(create: (context) => ServiceConfirmNotifierBloc()),

        BlocProvider(
          create: (context) => CurrentChatroomBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
            userApis: UserApis(),
            inquiryChatroomsBloc:
                BlocProvider.of<InquiryChatroomsBloc>(context),
            currentServiceBloc: BlocProvider.of<CurrentServiceBloc>(context),
            serviceConfirmNotifierBloc:
                BlocProvider.of<ServiceConfirmNotifierBloc>(context),
          ),
        ),

        BlocProvider(
          create: (context) => CurrentServiceChatroomBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
            userApis: UserApis(),
            inquiryChatroomsBloc:
                BlocProvider.of<InquiryChatroomsBloc>(context),
            currentServiceBloc: BlocProvider.of<CurrentServiceBloc>(context),
            serviceConfirmNotifierBloc:
                BlocProvider.of<ServiceConfirmNotifierBloc>(context),
          ),
        ),

        BlocProvider(
          create: (_) => SendMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(
          create: (_) => GetInquiryBloc(
            inquiryApi: InquiryAPIClient(),
          ),
        ),

        BlocProvider(
          create: (_) => UpdateInquiryBloc(
            apis: InquiryAPIClient(),
          ),
        ),
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
                } else if (settings.name == MainRoutes.serviceChatroom) {
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
