import 'dart:convert';

import 'package:darkpanda_flutter/screens/service_list/screens/rate/models/rating.dart';
import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class ServiceChatroomClient extends BaseClient {
  Future<http.Response> fetchIncomingService() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/incoming'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> fetchOverdueService() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/overdue'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> fetchPaymentDetail(String serviceUuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/$serviceUuid/payment-details'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> fetchRateDetail(String serviceUuid) async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/$serviceUuid/rating'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> sendRate(Rating rating) async {
    try {
      final body = rating;

      final jsonBody = jsonEncode(body);
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/services/${rating.serviceUuid}/rating',
        ),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withJson(request);

      final res = await sendWithResponse(request);
      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> blockUser(
    String uuid,
  ) async {
    final request = http.Request(
      'Post',
      buildUri('/v1/block'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
