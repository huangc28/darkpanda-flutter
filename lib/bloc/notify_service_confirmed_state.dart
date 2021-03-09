part of 'notify_service_confirmed_bloc.dart';

class NotifyServiceConfirmedState extends Equatable {
  const NotifyServiceConfirmedState._({
    this.confirmed,
    this.channelUUID,
  });

  const NotifyServiceConfirmedState.init()
      : this._(
          confirmed: false,
        );

  const NotifyServiceConfirmedState.notifyConfirmed({
    String channelUUID,
  }) : this._(
          confirmed: true,
          channelUUID: channelUUID,
        );

  const NotifyServiceConfirmedState.clear()
      : this._(
          confirmed: false,
        );

  final bool confirmed;
  final String channelUUID;

  @override
  List<Object> get props => [
        confirmed,
        channelUUID,
      ];
}
