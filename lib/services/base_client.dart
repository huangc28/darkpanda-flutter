import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/config.dart' as Config;
import 'package:darkpanda_flutter/pkg/secure_store.dart';

// Any API client requesting darkpanda service should extend this base client.
// It parses the given backend service origin to [Uri] object and builds correct
// request `uri` string and append necessary request header.
abstract class BaseClient extends http.BaseClient {
  String jwtToken;
  Uri baseUri;

  BaseClient({
    this.jwtToken,
  }) {
    baseUri = Uri.parse(Config.config.serverHost);
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

  withApplicationJsonHeader(http.BaseRequest request) {
    request.headers['Content-Type'] = 'application/json';
  }

  withTokenFromSecureStore(http.BaseRequest request) async {
    final jwt = await SecureStore().readJwtToken();

    if (jwt == null) {
      throw Exception('jwt token can not be null.');
    }

    jwtToken = jwt;

    request.headers['Authorization'] = 'Bearer $jwtToken';
  }

  withMultiPart(http.BaseRequest request) {
    request.headers['Content-type'] = "multipart/form-data";
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
      developer.log(
        'failed to request API ${request.url}',
        error: e,
      );

      rethrow;
    }
  }
}
