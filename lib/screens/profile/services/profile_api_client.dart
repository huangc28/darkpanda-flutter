import 'dart:convert';

import 'package:darkpanda_flutter/screens/profile/models/update_profile.dart';
import 'package:http/http.dart' as http;

import 'package:darkpanda_flutter/services/base_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import 'package:darkpanda_flutter/models/user_profile.dart';

class ProfileApiClient extends BaseClient {
  Future<http.Response> updateUserProfile2(UserProfile userProfile) async {
    try {
      final request = http.Request(
        'POST',
        buildUri("/v1/inquiries/$userProfile/pickup"),
      );

      final res = await sendWithResponse(request);

      return res;
    } on Exception catch (err) {
      throw AppGeneralExeption(message: err.toString());
    }
  }

  Future<http.Response> updateUserProfile(UpdateProfile updateProfile) async {
    try {
      final uuid = updateProfile.userProfile.uuid;
      final body = updateProfile.userProfile;

      final jsonBody = jsonEncode(body);
      final request = http.Request(
        'PUT',
        buildUri('/v1/users/$uuid'),
      );

      request.body = jsonBody;

      await withTokenFromSecureStore(request);
      withJson(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> updateUserProfileImage(
      UpdateProfile updateProfile) async {
    try {
      var request = new http.MultipartRequest(
        "POST",
        buildUri('/v1/images'),
      );

      for (var i = 0; i < updateProfile.userImageList.length; i++) {
        if (updateProfile.userImageList[i].url == null) {
          request.files.add(await http.MultipartFile.fromPath('image',
              updateProfile.userImageList[i].fileName.path.toString()));
        }
      }

      if (request.files.length == 0) {
        return null;
      }

      await withTokenFromSecureStore(request);
      withMultiPart(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (e) {
      rethrow;
    }
  }
}

class Dynamic {}
