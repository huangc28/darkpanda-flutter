import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/pkg/fibonacci.dart';

import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/models/send_change_mobile_response.dart';
import '../services/change_mobile_apis.dart';

part 'send_change_mobile_event.dart';
part 'send_change_mobile_state.dart';

class SendChangeMobileBloc
    extends Bloc<SendChangeMobileEvent, SendChangeMobileState> {
  SendChangeMobileBloc({
    this.changeMobileClient,
    this.timerBloc,
  })  : assert(changeMobileClient != null),
        assert(timerBloc != null),
        super(SendChangeMobileState.initial(1));

  final ChangeMobileClient changeMobileClient;
  final TimerBloc timerBloc;

  @override
  Stream<SendChangeMobileState> mapEventToState(
    SendChangeMobileEvent event,
  ) async* {
    if (event is SendChangeMobile) {
      yield* _mapVerifyBankToState(event);
    }
  }

  Stream<SendChangeMobileState> _mapVerifyBankToState(
      SendChangeMobile event) async* {
    try {
      yield SendChangeMobileState.loading(state);

      final resp = await changeMobileClient.sendChangeMobile(event.mobile);

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      final sendChangeMobileResponse = SendChangeMobileResponse.fromMap(
        json.decode(resp.body),
      );
      final currNumSend = state.numSend;

      yield SendChangeMobileState.done(
        state,
        sendChangeMobileResponse: sendChangeMobileResponse,
        numSend: currNumSend + 1,
      );

      // If user intends to send login verify code more than 1 times, we generate
      // cooldown countdown to throttle the resend.
      if (currNumSend > 0) {
        timerBloc.add(
          StartTimer(
            duration: Fib.genFib(currNumSend) * Duration.secondsPerMinute,
          ),
        );
      }
    } on APIException catch (e) {
      yield SendChangeMobileState.error(state, error: e);
    } on Exception catch (e) {
      yield SendChangeMobileState.error(state, error: e);
    }
  }
}
