import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';

part 'mobile_verify_event.dart';
part 'mobile_verify_state.dart';

class MobileVerifyBloc extends Bloc<MobileVerifyEvent, MobileVerifyState> {
  MobileVerifyBloc({
    this.dataProvider,
    this.authUserBloc,
    this.userApis,
  })  : assert(dataProvider != null),
        assert(userApis != null),
        assert(authUserBloc != null),
        super(MobileVerifyState.initial());

  final VerifyRegisterCodeAPIs dataProvider;
  final AuthUserBloc authUserBloc;
  final UserApis userApis;

  @override
  Stream<MobileVerifyState> mapEventToState(
    MobileVerifyEvent event,
  ) async* {
    if (event is VerifyMobile) {
      yield* _mapVerifyMobileToState(event);
    }
  }

  Stream<MobileVerifyState> _mapVerifyMobileToState(VerifyMobile event) async* {
    try {
      // toggles loading
      yield MobileVerifyState.loading(MobileVerifyState.copyFrom(state));

      // send request
      final resp = await dataProvider.verifyRegisterCode(
        mobile: event.mobileNumber,
        uuid: event.uuid,
        verifyCode: '${event.verifyChars}-${event.verifyDigs}',
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      // If mobile is verified, fetch auth user information.
      // Store jwt token in the security store before fetch user info.
      final respMap = json.decode(resp.body);

      await SecureStore().writeJwtToken(respMap['jwt']);

      // store auth user jwt
      yield MobileVerifyState.done(
        MobileVerifyState.copyFrom(
          state,
          authToken: respMap['jwt'],
        ),
      );

      final authUserInfo = await userApis.fetchMe();

      authUserBloc.add(
        PutUser(
          authUser: AuthUser.copyFrom(
            AuthUser.fromJson(json.decode(authUserInfo.body)),
            jwt: respMap['jwt'],
          ),
        ),
      );
    } on APIException catch (e) {
      yield MobileVerifyState.error(
          MobileVerifyState.copyFrom(state, error: e));
    } catch (e) {
      yield MobileVerifyState.error(
        MobileVerifyState.copyFrom(state,
            error: AppGeneralExeption(message: e.toString())),
      );
    }
  }
}
