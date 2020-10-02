import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';

import '../services/data_provider.dart';

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
        super(MobileVerifyState.unknown());

  final PhoneVerifyDataProvider dataProvider;
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
      yield MobileVerifyState.verifying(MobileVerifyState.copyFrom(state));

      final verifyCode = '${event.prefix}-${event.suffix}';

      // send request
      final resp = await dataProvider.verifyMobile(
        mobile: event.mobileNumber,
        uuid: event.uuid,
        verifyCode: verifyCode,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      // If mobile is verified, fetch auth user information.
      final respMap = json.decode(resp.body);

      userApis.jwtToken = respMap['jwt'];
      final authUserInfo = await userApis.fetchUser();

      authUserBloc.add(
        PutUser(
          authUser: AuthUser.copyFrom(
            AuthUser.fromJson(json.decode(authUserInfo.body)),
            jwt: respMap['jwt'],
          ),
        ),
      );

      // store auth user jwt
      yield MobileVerifyState.verified(
        MobileVerifyState.copyFrom(
          state,
          authToken: respMap['jwt'],
        ),
      );

      print('DEBUG done verifying');
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
