part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  final int duration;

  const TimerEvent({this.duration});

  @override
  List<Object> get props => [duration];
}

class StartTimer extends TimerEvent {
  const StartTimer({int duration}) : super(duration: duration);
}

class Tick extends TimerEvent {
  const Tick({int duration}) : super(duration: duration);
}

class TimerComplete extends TimerEvent {}
