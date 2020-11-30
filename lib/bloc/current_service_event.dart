part of 'current_service_bloc.dart';

abstract class GetServiceEvent extends Equatable {
  const GetServiceEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentService extends GetServiceEvent {
  const GetCurrentService({
    this.inquiryUUID,
  }) : assert(inquiryUUID != null);

  final String inquiryUUID;
}

class UpdateCurrentServiceByMessage extends GetServiceEvent {
  const UpdateCurrentServiceByMessage({
    this.messasge,
  }) : assert(messasge != null);

  final ServiceDetailMessage messasge;
}
