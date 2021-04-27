import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:darkpanda_flutter/models/service_settings.dart';

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

  /// Why adding a `Z` at the end of the timezone string? Please read this article:
  /// https://stackoverflow.com/questions/29281935/what-exactly-does-the-t-and-z-mean-in-timestamp
  Future<http.Response> updateInquiry(ServiceSettings serviceSettings) async {
    final appointmentTime = DateTime(
      serviceSettings.serviceDate.year,
      serviceSettings.serviceDate.month,
      serviceSettings.serviceDate.day,
      serviceSettings.serviceTime.hour,
      serviceSettings.serviceTime.minute,
    );
    final request = http.Request(
      'PATCH',
      buildUri(
        '/v1/inquiries/${serviceSettings.uuid}',
      ),
    );

    request.body = json.encode({
      'uuid': serviceSettings.uuid,
      'appointment_time': '${appointmentTime.toIso8601String()}Z',
      'price': serviceSettings.price,
      'duration': serviceSettings.duration.inMinutes,
      'service_type': serviceSettings.serviceType,
      'address': serviceSettings.address,
    });

    withApplicationJsonHeader(request);

    withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }
}
