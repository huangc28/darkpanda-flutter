import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class InquiryChatroomApis extends BaseClient {
  Future<http.Response> fetchInquiryChatrooms() async {
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

  Future<http.Response> fetchInquiryHistoricalMessages(
      String channelUUID) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/chat/${channelUUID}'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
