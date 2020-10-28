import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class ApiClient extends BaseClient {
  Future<http.Response> fetchInquiries({int offset = 0}) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/inquiries', {
          'offset': '$offset',
        }),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> pickupInquiry(String uuid) async {
    try {
      final request = http.Request(
        'POST',
        buildUri("/v1/inquiries/$uuid/pickup"),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }
}
