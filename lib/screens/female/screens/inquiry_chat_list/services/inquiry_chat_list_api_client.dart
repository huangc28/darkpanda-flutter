import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class InquiryChatListApiClient extends BaseClient {
  Future<http.Response> fetchDirectInquiryRequest({int offset = 0}) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/inquiries/requests', {
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
}
