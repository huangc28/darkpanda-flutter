part of 'determine_location_bloc.dart';

class DetermineLocationState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;
  final Location location;
  final bool isFirstTime;


  const DetermineLocationState._({
    this.status,
    this.error,
    this.location,
    this.isFirstTime,
  });

  const DetermineLocationState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const DetermineLocationState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const DetermineLocationState.error(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const DetermineLocationState.done(Location location)
      : this._(
          status: AsyncLoadingStatus.done,
          location: location,
        );

  @override
  List<Object> get props => [
        status,
        error,
        location,
      ];
}
