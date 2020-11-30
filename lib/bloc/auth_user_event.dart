part of 'auth_user_bloc.dart';

abstract class AuthUserEvent extends Equatable {
  const AuthUserEvent();

  @override
  List<Object> get props => [];
}

class PatchJwt extends AuthUserEvent {
  const PatchJwt({
    this.jwt,
  });

  final String jwt;
}

class FetchUserInfo extends AuthUserEvent {}

/// Replace the auth user in the current state with the
/// new auth user.
class PutUser extends AuthUserEvent {
  const PutUser({
    this.authUser,
  });

  final AuthUser authUser;
}
