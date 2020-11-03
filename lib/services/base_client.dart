import 'package:darkpanda_flutter/pkg/secure_store.dart';
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

  withAuthHeader(http.BaseRequest request) {
    if (jwtToken == null) {
      throw Exception(
        'jwt token can not be null.',
      );
    }

    request.headers['Authorization'] = 'Bearer $jwtToken';
  }

  withTokenFromSecureStore(http.BaseRequest request) async {
    final jwt = await SecureStore().readJwtToken();

    if (jwt == null) {
      throw Exception('jwt token can not be null.');
    }

    jwtToken = jwt;

    request.headers['Authorization'] = 'Bearer $jwtToken';
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      http.Client().send(request);

  // Sends request and return [http.Response] object as the result. It converts
  // [http.StreamResponse] to [http.Response]
  Future<http.Response> sendWithResponse(http.BaseRequest request) async {
    try {
      final streamResp = await this.send(request);

      return http.Response.fromStream(streamResp);
    } catch (e) {
      rethrow;
    }
  }
}
