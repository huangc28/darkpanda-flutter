part of 'auth_user_bloc.dart';

abstract class AuthUserEvent extends Equatable {
  const AuthUserEvent();

  @override
  List<Object> get props => [];
}

class FetchUserInfo extends AuthUserEvent {}

/// Replace the auth user in the current state with the new auth user.
class PutUser extends AuthUserEvent {
  const PutUser({
    this.authUser,
  });

  final AuthUser authUser;
}

class RemoveAuthUser extends AuthUserEvent {
  const RemoveAuthUser();
}
