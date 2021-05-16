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
      buildUri('/v1/block/$uuid'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> removeBlacklistUser({
    int blacklistId,
  }) async {
    try {
      final request = http.Request(
        'DELETE',
        buildUri(
          '/v1/block/$blacklistId',
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
