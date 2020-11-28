part of 'get_service_bloc.dart';

abstract class GetServiceEvent extends Equatable {
  const GetServiceEvent();

  @override
  List<Object> get props => [];
}

class GetService extends GetServiceEvent {
  const GetService({
    this.inquiryUUID,
  }) : assert(inquiryUUID != null);

  final String inquiryUUID;
}
