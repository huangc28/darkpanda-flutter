import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/register_api_client.dart';
import '../models/registered_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    this.registerAPI,
  }) : super(RegisterState.initial());

  final RegisterAPIClient registerAPI;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      yield* _mapRegisterToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterToState(Register event) async* {
    try {
      yield RegisterState.loading();

      final resp = await registerAPI.register(
        username: event.username,
        gender: event.gender,
        refCode: event.referalcode,
      );

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield RegisterState.done(
        RegisteredUser.fromJson(
          json.decode(resp.body),
        ),
      );
    } on APIException catch (e) {
      yield RegisterState.error(e);
    } catch (e) {
      yield RegisterState.error(new AppGeneralExeption(message: e.toString()));
    }
  }
}
