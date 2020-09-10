part of 'auth_user_bloc.dart';

class AuthUserState extends Equatable {
  final String jwt;

  const AuthUserState._({this.jwt});

  const AuthUserState.initial() : this._();

  const AuthUserState.patchJwt({String jwt}) : this._(jwt: jwt);

  @override
  List<Object> get props => [];
}

// class AuthUserInitial extends AuthUserState {}
