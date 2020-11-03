import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/base_client.dart';

class InquiryChatsApis extends BaseClient {
  Future<http.Response> fetchChats() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/chat/inquiry-chatrooms'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
