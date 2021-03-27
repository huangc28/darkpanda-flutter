import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class RegisterAPIClient extends BaseClient {
  Future<http.Response> register(
      {String username, String gender, String refCode}) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/register',
          {
            'username': username,
            'gender': gender,
            'refer_code': refCode,
          },
        ),
      );

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
