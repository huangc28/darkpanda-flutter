import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../apis.dart';

part 'verify_referral_code_event.dart';
part 'verify_referral_code_state.dart';

class VerifyReferralCodeBloc
    extends Bloc<VerifyReferralCodeEvent, VerifyReferralCodeState> {
  VerifyReferralCodeBloc() : super(VerifyReferralCodeState.initial());

  @override
  Stream<VerifyReferralCodeState> mapEventToState(
    VerifyReferralCodeEvent event,
  ) async* {
    if (event is VerifyReferralCodeEvent) {
      yield* _mapVerifyReferralCodeToState(event);
    }
  }

  Stream<VerifyReferralCodeState> _mapVerifyReferralCodeToState(
      VerifyReferralCodeEvent evt) async* {
    Map<String, Exception> _errorMap = {
      'username_exception': null,
    };

    try {
      yield VerifyReferralCodeState.loading();

      final apis = VerifyRegisterInfoAPIs();

      final verUsernameResp = await apis.verifyUsername(evt.username);

      if (verUsernameResp.statusCode != HttpStatus.ok) {
        _errorMap['username_exception'] = APIException.fromJson(
          json.decode(verUsernameResp.body),
        );
      }

      // If exception exists in either one of the key, throw an exception
      if (_errorMap['username_exception'] != null) {
        yield VerifyReferralCodeState.error(
          verifyUsernameError: _errorMap['username_exception'],
        );

        return;
      }

      yield VerifyReferralCodeState.done();
    } on Exception catch (e) {
      yield VerifyReferralCodeState.error(
        verifyUsernameError: _errorMap['username_exception'],
      );
    }
  }
}
