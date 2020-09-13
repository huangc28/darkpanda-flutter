part of 'timer_bloc.dart';

enum TimerStatus {
  ready,
  progressing,
  completed,
}

class TimerState extends Equatable {
  final int duration;
  final TimerStatus status;

  const TimerState._({this.duration, this.status});

  const TimerState.ready() : this._(duration: 30, status: TimerStatus.ready);

  const TimerState.updateTimer({int duration})
      : this._(
          duration: duration,
          status: TimerStatus.progressing,
        );

  const TimerState.complete()
      : this._(
          duration: 0,
          status: TimerStatus.completed,
        );

  @override
  List<Object> get props => [duration, status];
}
