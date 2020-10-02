import 'package:http/http.dart' as http;

class PhoneVerifyDataProvider {
  Future<http.Response> sendVerifyCode({
    String countryCode,
    String mobileNumber,
    String uuid,
  }) {
    return http.post(
      'http://localhost:3001/v1/send-verify-code',
      body: {
        'uuid': uuid,
        'mobile': '$countryCode$mobileNumber',
      },
    );
  }

  Future<http.Response> verifyMobile({
    String mobile,
    String uuid,
    String verifyCode,
  }) {
    return http.post(
      'http://localhost:3001/v1/verify-phone',
      body: {
        'mobile': mobile,
        'uuid': uuid,
        'verify_code': verifyCode,
      },
    );
  }
}
