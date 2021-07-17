part of 'update_profile_bloc.dart';

enum UpdateProfileStatus {
  initial,
  verifying,
  verifyFailed,
  verified,
}

class UpdateProfileState<E extends AppBaseException> extends Equatable {
  final models.UserProfile userProfile;
  final AsyncLoadingStatus status;
  final E error;

  final bool ready;
  final String uuid;
  final String username;
  final String nickname;
  final String gender;
  final String avatarUrl;
  final String nationality;
  final String region;
  final int age;
  final double height;
  final double weight;
  final String description;
  final File avatarImage;

  const UpdateProfileState._({
    this.ready = false,
    this.userProfile,
    this.status,
    this.error,
    this.uuid,
    this.username,
    this.nickname,
    this.gender,
    this.avatarUrl,
    this.nationality,
    this.region,
    this.age,
    this.height,
    this.weight,
    this.description,
    this.avatarImage,
  });

  UpdateProfileState copyWith({
    bool ready,
    String uuid,
    String username,
    String nickname,
    int age,
    double height,
    double weight,
    String description,
    File avatarImage,
  }) {
    print("Height copy: " + height.toString());
    return UpdateProfileState._(
      ready: ready ?? this.ready,
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      avatarImage: avatarUrl ?? this.avatarImage,
    );
  }

  UpdateProfileState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
          userProfile: null,
        );

  UpdateProfileState.updating(UpdateProfileState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          // error: m.error,
          userProfile: m.userProfile,
        );

  UpdateProfileState.updateFailed(UpdateProfileState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          userProfile: m.userProfile,
        );

  UpdateProfileState.updated()
      : this._(
          status: AsyncLoadingStatus.done,
          // error: m.error,
          // userProfile: m.userProfile,
        );

  factory UpdateProfileState.copyFrom(
    UpdateProfileState state, {
    E error,
    models.UserProfile userProfile,
    double height,
  }) {
    return UpdateProfileState._(
      error: error ?? state.error,
      userProfile: userProfile ?? state.userProfile,
      // height: height ?? state.height,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        userProfile,
        uuid,
        username,
        nickname,
        age,
        height,
        weight,
        description
      ];
}
