import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/message.dart';

part 'service_confirm_notifier_event.dart';
part 'service_confirm_notifier_state.dart';

class ServiceConfirmNotifierBloc
    extends Bloc<ServiceConfirmNotifierEvent, ServiceConfirmNotifierState> {
  ServiceConfirmNotifierBloc() : super(ServiceConfirmNotifierInitial());

  @override
  Stream<ServiceConfirmNotifierState> mapEventToState(
    ServiceConfirmNotifierEvent event,
  ) async* {
    print('DEBUG trigger ServiceConfirmNotifierBloc');

    yield ServiceConfirmedNotify(event.message);
  }
}
