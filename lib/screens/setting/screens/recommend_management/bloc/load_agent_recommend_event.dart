part of 'load_agent_recommend_bloc.dart';

abstract class LoadAgentRecommendEvent extends Equatable {
  const LoadAgentRecommendEvent();

  @override
  List<Object> get props => [];
}

class LoadAgentRecommend extends LoadAgentRecommendEvent {
  const LoadAgentRecommend({
    this.uuid,
  });

  final String uuid;
}
