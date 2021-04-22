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
      final age = updateProfile.userProfile.age;
      final height = updateProfile.userProfile.height;
      final weight = updateProfile.userProfile.weight;
      final request = http.Request(
        'PUT',
        buildUri(
          '/v1/users/$uuid',
          {
            'uuid': updateProfile.userProfile.uuid,
            // 'nickname': userProfile.nickname,
            'age': '$age',
            'height': '$height',
            'weight': '$weight',
            'description': updateProfile.userProfile.description,
          },
        ),
      );

      await withTokenFromSecureStore(request);

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

      request.fields['uuid'] = updateProfile.userProfile.uuid;
      request.fields['age'] = updateProfile.userProfile.age.toString();
      request.fields['height'] = updateProfile.userProfile.height.toString();
      request.fields['weight'] = updateProfile.userProfile.weight.toString();
      request.fields['description'] =
          updateProfile.userProfile.description.toString();

      for (var i = 0; i < updateProfile.userImageList.length; i++) {
        if (updateProfile.userImageList[i].url == null) {
          request.files.add(await http.MultipartFile.fromPath('image',
              updateProfile.userImageList[i].fileName.path.toString()));
        }
      }

      await withTokenFromSecureStoreMultiPart(request);

      final res = await sendWithResponse(request);

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
