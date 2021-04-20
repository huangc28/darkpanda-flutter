import 'package:http/http.dart' as http;

import './base_client.dart';

class InquiryAPIClient extends BaseClient {
  Future<http.Response> getInquiry(String inquiryUuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/inquiries/${inquiryUuid}'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
