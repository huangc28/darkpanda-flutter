import 'package:http/http.dart' as http;
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

// Any API client requesting darkpanda service should extend this base client.
// It parses the given backend service origin to [Uri] object and builds correct
// request `uri` string and append necessary request header.
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

  Uri buildUri(String path, [Map<String, dynamic> queryParams]) {
    return Uri(
      scheme: baseUri.scheme,
      port: baseUri.port,
      host: baseUri.host,
      path: path,
      queryParameters: queryParams,
    );
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // check if jwtToken is null before sending.
    if (jwtToken == null) {
      return Future.error(
          AppGeneralExeption(message: 'Jwt token can not be null.'));
    }

    request.headers['Authorization'] = 'Bearer $jwtToken';

    return http.Client().send(request);
  }

  // Sends request and return [http.Response] object as the result. It converts
  // [http.StreamResponse] to [http.Response]
  Future<http.Response> sendWithResponse(http.BaseRequest request) async {
    final streamResp = await this.send(request);

    return http.Response.fromStream(streamResp);
  }
}
