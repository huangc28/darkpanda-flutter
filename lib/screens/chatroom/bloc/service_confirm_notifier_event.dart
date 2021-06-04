part of 'service_confirm_notifier_bloc.dart';

abstract class ServiceConfirmNotifierEvent extends Equatable {
  const ServiceConfirmNotifierEvent(this.message);

  final Message message;

  @override
  List<Object> get props => [
        message,
      ];
}

class NotifyServiceConfirmed extends ServiceConfirmNotifierEvent {
  const NotifyServiceConfirmed(Message message) : super(message);
}
