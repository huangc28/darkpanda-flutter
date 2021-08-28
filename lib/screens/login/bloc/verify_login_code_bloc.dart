import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';

import '../services/login_api_client.dart';

part 'verify_login_code_event.dart';
part 'verify_login_code_state.dart';

class VerifyLoginCodeBloc
    extends Bloc<VerifyLoginCodeEvent, VerifyLoginCodeState> {
  VerifyLoginCodeBloc({
    this.loginAPIClient,
    this.userApis,
    this.authUserBloc,
  })  : assert(loginAPIClient != null),
        assert(userApis != null),
        assert(authUserBloc != null),
        super(VerifyLoginCodeState.initial());

  final LoginAPIClient loginAPIClient;
  final UserApis userApis;
  final AuthUserBloc authUserBloc;

  @override
  Stream<VerifyLoginCodeState> mapEventToState(
    VerifyLoginCodeEvent event,
  ) async* {
    if (event is SendVerifyLoginCode) {
      yield* _mapSendVerifyLoginCodeToState(event);
    }
  }

  Stream<VerifyLoginCodeState> _mapSendVerifyLoginCodeToState(
      SendVerifyLoginCode event) async* {
    try {
      yield VerifyLoginCodeState.verifying();

      final response = await loginAPIClient.verifyLoginCode(
        uuid: event.uuid,
        verifyChars: event.verifyChars,
        verifyDigs: event.verifyDigs,
        mobile: event.mobile,
      );

      if (response.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(response.body),
        );
      }

      final responseMap = json.decode(response.body);

      // fetch auth user info
      await SecureStore().writeJwtToken(responseMap['jwt']);

      final fetchUserResp = await userApis.fetchMe();

      developer.log('DEBUG fetchUserResp ${fetchUserResp.body}');

      if (fetchUserResp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(fetchUserResp.body),
        );
      }

      final authUser = AuthUser.copyFrom(
        AuthUser.fromJson(json.decode(fetchUserResp.body)),
        jwt: responseMap['jwt'],
      );

      await SecureStore().writeGender(authUser.gender.name);

      FirebaseMessagingService().fcmSubscribe(authUser.fcmTopic);

      authUserBloc.add(
        PutUser(
          authUser: authUser,
        ),
      );

      yield VerifyLoginCodeState.verified(
        gender: authUser.gender,
      );
    } on APIException catch (e) {
      yield VerifyLoginCodeState.verifyFailed(error: e);
    } catch (e) {
      yield VerifyLoginCodeState.verifyFailed(
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
