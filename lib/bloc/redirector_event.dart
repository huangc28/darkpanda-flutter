part of 'redirector_bloc.dart';

abstract class RedirectorBlocEvent extends Equatable {
  const RedirectorBlocEvent(this.route);

  final String route;

  @override
  List<Object> get props => [route];
}

class NotifyRedirect extends RedirectorBlocEvent {
  const NotifyRedirect(String route) : super(route);
}
