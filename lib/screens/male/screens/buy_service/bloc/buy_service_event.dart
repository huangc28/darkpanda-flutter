part of 'buy_service_bloc.dart';

abstract class BuyServiceEvent extends Equatable {
  const BuyServiceEvent();

  @override
  List<Object> get props => [];
}

class CreatePayment extends BuyServiceEvent {
  const CreatePayment({this.serviceUuid});

  final String serviceUuid;

  @override
  List<Object> get props => [serviceUuid];
}
