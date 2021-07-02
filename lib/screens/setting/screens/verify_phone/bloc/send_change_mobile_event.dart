part of 'send_change_mobile_bloc.dart';

abstract class SendChangeMobileEvent extends Equatable {
  const SendChangeMobileEvent();

  @override
  List<Object> get props => [];
}

class SendChangeMobile extends SendChangeMobileEvent {
  const SendChangeMobile(this.mobile);

  final String mobile;

  @override
  List<Object> get props => [mobile];
}
