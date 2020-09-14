import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

import '../services/apis.dart';
import '../pkg/secure_store.dart';
import '../models/auth_user.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final UserApis dataProvider;

  AuthUserBloc({this.dataProvider}) : super(AuthUserState.initial());

  @override
  Stream<AuthUserState> mapEventToState(
    AuthUserEvent event,
  ) async* {
    if (event is PatchJwt) {
      // store jwt in secure storage
      yield* _mapPatchJwtToState(event);
    }

    if (event is FetchUserInfo) {
      yield* _mapUserInfoToState(event);
    }
  }

  Stream<AuthUserState> _mapPatchJwtToState(PatchJwt event) async* {
    // store jwt to security store.
    await SecureStore().fsc.write(
          key: 'jwt',
          value: event.jwt,
        );

    yield AuthUserState.patchUser(AuthUserState.copyFrom(
      state,
      user: AuthUser.copyFrom(
        state.user,
        jwt: event.jwt,
      ),
    ));

    add(FetchUserInfo());
  }

  // TODOs
  //  - update user information
  //  - handle error
  Stream<AuthUserState> _mapUserInfoToState(FetchUserInfo event) async* {
    try {
      // retrieve user info
      final jwt = await SecureStore().fsc.read(key: 'jwt');

      print('DEBUG _mapUserInfoToState 1 $jwt');

      dataProvider.jwtToken = jwt;
      final resp = await dataProvider.fetchUser();

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      // update auth user info
      yield AuthUserState.fetchSuccess(AuthUserState.copyFrom(
        state,
        user: AuthUser.fromJson(json.decode(resp.body)),
      ));
    } on APIException catch (e) {
      // yield AuthUserState
      yield AuthUserState.fetchFailed(AuthUserState.copyFrom(state, error: e));
    } catch (e) {
      yield AuthUserState.fetchFailed(AuthUserState.copyFrom(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      ));
    }
  }
}
