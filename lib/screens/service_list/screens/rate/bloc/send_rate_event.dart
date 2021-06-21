part of 'send_rate_bloc.dart';

abstract class SendRateEvent extends Equatable {
  const SendRateEvent();

  @override
  List<Object> get props => [];
}

class SendRate extends SendRateEvent {
  // final String serviceUuid;
  // final int rating;
  // final String comment;
  final Rating rating;

  const SendRate({
    this.rating,
  });
}
