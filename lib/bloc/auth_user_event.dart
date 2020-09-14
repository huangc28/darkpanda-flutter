part of 'auth_user_bloc.dart';

abstract class AuthUserEvent extends Equatable {
  const AuthUserEvent();

  @override
  List<Object> get props => [];
}

class PatchJwt extends AuthUserEvent {
  final String jwt;

  PatchJwt({this.jwt});
}

class FetchUserInfo extends AuthUserEvent {}
