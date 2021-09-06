part of 'service_start_notifier_bloc.dart';

abstract class ServiceStartNotifierState extends Equatable {
  const ServiceStartNotifierState(this.message);

  final Message message;

  @override
  List<Object> get props => [
        message,
      ];
}

class ServiceStartNotifierInitial extends ServiceStartNotifierState {
  const ServiceStartNotifierInitial() : super(null);
}

class ServiceStartedNotify extends ServiceStartNotifierState {
  const ServiceStartedNotify(Message message) : super(message);
}
