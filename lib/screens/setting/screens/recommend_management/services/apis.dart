import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class RecommendAPIClient extends BaseClient {
  Future<http.Response> fetchGeneralRecommendCode() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/referral_code'),
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

  Future<http.Response> fetchAgentRecommend(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/agent_recommend'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
