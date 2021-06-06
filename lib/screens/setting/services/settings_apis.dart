import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

class SettingsAPIClient extends BaseClient {
  Future<http.Response> logout() async {
    final jwt = await SecureStore().readJwtToken();

    final request = http.Request(
      'POST',
      buildUri('/v1/auth/revoke-jwt', {
        'jwt': jwt,
      }),
    );

    await withTokenFromSecureStore(request);

    withApplicationJsonHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
