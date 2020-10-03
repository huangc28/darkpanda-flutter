import 'package:http/http.dart' as http;
import 'package:darkpanda_flutter/services/base_client.dart';

class VerifyRegisterCodeAPIs extends BaseClient {
  Future<http.Response> verifyRegisterCode({
    String mobile,
    String uuid,
    String verifyCode,
  }) async {
    final request = http.Request(
      'POST',
      buildUri('/v1/verify-phone', {
        'mobile': mobile,
        'uuid': uuid,
        'verify_code': verifyCode,
      }),
    );

    final resp = await sendWithResponse(request);

    return resp;
  }
}
