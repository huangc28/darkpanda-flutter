import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../models/user_profile.dart';

part 'load_user_event.dart';
part 'load_user_state.dart';

class LoadUserBloc extends Bloc<LoadUserEvent, LoadUserState> {
  LoadUserBloc({this.userApis})
      : assert(userApis != null),
        super(LoadUserState.initial());

  final UserApis userApis;

  @override
  Stream<LoadUserState> mapEventToState(
    LoadUserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState(event);
    }
  }

  Stream<LoadUserState> _mapLoadUserToState(LoadUser event) async* {
    try {
      yield LoadUserState.loading();

      final jwt = await SecureStore().fsc.read(key: 'jwt');

      userApis.jwtToken = jwt;
      final resp = await userApis.fetchUser(event.uuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userProfile = UserProfile.fromJson(
        json.decode(resp.body),
      );

      yield LoadUserState.loaded(
        userProfile: userProfile,
      );
    } on APIException catch (e) {
      yield LoadUserState.loadFailed(e);
    } catch (e) {
      yield LoadUserState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
