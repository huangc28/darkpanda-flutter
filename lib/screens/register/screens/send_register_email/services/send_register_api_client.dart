import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class SendRegisterApiClient extends BaseClient {
  Future<http.Response> sendRegisterEmail({
    String email,
    String username,
    String password,
  }) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/register/send-mobile-verify-code',
          {
            'email': '$email',
            'username': '$username',
            'password': '$password',
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

  Future<http.Response> verifyMobile({
    String mobile,
    String uuid,
    String verifyCode,
  }) async {
    try {
      final req = http.Request(
        'POST',
        buildUri('/v1/register/verify-phone', {
          'mobile': mobile,
          'uuid': uuid,
          'verify_code': verifyCode,
        }),
      );

      final res = await sendWithResponse(req);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
