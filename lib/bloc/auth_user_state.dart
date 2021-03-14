part of 'auth_user_bloc.dart';

enum FetchUserStatus {
  initial,
  fetching,
  fetchFailed,
  fetchSuccess,
}

class AuthUserState<Error extends AppBaseException> extends Equatable {
  const AuthUserState._({
    this.status,
    this.error,
    this.user,
  });

  final FetchUserStatus status;
  final Error error;
  final AuthUser user;

  AuthUserState.initial({
    AuthUser authUser,
  }) : this._(
          status: FetchUserStatus.initial,
          user: authUser,
        );

  AuthUserState.fetching(AuthUserState m)
      : this._(
          status: FetchUserStatus.fetching,
          error: null,
        );

  AuthUserState.fetchFailed(AuthUserState m)
      : this._(
          status: FetchUserStatus.fetchFailed,
          error: m.error,
        );

  AuthUserState.fetchSuccess(
    AuthUserState m, {
    AuthUser authUser,
  }) : this._(
          status: FetchUserStatus.fetchSuccess,
          user: authUser ?? m.user,
          error: null,
        );

  AuthUserState.patchUser(
    AuthUserState m, {
    AuthUser user,
  }) : this._(
          status: m.status,
          user: user ?? m.user,
        );

  factory AuthUserState.copyFrom(
    AuthUserState state, {
    AuthUser user,
    Error error,
  }) {
    return AuthUserState._(
      user: user ?? state.user,
      error: error ?? state.error,
    );
  }

  @override
  List<Object> get props => [
        user,
        status,
        error,
      ];
}
