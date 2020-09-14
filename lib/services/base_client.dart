import 'package:http/http.dart' as http;
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

abstract class BaseClient extends http.BaseClient {
  final String host;

  String jwtToken;
  Uri baseUri;

  BaseClient({
    this.host = 'http://localhost:3001',
    this.jwtToken,
  }) {
    baseUri = Uri.parse(this.host);
  }

  Uri buildUri(String path) {
    return Uri(
      scheme: baseUri.scheme,
      port: baseUri.port,
      host: baseUri.host,
      path: path,
    );
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print('DEBUG send $jwtToken');
    // check if jwtToken is null before sending.
    if (jwtToken == null) {
      return Future.error(
          AppGeneralExeption(message: 'Jwt token can not be null.'));
    }

    request.headers['Authorization'] = 'Bearer $jwtToken';

    return http.Client().send(request);
  }
}
