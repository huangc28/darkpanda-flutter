part of 'determine_location_bloc.dart';

abstract class DetermineLocationEvent extends Equatable {
  const DetermineLocationEvent();

  @override
  List<Object> get props => [];
}

class DetermineLocationFromAddress extends DetermineLocationEvent {
  final String address;

  const DetermineLocationFromAddress({
    this.address,
  });
}
