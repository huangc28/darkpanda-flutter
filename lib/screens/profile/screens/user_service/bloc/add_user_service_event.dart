part of 'add_user_service_bloc.dart';

abstract class AddUserServiceEvent extends Equatable {
  const AddUserServiceEvent();

  @override
  List<Object> get props => [];
}

class AddUserService extends AddUserServiceEvent {
  const AddUserService({
    this.inquiryUuid,
    this.fcmTopic,
  });

  final String inquiryUuid;
  final String fcmTopic;

  @override
  List<Object> get props => [this.inquiryUuid, this.fcmTopic];
}
