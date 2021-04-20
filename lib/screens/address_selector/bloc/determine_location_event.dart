part of 'determine_location_bloc.dart';

abstract class DetermineLocationEvent extends Equatable {
  const DetermineLocationEvent();

  @override
  List<Object> get props => [];
}

class DetermineCurrentLocation extends DetermineLocationEvent {}

class DetermineLocationFromAddress extends DetermineLocationEvent {
  final String address;

  const DetermineLocationFromAddress({
    this.address,
  });
}

class DetermineAddressFromLocation extends DetermineLocationEvent {}
