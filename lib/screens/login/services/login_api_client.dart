import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class LoginAPIClient extends BaseClient {
  Future<http.Response> sendLoginVerifyCode(String username) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/auth/send-verify-code',
          {
            'username': username,
          },
        ),
      );

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      print('DEBUG err ${err}');
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }

  Future<http.Response> verifyLoginCode({
    String uuid,
    String verifyChars,
    String verifyDigs,
    String mobile,
  }) async {
    try {
      final request = http.Request(
          'POST',
          buildUri(
            '/v1/auth/verify-code',
            {
              'uuid': uuid,
              'mobile': mobile,
              'verify_char': verifyChars,
              'verify_dig': verifyDigs,
            },
          ));

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
