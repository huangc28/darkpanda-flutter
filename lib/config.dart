import 'dart:convert';
import 'package:flutter/services.dart';

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
  final PubNubConfig pubnubConfig;
  final String token;

  const AppConfig({
    this.pubnubConfig,
    this.token,
  });

  static Future<AppConfig> forEnvironment(String env) async {
    env = env ?? 'dev';

    // Load json file
    final content = await rootBundle.loadString('assets/config/$env.json');

    // Decode our json
    final json = jsonDecode(content);

    return AppConfig(
      token: json['token'] ?? '',
      pubnubConfig: PubNubConfig.fromMap(json['pubnub']),
    );
  }

  factory AppConfig.fromMap(Map<String, dynamic> data) {
    return AppConfig(
      pubnubConfig: PubNubConfig.fromMap(data['pubnub']),
    );
  }
}
