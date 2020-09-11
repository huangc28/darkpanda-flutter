import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/screens/pkg/timer.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Timer ticker;

  StreamSubscription<int> _streamSubscription;

  TimerBloc({@required ticker})
      : assert(ticker != null),
        ticker = ticker,
        super(TimerState.ready());

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    // deal with following events
    //   -  timer started
    //   -  timer ticking
    //   -  timer completed
    if (event is StartTimer) {
      _timerStart(event);
    }

    if (event is Tick) {
      yield* _mapTimerTickToState(event);
    }

    if (event is TimerComplete) {
      yield* _mapTimerCompleteToState();
    }
  }

  void _timerStart(StartTimer event) {
    // cancel timer if pre existed
    _streamSubscription?.cancel();
    _streamSubscription = ticker.tick(ticks: event.duration).listen((int tick) {
      tick > 0 ? add(Tick(duration: tick)) : add(TimerComplete());
    });
  }

  Stream<TimerState> _mapTimerTickToState(Tick event) async* {
    // we need to update the timer when duration changes.
    yield TimerState.updateTimer(duration: event.duration);
  }

  Stream<TimerState> _mapTimerCompleteToState() async* {
    yield TimerState.complete();
  }
}
