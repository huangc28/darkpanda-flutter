import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/message.dart';

part 'service_start_notifier_event.dart';
part 'service_start_notifier_state.dart';

class ServiceStartNotifierBloc
    extends Bloc<ServiceStartNotifierEvent, ServiceStartNotifierState> {
  ServiceStartNotifierBloc() : super(ServiceStartNotifierInitial());

  @override
  Stream<ServiceStartNotifierState> mapEventToState(
    ServiceStartNotifierEvent event,
  ) async* {
    yield ServiceStartedNotify(event.message);
  }
}
