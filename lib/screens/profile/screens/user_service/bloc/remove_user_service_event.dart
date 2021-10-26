part of 'remove_user_service_bloc.dart';

abstract class RemoveUserServiceEvent extends Equatable {
  const RemoveUserServiceEvent();

  @override
  List<Object> get props => [];
}

class RemoveUserService extends RemoveUserServiceEvent {
  const RemoveUserService({
    this.inquiryUuid,
    this.fcmTopic,
  });

  final String inquiryUuid;
  final String fcmTopic;

  @override
  List<Object> get props => [this.inquiryUuid, this.fcmTopic];
}
