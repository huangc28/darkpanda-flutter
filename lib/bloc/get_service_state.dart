part of 'get_service_bloc.dart';

enum GetServiceStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class GetServiceState<E extends AppBaseException> extends Equatable {
  GetServiceState._({
    this.status,
    this.serviceSettings,
    this.error,
  });

  final GetServiceStatus status;
  final ServiceSettings serviceSettings;
  final E error;

  GetServiceState.init()
      : this._(
          status: GetServiceStatus.initial,
        );

  GetServiceState.loading(GetServiceState state)
      : this._(
          status: GetServiceStatus.loading,
          serviceSettings: state.serviceSettings,
        );

  GetServiceState.loadFailed(GetServiceState state, E error)
      : this._(
          status: GetServiceStatus.loadFailed,
          serviceSettings: state.serviceSettings,
          error: error,
        );

  GetServiceState.loaded(ServiceSettings serviceSettings)
      : this._(
          status: GetServiceStatus.loaded,
          serviceSettings: serviceSettings,
        );

  @override
  List<Object> get props => [
        status,
        serviceSettings,
      ];
}
