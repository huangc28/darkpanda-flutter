import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class VerifyRegisterInfoAPIs extends BaseClient {
  Future<http.Response> verifyReferralCode(String refCode) {
    print('DEBUG refCode ${refCode}');

    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/register/verify-referral-code',
          {
            'referral_code': refCode,
          },
        ),
      );

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> verifyUsername(String username) {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/register/verify-username',
          {
            'username': username,
          },
        ),
      );

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
