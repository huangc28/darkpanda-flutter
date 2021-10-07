part of 'load_female_list_bloc.dart';

class LoadFemaleListState<E extends AppBaseException> extends Equatable {
  const LoadFemaleListState._({
    this.status,
    this.femaleUserList,
    this.error,
  });

  final AsyncLoadingStatus status;

  final FemaleUserList femaleUserList;

  final E error;

  const LoadFemaleListState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadFemaleListState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadFemaleListState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadFemaleListState.loaded({
    FemaleUserList femaleUserList,
  }) : this._(
          status: AsyncLoadingStatus.done,
          femaleUserList: femaleUserList,
        );

  const LoadFemaleListState.clearState()
      : this._(
          femaleUserList: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        error,
        femaleUserList,
      ];
}
