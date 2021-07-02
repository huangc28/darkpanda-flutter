import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class ChangeMobileClient extends BaseClient {
  Future<http.Response> sendChangeMobile(String mobile) async {
    try {
      final request = http.Request(
        'POST',
        buildUri('/v1/users/send-change-mobile-verify-code', {
          "mobile": mobile,
        }),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }

  Future<http.Response> verifyChangeMobile(String verifyCode) async {
    try {
      final body = {
        "verify_code": verifyCode,
      };

      final jsonBody = jsonEncode(body);

      final request = http.Request(
        'POST',
        buildUri('/v1/users/verify-change-mobile-verify-code'),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withApplicationJsonHeader(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
