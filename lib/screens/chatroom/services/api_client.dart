import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class APIClient extends BaseClient {
  Future<http.Response> fetchInquiryChatroom(String inquiryUUID) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/chat/inquiry', {
        'inquiry_uuid': inquiryUUID,
        'offset': '0',
      }),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
