import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class BlacklistApiClient extends BaseClient {
  Future<http.Response> fetchBlacklistUser(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/blacklist'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> removeBlacklistUser({
    String uuid,
    int blacklistId,
  }) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/users/$uuid/blacklist/$blacklistId/remove',
        ),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
