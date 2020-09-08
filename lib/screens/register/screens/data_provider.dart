import 'package:http/http.dart' as http;

class PhoneVerifyDataProvider {
  Future<http.Response> sendVerifyCode({
    String countryCode,
    String mobileNumber,
    String uuid,
  }) {
    print('DEBUG DataProvider $countryCode$mobileNumber');
    // join count code with mobile
    return http.post(
      'http://localhost:3001/v1/send-verify-code',
      body: {
        'uuid': uuid,
        'mobile': '$countryCode$mobileNumber',
      },
    );
  }
}
