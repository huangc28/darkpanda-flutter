part of 'load_agent_recommend_bloc.dart';

class LoadAgentRecommendState<E extends AppBaseException> extends Equatable {
  const LoadAgentRecommendState._({
    this.status,
    this.recommendDetail,
    this.error,
  });

  final AsyncLoadingStatus status;
  final RecommendDetail recommendDetail;
  final E error;

  LoadAgentRecommendState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          recommendDetail: null,
        );

  LoadAgentRecommendState.loading(LoadAgentRecommendState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          recommendDetail: state.recommendDetail,
        );

  const LoadAgentRecommendState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadAgentRecommendState.loaded({
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
