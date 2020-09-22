import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';

import '../services/data_provider.dart';

part 'mobile_verify_event.dart';
part 'mobile_verify_state.dart';

class MobileVerifyBloc extends Bloc<MobileVerifyEvent, MobileVerifyState> {
  final PhoneVerifyDataProvider dataProvider;
  final AuthUserBloc authUserBloc;

  MobileVerifyBloc({this.dataProvider, this.authUserBloc})
      : assert(dataProvider != null),
        assert(authUserBloc != null),
        super(MobileVerifyState.unknown());

  @override
  Stream<MobileVerifyState> mapEventToState(
    MobileVerifyEvent event,
  ) async* {
    if (event is VerifyMobile) {
      try {
        // toggles loading
        yield MobileVerifyState.verifying(MobileVerifyState.copyFrom(state));

        final verifyCode = '${event.prefix}-${event.suffix}';

        // send request
        final resp = await dataProvider.verifyMobile(
          uuid: event.uuid,
          verifyCode: verifyCode,
        );

        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        final parsed = json.decode(resp.body);

        // store auth user jwt
        authUserBloc.add(PatchJwt(jwt: parsed['jwt']));

        yield MobileVerifyState.verified(
          MobileVerifyState.copyFrom(
            state,
            authToken: parsed['jwt'],
          ),
        );
      } on APIException catch (e) {
        yield MobileVerifyState.verifyFailed(
            MobileVerifyState.copyFrom(state, error: e));
      } catch (e) {
        yield MobileVerifyState.verifyFailed(
          MobileVerifyState.copyFrom(state,
              error: AppGeneralExeption(message: e.toString())),
        );
      }
    }
  }
}