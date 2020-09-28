import 'package:http/http.dart' as http;
import 'package:darkpanda_flutter/services/base_client.dart';

class AuthAPIClient extends BaseClient {
  Future<http.Response> sendLoginVerifyCode(String username) async {
    final request = http.Request(
        'POST',
        buildUri(
          '/v1/send-login-verify-code',
          {
            'username': username,
          },
        ));

    final res = await sendWithResponse(request);

    return res;
  }
}
