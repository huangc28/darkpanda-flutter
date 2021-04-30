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

class AgeChanged extends UpdateProfileEvent {
  const AgeChanged(this.age);

  final int age;

  @override
  List<Object> get props => [age];
}

class HeightChanged extends UpdateProfileEvent {
  const HeightChanged(this.height);

  final double height;

  @override
  List<Object> get props => [height];
}

class WeightChanged extends UpdateProfileEvent {
  const WeightChanged(this.weight);

  final double weight;

  @override
  List<Object> get props => [weight];
}

class DescriptionChanged extends UpdateProfileEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class UpdateUserProfile extends UpdateProfileEvent {
  const UpdateUserProfile(this.imageList, this.removeImageList);

  final List<UserImage> imageList;
  final List<UserImage> removeImageList;

  @override
  List<Object> get props => [imageList, removeImageList];
}

class UpdateUserImage extends UpdateProfileEvent {
  const UpdateUserImage();

  @override
  List<Object> get props => [];
}

class FetchProfileEdit extends UpdateProfileEvent {
  const FetchProfileEdit(this.userProfile);

  final UserProfile userProfile;

  @override
  List<Object> get props => [this.userProfile];
}
