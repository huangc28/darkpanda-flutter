part of 'load_general_recommend_bloc.dart';

abstract class LoadGeneralRecommendEvent extends Equatable {
  const LoadGeneralRecommendEvent();

  @override
  List<Object> get props => [];
}

class LoadGeneralRecommend extends LoadGeneralRecommendEvent {}
