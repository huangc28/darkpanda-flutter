import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/verify_bank.dart';
import 'package:darkpanda_flutter/services/base_client.dart';

class BankAPIClient extends BaseClient {
  Future<http.Response> verifyBankAccount(
    VerifyBank verifyBank,
  ) async {
    try {
      final uuid = verifyBank.uuid;
      final body = verifyBank;

      final jsonBody = jsonEncode(body);
      final request = http.Request(
        'POST',
        buildUri('/v1/users/$uuid/verify-bank'),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withJson(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> fetchUserBankStatus(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/bank'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
