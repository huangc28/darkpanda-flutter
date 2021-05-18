import 'dart:convert';

import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/payment_card.dart';

class TopUpClient extends BaseClient {
  Future<http.Response> fetchMyDp() async {
    final request = http.Request(
      'GET',
      buildUri('/v1/coin'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> fetchDpPackage() async {
    final request = http.Request(
      'GET',
      buildUri('/v1/coin/packages'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> buyDp(PaymentCard buyDp) async {
    try {
      // final uuid = buyDp.uuid;
      final body = buyDp;

      final jsonBody = jsonEncode(body);
      final request = http.Request(
        'POST',
        buildUri('/v1/coin'),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withApplicationJsonHeader(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }
}
