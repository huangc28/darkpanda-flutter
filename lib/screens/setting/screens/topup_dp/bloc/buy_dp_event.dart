part of 'buy_dp_bloc.dart';

abstract class BuyDpEvent extends Equatable {
  const BuyDpEvent();

  @override
  List<Object> get props => [];
}

class BuyDp extends BuyDpEvent {
  final String uuid;
  final int rechargeId;
  final String paymentType;
  final Card card;

  const BuyDp({
    this.uuid,
    this.rechargeId,
    this.paymentType,
    this.card,
  });
}
