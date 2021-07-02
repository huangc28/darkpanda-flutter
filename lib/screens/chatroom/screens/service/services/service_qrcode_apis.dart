import 'dart:convert';

import 'package:darkpanda_flutter/models/scan_qrcode.dart';
import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/models/service_qrcode.dart';

class ServiceQrCodeAPIs extends BaseClient {
  Future<http.Response> fetchServiceQrCodeByServiceUUID(
      String serviceUuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/${serviceUuid}/qrcode'),
      );

      await withTokenFromSecureStore(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> scanServiceQrCode(ScanQrCode scanQrCode) async {
    try {
      final body = scanQrCode;

      final jsonBody = jsonEncode(body);
      final request = http.Request(
        'POST',
        buildUri('/v1/services/scan-service-qrcode'),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withApplicationJsonHeader(request);

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
