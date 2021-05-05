import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class RecommendAPIClient extends BaseClient {
  Future<http.Response> fetchGeneralRecommend(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/general_recommend'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
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
