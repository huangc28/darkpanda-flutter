part of 'service_start_notifier_bloc.dart';

abstract class ServiceStartNotifierEvent extends Equatable {
  const ServiceStartNotifierEvent(this.message);

  final Message message;

  @override
  List<Object> get props => [message];
}

class NotifyServiceStarted extends ServiceStartNotifierEvent {
  const NotifyServiceStarted(Message message) : super(message);
}
