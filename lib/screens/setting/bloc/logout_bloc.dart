import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

import '../services/settings_apis.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({
    this.settingsApi,
    this.authUserBloc,
  }) : super(LogoutInitial());

  final SettingsAPIClient settingsApi;
  final AuthUserBloc authUserBloc;

  @override
  Stream<LogoutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    try {
      yield LoggingOut();

      // Request logout API.
      final resp = await settingsApi.logout();

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      // Remove jwt token.
      await SecureStore().delJwtToken();

      // Remove gender.
      await SecureStore().delGender();

      // Remove auth user info.
      authUserBloc.add(RemoveAuthUser());

      yield LoggedOut();
    } on APIException catch (e) {
      yield LoggedFailed(
        err: e,
      );
    } catch (e) {
      yield LoggedFailed(
        err: AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
