part of 'load_user_bloc.dart';

abstract class LoadUserEvent extends Equatable {
  const LoadUserEvent();

  @override
  List<Object> get props => [];
}

class LoadUser extends LoadUserEvent {
  final String uuid;

  const LoadUser({this.uuid});
}
