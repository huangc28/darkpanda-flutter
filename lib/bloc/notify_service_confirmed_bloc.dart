import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notify_service_confirmed_event.dart';
part 'notify_service_confirmed_state.dart';

class NotifyServiceConfirmedBloc
    extends Bloc<NotifyServiceConfirmedEvent, NotifyServiceConfirmedState> {
  NotifyServiceConfirmedBloc() : super(NotifyServiceConfirmedState.init());

  @override
  Stream<NotifyServiceConfirmedState> mapEventToState(
    NotifyServiceConfirmedEvent event,
  ) async* {
    if (event is NotifyServiceConfirmed) {
      yield* _mapNotifyServiceConfirmedToState(event);
    }
    if (event is ClearNotify) {
      yield* _mapClearNotifyToState(event);
    }
  }

  Stream<NotifyServiceConfirmedState> _mapNotifyServiceConfirmedToState(
      NotifyServiceConfirmed event) async* {
    yield NotifyServiceConfirmedState.notifyConfirmed(
      channelUUID: event.channelUUID,
    );
  }

  Stream<NotifyServiceConfirmedState> _mapClearNotifyToState(
      ClearNotify event) async* {
    yield NotifyServiceConfirmedState.clear();
  }
}
