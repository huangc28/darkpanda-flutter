part of 'load_rate_detail_bloc.dart';

class LoadRateDetailState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final RateDetail rateDetail;
  final E error;

  const LoadRateDetailState._({
    this.status,
    this.rateDetail,
    this.error,
  });

  LoadRateDetailState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          rateDetail: null,
        );

  LoadRateDetailState.loading(LoadRateDetailState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  LoadRateDetailState.loadSuccess(LoadRateDetailState state,
      {RateDetail rateDetail})
      : this._(status: AsyncLoadingStatus.done, rateDetail: rateDetail);

  LoadRateDetailState.loadFailed(LoadRateDetailState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
        );

  @override
  List<Object> get props => [
        status,
        rateDetail,
        error,
      ];
}
