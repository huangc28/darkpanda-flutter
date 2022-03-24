import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class NotInitializedError extends Error {}

bool _isInitialized = false;

// ignore: unused_element
AppConfig _appConfig = AppConfig();

AppConfig get config {
  if (!_isInitialized) {
    throw NotInitializedError();
  }

  return _appConfig;
}

class PubNubConfig {
  final String publishKey;
  final String subscribeKey;
  final String secretKey;

  const PubNubConfig({
    this.publishKey,
    this.subscribeKey,
    this.secretKey,
  });

  factory PubNubConfig.fromMap(Map<String, dynamic> data) {
    return PubNubConfig(
      publishKey: data['publish_key'],
      subscribeKey: data['subscribe_key'],
      secretKey: data['secret_key'],
    );
  }
}

class AppConfig {
  /// API origin url.
  final String serverHost;

  /// Pubnub credentials.
  final PubNubConfig pubnubConfig;

  /// Google map platform. Please read the official site:
  /// [google platform]: (https://cloud.google.com/maps-platform)
  final String geocodingApis;

  /// Secret to deploy android sdk to appcenter.
  final String appCenterAndroidAppSecret;

  static const devEnv = 'development';
  static const prodEnv = 'production';

  const AppConfig({
    this.serverHost,
    this.pubnubConfig,
    this.geocodingApis,
    this.appCenterAndroidAppSecret,
  });

  /// initConfig figures out where to retrieve config variables. If the app is in `development`,
  /// it would get env config from `.env` file. If we are in production build, the configs value are
  /// already set in bash variables hence we can retrieve it straight ahead.
  static initConfig() async {
    final curEnv = String.fromEnvironment('ENV', defaultValue: devEnv);

    if (curEnv == prodEnv) {
      _appConfig = AppConfig(
        appCenterAndroidAppSecret:
            String.fromEnvironment('APPCENTER_ANDROID_APP_SECRET'),
        geocodingApis: String.fromEnvironment('GEOCODING_APIS'),
        serverHost: String.fromEnvironment('SERVER_HOST'),
        pubnubConfig: PubNubConfig(
          publishKey: String.fromEnvironment('PUBNUB_PUBLISH_KEY'),
          subscribeKey: String.fromEnvironment('PUBNUB_SUBSCRIBE_KEY'),
          secretKey: String.fromEnvironment('PUBNUB_SECRET_KEY'),
        ),
      );

      _isInitialized = true;
    }

    if (curEnv == devEnv) {
      await DotEnv.load(fileName: '.env');

      _appConfig = AppConfig(
        appCenterAndroidAppSecret: DotEnv.env['APPCENTER_ANDROID_APP_SECRET'],
        geocodingApis: DotEnv.env['GEOCODING_APIS'],
        serverHost: DotEnv.env['SERVER_HOST'],
        pubnubConfig: PubNubConfig(
          publishKey: DotEnv.env['PUBNUB_PUBLISH_KEY'],
          subscribeKey: DotEnv.env['PUBNUB_PUBLISH_KEY'],
          secretKey: DotEnv.env['PUBNUB_SECRET_KEY'],
        ),
      );

      _isInitialized = true;
    }
  }
}
