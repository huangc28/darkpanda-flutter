part of 'load_service_list_bloc.dart';

class LoadServiceListState<E extends AppBaseException> extends Equatable {
  const LoadServiceListState._({
    this.status,
    this.serviceList,
    this.error,
  });

  final AsyncLoadingStatus status;
  final ServiceList serviceList;
  final E error;

  LoadServiceListState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          serviceList: null,
        );

  LoadServiceListState.loading(LoadServiceListState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          serviceList: state.serviceList,
        );

  const LoadServiceListState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadServiceListState.loaded({
    ServiceList serviceList,
  }) : this._(
          status: AsyncLoadingStatus.done,
          serviceList: serviceList,
        );

  const LoadServiceListState.clearState()
      : this._(
          serviceList: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
