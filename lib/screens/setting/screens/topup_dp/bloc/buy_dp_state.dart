part of 'buy_dp_bloc.dart';

class BuyDpState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const BuyDpState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const BuyDpState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const BuyDpState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const BuyDpState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const BuyDpState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
