import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class UserServiceApiClient extends BaseClient {
  Future<http.Response> fetchUserService(String uuid) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/service-option'),
    );

    await withTokenFromSecureStore(request);
    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> createUserService(
    String name,
    String description,
    double price,
  ) async {
    try {
      final jsonBody = jsonEncode({
        'name': name,
        'description': 'description',
        'price': price,
        'service_option_type': 'default',
      });

      final request = http.Request(
        'POST',
        buildUri("/v1/users/service-option"),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withApplicationJsonHeader(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> deleteUserService(int serviceOptionId) async {
    try {
      final request = http.Request(
        'POST',
        buildUri("/v1/users/delete-service-option", {
          'service_option_id': serviceOptionId.toString(),
        }),
      );

      await withTokenFromSecureStore(request);
      withAuthHeader(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }
}
