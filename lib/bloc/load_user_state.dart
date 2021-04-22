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

  final AsyncLoadingStatus status;

  final UserProfile userProfile;

  final E error;

  const LoadUserState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadUserState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadUserState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadUserState.loaded({
    UserProfile userProfile,
  }) : this._(
          status: AsyncLoadingStatus.done,
          userProfile: userProfile,
        );

  const LoadUserState.clearState(LoadUserState state)
      : this._(
          userProfile: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
