import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/inquiry_forms.dart';

class SearchInquiryAPIs extends BaseClient {
  Future<http.Response> fetchServiceList() async {
    final request = http.Request(
      'GET',
      buildUri('/v1/services/service-list'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> searchInquiry(InquiryForms inquiryForms) async {
    try {
      final appointmentTime = DateTime(
        inquiryForms.inquiryDate.year,
        inquiryForms.inquiryDate.month,
        inquiryForms.inquiryDate.day,
        inquiryForms.inquiryTime.hour,
        inquiryForms.inquiryTime.minute,
      );

      final body = inquiryForms;

      final jsonBody = jsonEncode({
        'budget': body.budget,
        'service_type': body.serviceType,
        'AppointmentTime': '${appointmentTime.toIso8601String()}Z',
        'ServiceDuration': body.duration.inMinutes,
      });

      final request = http.Request(
        'POST',
        buildUri('/v1/inquiries'),
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
