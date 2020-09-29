import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';

import '../services/auth_api_client.dart';

part 'verify_login_code_event.dart';
part 'verify_login_code_state.dart';

class VerifyLoginCodeBloc
    extends Bloc<VerifyLoginCodeEvent, VerifyLoginCodeState> {
  VerifyLoginCodeBloc({
    this.authAPIClient,
    this.userApis,
    this.authUserBloc,
  })  : assert(authAPIClient != null),
        assert(userApis != null),
        assert(authUserBloc != null),
        super(VerifyLoginCodeState.initial());

  final AuthAPIClient authAPIClient;
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

      final response = await authAPIClient.sendVerifyLogigCode(
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
      userApis.jwtToken = responseMap['jwt'];
      final fetchUserResp = await userApis.fetchUser();

      if (fetchUserResp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(response.body),
        );
      }

      authUserBloc.add(
        PutUser(
          authUser: AuthUser.copyFrom(
            AuthUser.fromJson(json.decode(fetchUserResp.body)),
            jwt: responseMap['jwt'],
          ),
        ),
      );

      yield VerifyLoginCodeState.verified();
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
