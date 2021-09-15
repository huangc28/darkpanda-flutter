part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class NicknameChanged extends UpdateProfileEvent {
  const NicknameChanged(this.nickname);

  final String nickname;

  @override
  List<Object> get props => [nickname];
}

class UpdateUserProfile extends UpdateProfileEvent {
  const UpdateUserProfile(
    this.imageList,
    this.removeImageList,
    this.avatarImage,
    this.userProfile,
  );

  final List<UserImage> imageList;
  final List<UserImage> removeImageList;
  final File avatarImage;
  final UserProfile userProfile;

  @override
  List<Object> get props => [
        imageList,
        removeImageList,
        avatarImage,
        userProfile,
      ];
}

class AvatarImageChanged extends UpdateProfileEvent {
  const AvatarImageChanged(this.avatarImage);

  final File avatarImage;

  @override
  List<Object> get props => [avatarImage];
}

class FetchProfileEdit extends UpdateProfileEvent {
  const FetchProfileEdit(this.userProfile);

  final UserProfile userProfile;

  @override
  List<Object> get props => [this.userProfile];
}
