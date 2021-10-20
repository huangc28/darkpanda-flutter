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

  Future<http.Response> fetchServiceDetail(String serviceUuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/${serviceUuid}'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> cancelService(String serviceUuid) async {
    try {
      final request = http.Request(
        'PUT',
        buildUri('/v1/services/${serviceUuid}/cancel'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> loadCancelService(String uuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/${uuid}/cause-when-cancel'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
