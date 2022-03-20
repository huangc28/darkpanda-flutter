import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../models/rating.dart';

class RatingAPIClient extends BaseClient {
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
      withApplicationJsonHeader(request);

      final res = await sendWithResponse(request);
      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }
}
