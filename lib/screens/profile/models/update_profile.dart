import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

class UpdateProfile {
  final UserProfile userProfile;
  final List<UserImage> userImageList;

  const UpdateProfile({this.userProfile, this.userImageList});

  Map<String, dynamic> toJson() => {
        'user_profile': userProfile,
        'user_image_list': userImageList,
      };
}
