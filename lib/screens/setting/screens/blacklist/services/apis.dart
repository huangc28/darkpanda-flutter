import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class BlacklistApiClient extends BaseClient {
  Future<http.Response> fetchBlacklistUser(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/block'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> removeBlacklistUser(
    String blockeeUuid,
  ) async {
    try {
      final request = http.Request(
        'DELETE',
        buildUri('/v1/block', {
          'blockee_uuid': blockeeUuid,
        }),
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
