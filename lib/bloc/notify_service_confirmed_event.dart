part of 'notify_service_confirmed_bloc.dart';

class NotifyServiceConfirmedEvent extends Equatable {
  const NotifyServiceConfirmedEvent();

  @override
  List<Object> get props => [];
}

class NotifyServiceConfirmed extends NotifyServiceConfirmedEvent {
  const NotifyServiceConfirmed({
    this.channelUUID,
  }) : assert(channelUUID != null);

  final String channelUUID;

  @override
  List<Object> get props => [];
}

class ClearNotify extends NotifyServiceConfirmedEvent {
  const ClearNotify();

  @override
  List<Object> get props => [];
}
