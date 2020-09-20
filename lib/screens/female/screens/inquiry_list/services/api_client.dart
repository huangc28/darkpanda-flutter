import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class ApiClient extends BaseClient {
  Future<http.Response> fetchInquiries({int offset = 0}) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/inquiries', {
        'offset': '$offset',
      }),
    );

    final res = await sendWithResponse(request);

    return res;
  }
}
