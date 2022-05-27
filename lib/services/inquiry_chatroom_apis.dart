import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:darkpanda_flutter/services/base_client.dart';

class InquiryChatroomApis extends BaseClient {
  Future<http.Response> fetchInquiryChatrooms({int offset = 0}) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/chat/inquiry', {
        'offset': '$offset',
      }),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  // PerPage int `form:"perpage,default=15"`
  // Page    int `form:"page,default=0"`
  Future<http.Response> fetchInquiryHistoricalMessages(String channelUUID,
      [int perPage = 15, page = 1]) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/chat/${channelUUID}/messages', {
        'perpage': '$perPage',
        'page': '$page',
      }),
    );

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }

  Future<http.Response> sendChatroomTextMessage(
      String channelUUID, String content) async {
    final request = http.Request(
      'POST',
      buildUri('/v1/chat/emit-text-message', {
        'channel_uuid': channelUUID,
        'content': content,
      }),
    );

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }

  Future<http.Response> sendChatroomImageMessage(
      String channelUUID, String imageUrl) async {
    final request = http.Request(
      'POST',
      buildUri('/v1/chat/emit-image-message', {
        'channel_uuid': channelUUID,
        'image_url': imageUrl,
      }),
    );

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }

  Future<http.Response> sendChatroomServiceSettingMessage({
    String channelUUID,
    String inquiryUUID,
    DateTime serviceTime,
    int serviceDuration,
    double price,
    String serviceType,
  }) async {
    String appointmentToUtcToIsoString = serviceTime.toUtc().toIso8601String();

    final request = http.Request(
      'POST',
      buildUri(
        '/v1/chat/emit-service-message',
      ),
    );

    request.body = json.encode({
      'channel_uuid': channelUUID,
      'inquiry_uuid': inquiryUUID,
      'service_time': appointmentToUtcToIsoString,
      'service_duration': '$serviceDuration',
      'price': '$price',
      'service_type': serviceType,
    });

    withApplicationJsonHeader(request);

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }

  Future<http.Response> sendInquiryUpdateMessage({
    String serviceUUID,
    String channelUUID,
    DateTime serviceTime,
    int serviceDuration,
    double price,
    String serviceType,
    String address,
  }) async {
    String appointmentToUtcToIsoString = serviceTime.toUtc().toIso8601String();

    final request = http.Request(
      'POST',
      buildUri(
          '/v1/chat/emit-update-service-message'), //emit-inquiry-updated-message
    );

    request.body = json.encode({
      'service_uuid': serviceUUID,
      'channel_uuid': channelUUID,
      'appointment_time': appointmentToUtcToIsoString,
      'duration': serviceDuration,
      'price': price,
      'service_type': serviceType,
      'address': address,
    });

    withApplicationJsonHeader(request);

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }

  Future<http.Response> uploadChatroomImage(File imageFile) async {
    var request = new http.MultipartRequest(
      "POST",
      buildUri('/v1/images'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path.toString(),
      ),
    );

    if (request.files.length == 0) {
      return null;
    }

    await withTokenFromSecureStore(request);
    withMultiPart(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> updateIsRead(String channelUUID) async {
    final request = http.Request(
      'POST',
      buildUri('/v1/chat/emit-update-is-read', {
        'channel_uuid': channelUUID,
      }),
    );

    await withTokenFromSecureStore(request);

    return sendWithResponse(request);
  }
}
