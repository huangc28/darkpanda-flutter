part of 'determine_address_bloc.dart';

abstract class DetermineAddressState<E extends AppBaseException>
    extends Equatable {
  const DetermineAddressState({
    this.error,
    this.status,
    this.address,
  });

  final E error;
  final AsyncLoadingStatus status;
  final Address address;

  @override
  List<Object> get props => [
        error,
        status,
        address,
      ];
}

class DetermineAddressInitial extends DetermineAddressState {
  const DetermineAddressInitial()
      : super(
          status: AsyncLoadingStatus.initial,
        );
}

class DetermineAddressLoading extends DetermineAddressState {
  const DetermineAddressLoading()
      : super(
          status: AsyncLoadingStatus.loading,
        );
}

class DetermineAddressError<E extends AppBaseException>
    extends DetermineAddressState {
  const DetermineAddressError(E error)
      : super(
          error: error,
          status: AsyncLoadingStatus.error,
        );
}

class DetermineAddressDone extends DetermineAddressState {
  const DetermineAddressDone({Address address})
      : super(
          address: address,
          status: AsyncLoadingStatus.done,
        );
}
