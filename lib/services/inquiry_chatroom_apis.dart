import 'package:http/http.dart' as http;
import 'dart:convert';

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

      final res = await sendWithResponse(request);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  // PerPage int `form:"perpage,default=15"`
  // Page    int `form:"page,default=0"`
  Future<http.Response> fetchInquiryHistoricalMessages(String channelUUID,
      [int perPage = 15, page = 1]) async {
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

  Future<http.Response> sendChatroomServiceSettingMessage({
    String channelUUID,
    String inquiryUUID,
    DateTime serviceTime,
    int serviceDuration,
    double price,
    String serviceType,
  }) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/chat/emit-service-message',
        ),
      );

      request.body = json.encode({
        'channel_uuid': channelUUID,
        'inquiry_uuid': inquiryUUID,
        'service_time': serviceTime.toUtc().toIso8601String(),
        'service_duration': '$serviceDuration',
        'price': '$price',
        'service_type': serviceType,
      });

      withApplicationJsonHeader(request);

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> sendInquiryUpdateMessage({
    String channelUUID,
    String inquiryUUID,
    DateTime serviceTime,
    int serviceDuration,
    double price,
    String serviceType,
    String address,
  }) async {
    final request = http.Request(
      'POST',
      buildUri('/v1/chat/emit-inquiry-updated-message'),
    );

    request.body = json.encode({
      'channel_uuid': channelUUID,
      'inquiry_uuid': inquiryUUID,
      'appointment_time': '${serviceTime.toIso8601String()}Z',
      'duration': serviceDuration,
      'price': price,
      'service_type': serviceType,
      'address': address,
    });

    withApplicationJsonHeader(request);

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }
}
