part of 'determine_location_bloc.dart';

abstract class DetermineLocationEvent extends Equatable {
  const DetermineLocationEvent();

  @override
  List<Object> get props => [];
}

class DetermineLocation extends DetermineLocationEvent {}
