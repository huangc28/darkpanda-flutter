part of 'remove_user_service_bloc.dart';

abstract class RemoveUserServiceEvent extends Equatable {
  const RemoveUserServiceEvent();

  @override
  List<Object> get props => [];
}

class RemoveUserService extends RemoveUserServiceEvent {
  const RemoveUserService({
    this.serviceOptionId,
  });

  final int serviceOptionId;

  @override
  List<Object> get props => [this.serviceOptionId];
}
