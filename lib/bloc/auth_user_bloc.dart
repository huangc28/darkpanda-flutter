import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

import '../services/user_apis.dart';
import '../pkg/secure_store.dart';
import '../models/auth_user.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  AuthUserBloc({
    AuthUser authUser,
    this.dataProvider,
  }) : super(
          AuthUserState.initial(
            authUser: authUser,
          ),
        );

  final UserApis dataProvider;

  @override
  Stream<AuthUserState> mapEventToState(
    AuthUserEvent event,
  ) async* {
    if (event is FetchUserInfo) {
      yield* _mapFetchUserInfoToState(event);
    }

    if (event is PutUser) {
      yield* _mapPutUserToState(event);
    }

    if (event is RemoveAuthUser) {
      yield* _mapRemoveUserToState();
    }
  }

  Stream<AuthUserState> _mapFetchUserInfoToState(FetchUserInfo event) async* {
    try {
      // retrieve user info
      final resp = await dataProvider.fetchMe();

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      // update auth user info
      yield AuthUserState.fetchSuccess(
        state,
        authUser: AuthUser.fromJson(
          json.decode(resp.body),
        ),
      );
    } on APIException catch (e) {
      // yield AuthUserState
      yield AuthUserState.fetchFailed(
        AuthUserState.copyFrom(state, error: e),
      );
    } catch (e) {
      yield AuthUserState.fetchFailed(
        AuthUserState.copyFrom(
          state,
          error: AppGeneralExeption(
            message: e.toString(),
          ),
        ),
      );
    }
  }

  Stream<AuthUserState> _mapPutUserToState(PutUser event) async* {
    yield AuthUserState.patchUser(
      state,
      user: event.authUser,
    );
  }

  Stream<AuthUserState> _mapRemoveUserToState() async* {
    yield AuthUserState.patchUser(
      state,
      user: null,
    );
  }
}
