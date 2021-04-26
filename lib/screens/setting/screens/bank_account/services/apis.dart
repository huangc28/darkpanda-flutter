import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class BankAPIClient extends BaseClient {
  Future<http.Response> verifyBankAccount(
      {String uuid,
      String accountName,
      String bankCode,
      int accountNumber}) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/users/verify-bank',
          {
            'uuid': uuid,
            'account_name': accountName,
            'bank_code': bankCode,
            'account_number': accountNumber,
          },
        ),
      );

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      throw AppGeneralExeption(
        message: err.toString(),
      );
    }
  }

  Future<http.Response> fetchUserBankStatus(
    String uuid,
  ) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/bank'),
    );

    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
