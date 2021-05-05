part of 'load_general_recommend_bloc.dart';

class LoadGeneralRecommendState<E extends AppBaseException> extends Equatable {
  const LoadGeneralRecommendState._({
    this.status,
    this.recommendDetail,
    this.error,
  });

  final AsyncLoadingStatus status;
  final RecommendDetail recommendDetail;
  final E error;

  LoadGeneralRecommendState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          recommendDetail: null,
        );

  LoadGeneralRecommendState.loading(LoadGeneralRecommendState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          recommendDetail: state.recommendDetail,
        );

  const LoadGeneralRecommendState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadGeneralRecommendState.loaded({
    RecommendDetail recommendDetail,
  }) : this._(
          status: AsyncLoadingStatus.done,
          recommendDetail: recommendDetail,
        );

  @override
  List<Object> get props => [
        status,
        error,
        recommendDetail,
      ];
}
