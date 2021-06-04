part of 'service_confirm_notifier_bloc.dart';

abstract class ServiceConfirmNotifierState extends Equatable {
  const ServiceConfirmNotifierState(this.message);

  final Message message;

  @override
  List<Object> get props => [
        message,
      ];
}

class ServiceConfirmNotifierInitial extends ServiceConfirmNotifierState {
  const ServiceConfirmNotifierInitial() : super(null);
}

class ServiceConfirmedNotify extends ServiceConfirmNotifierState {
  const ServiceConfirmedNotify(Message message) : super(message);
}
