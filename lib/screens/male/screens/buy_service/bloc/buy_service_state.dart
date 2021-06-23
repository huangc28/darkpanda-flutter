part of 'buy_service_bloc.dart';

class BuyServiceState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const BuyServiceState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  BuyServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  BuyServiceState.loading(BuyServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  BuyServiceState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  BuyServiceState.done(BuyServiceState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
