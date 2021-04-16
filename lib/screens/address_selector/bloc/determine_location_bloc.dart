import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'determine_location_event.dart';
part 'determine_location_state.dart';

class DetermineLocationBloc
    extends Bloc<DetermineLocationEvent, DetermineLocationState> {
  DetermineLocationBloc() : super(DetermineLocationState.init());

  @override
  Stream<DetermineLocationState> mapEventToState(
    DetermineLocationEvent event,
  ) async* {
    if (event is DetermineLocation) {
      yield* _mapDetermineLocationToState(event);
    }
  }

  Stream<DetermineLocationState> _mapDetermineLocationToState(
      DetermineLocation event) async* {
    yield null;
  }
}
