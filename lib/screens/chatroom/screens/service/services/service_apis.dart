import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class ServiceAPIs extends BaseClient {
  Future<http.Response> fetchServiceByInquiryUUID(String uuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/inquiries/${uuid}/service'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
