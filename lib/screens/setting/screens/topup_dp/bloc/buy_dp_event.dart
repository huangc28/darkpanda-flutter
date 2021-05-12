part of 'buy_dp_bloc.dart';

abstract class BuyDpEvent extends Equatable {
  const BuyDpEvent();

  @override
  List<Object> get props => [];
}

class BuyDp extends BuyDpEvent {
  const BuyDp(this.buyCoin);

  final BuyCoin buyCoin;

  @override
  List<Object> get props => [buyCoin];
}
