import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class BankAPIClient extends BaseClient {
  Future<http.Response> verifyBankAccount(
    String uuid,
    String bankName,
    String branch,
    String accountNumber,
  ) async {
    try {
      final request = http.Request(
        'POST',
        buildUri(
          '/v1/bank_account/$uuid',
          {
            'uuid': uuid,
            'bank_name': bankName,
            'branch': branch,
            'account_number': accountNumber,
          },
        ),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (err) {
      print('DEBUG err ${err}');
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
      buildUri('/v1/bank_account/$uuid'),
    );

    await withTokenFromSecureStore(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
