import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';

class AddressSelectorAPIClient extends BaseClient {
  Future<http.Response> getCoordinateFromAddress(String address) async {
    try {
      // final encodedAddress = Uri.encodeComponent(address);
      // print('DEBUG encodedAddress ${encodedAddress}');
      final request = http.Request(
        'GET',
        Uri.https(
          'maps.googleapis.com',
          '/maps/api/geocode/json',
          {
            'address': address,
            'key': env['GEOCODING_APIS'],
          },
        ),
      );

      return sendWithResponse(request);
    } catch (e) {
      rethrow;
    }
  }
}
