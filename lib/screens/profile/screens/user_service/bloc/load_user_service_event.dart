part of 'load_user_service_bloc.dart';

abstract class LoadUserServiceEvent extends Equatable {
  const LoadUserServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadUserService extends LoadUserServiceEvent {
  final String uuid;

  const LoadUserService({this.uuid});
}

class ClearUserServiceState extends LoadUserServiceEvent {
  const ClearUserServiceState();
}
