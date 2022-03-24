import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:darkpanda_flutter/services/base_client.dart';

class AddressSelectorAPIClient extends BaseClient {
  Future<http.Response> getCoordinateFromAddress(String address) async {
    final request = http.Request(
      'GET',
      Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {
          'address': address,
          'key': dotenv.env['GEOCODING_APIS'],
        },
      ),
    );

    return sendWithResponse(request);
  }

  Future<http.Response> getAddressFromLocation(
      double latitude, double longtitude) async {
    final request = http.Request(
      'GET',
      Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {
          'language': 'zh-TW',
          'latlng': '${latitude},${longtitude}',
          'key': dotenv.env['GEOCODING_APIS'],
        },
      ),
    );

    return sendWithResponse(request);
  }
}
