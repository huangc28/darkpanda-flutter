import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/message.dart';

part 'payment_complete_notifier_event.dart';
part 'payment_complete_notifier_state.dart';

class PaymentCompleteNotifierBloc
    extends Bloc<PaymentCompleteNotifierEvent, PaymentCompleteNotifierState> {
  PaymentCompleteNotifierBloc() : super(PaymentCompleteNotifierInitial());

  @override
  Stream<PaymentCompleteNotifierState> mapEventToState(
    PaymentCompleteNotifierEvent event,
  ) async* {
    yield PaymentCompletedNotify(event.message);
  }
}
