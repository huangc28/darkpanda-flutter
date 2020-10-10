import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';

class UserApis extends BaseClient {
  // pass in jwt token from constructor to request the API. However,
  // most of the time you don't have the jwt token instance is instantiated.
  // Thus, jwt token can also be passed in from the jwt setter.
  UserApis({String jwtToken}) : super(jwtToken: jwtToken);

  Future<http.Response> fetchMe() async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/me'),
    );

    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> fetchUser(String uuid) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid'),
    );

    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }

  Future<http.Response> fetchUserImages(String uuid, int offset) async {
    final request = http.Request(
      'GET',
      buildUri('/v1/users/$uuid/images', {
        'offset': '$offset',
      }),
    );

    withAuthHeader(request);

    final res = await sendWithResponse(request);

    return res;
  }
}
