import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class InquiryChatroomApis extends BaseClient {
  Future<http.Response> fetchInquiryChatrooms() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/chat', {
          'chatroom_type': 'inquiry',
        }),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  // PerPage int `form:"perpage,default=10"`
  // Page    int `form:"page,default=0"`
  Future<http.Response> fetchInquiryHistoricalMessages(String channelUUID,
      [int perPage = 10, page = 1]) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/chat/${channelUUID}/messages', {
          'perpage': '$perPage',
          'page': '$page',
        }),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> sendChatroomTextMessage(
      String channelUUID, String content) async {
    try {
      final request = http.Request(
        'POST',
        buildUri('/v1/chat/emit-text-message', {
          'channel_uuid': channelUUID,
          'content': content,
        }),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
