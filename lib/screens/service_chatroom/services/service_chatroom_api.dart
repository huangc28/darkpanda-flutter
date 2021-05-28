import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

class ServiceChatroomClient extends BaseClient {
  Future<http.Response> fetchIncomingService() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/incoming'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> fetchOverdueService() async {
    try {
      final request = http.Request(
        'GET',
        buildUri('/v1/services/overdue'),
      );

      await withTokenFromSecureStore(request);

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }
}
