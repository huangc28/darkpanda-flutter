part of 'load_user_bloc.dart';

enum LoadUserStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadUserState<E extends AppBaseException> extends Equatable {
  const LoadUserState._({
    this.status,
    this.userProfile,
    this.error,
  });

  final LoadUserStatus status;

  final UserProfile userProfile;

  final E error;

  const LoadUserState.initial()
      : this._(
          status: LoadUserStatus.initial,
        );

  const LoadUserState.loading()
      : this._(
          status: LoadUserStatus.loading,
        );

  const LoadUserState.loadFailed(E error)
      : this._(
          status: LoadUserStatus.loadFailed,
          error: error,
        );

  const LoadUserState.loaded({
    UserProfile userProfile,
  }) : this._(
          status: LoadUserStatus.loaded,
          userProfile: userProfile,
        );
  @override
  List<Object> get props => [
        status,
      ];
}
