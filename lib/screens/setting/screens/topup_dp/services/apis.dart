import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/card.dart';

class TopUpClient extends BaseClient {
  Future<http.Response> fetchMyDpAndRechargeList(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/my_dp'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> buyDp({
    String uuid,
    int rechargeId,
    String paymentType,
    Card card,
  }) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/users/buy_dp',
          {
            'uuid': uuid,
            'recharge_id': rechargeId,
            'payment_type': paymentType,
            'card': card.toJson(),
          },
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
