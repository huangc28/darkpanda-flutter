import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class RateApiClient extends BaseClient {
  Future<http.Response> fetchUserRate(String uuid) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/ratings'),
    );

    await withTokenFromSecureStore(request);
    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
