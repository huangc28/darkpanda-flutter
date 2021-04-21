part of 'determine_address_bloc.dart';

abstract class DetermineAddressEvent extends Equatable {
  const DetermineAddressEvent();

  @override
  List<Object> get props => [];
}

class DetermineAddressFromLocation extends DetermineAddressEvent {
  final double latitude;
  final double longtitude;

  const DetermineAddressFromLocation({
    this.latitude,
    this.longtitude,
  })  : assert(latitude != null),
        assert(longtitude != null);
}
