import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/repository.dart';
import '../models/registered_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterRepository _registerRepository;

  RegisterBloc(this._registerRepository) : super(RegisterState.unknown());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      try {
        yield RegisterState.registering();

        final resp = await _registerRepository.createNewUser(
          username: event.username,
          gender: event.gender,
          referalCode: event.referalcode,
        );

        // if response status is not equal to 200, throw an exception.
        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        yield RegisterState.registered(
            RegisteredUser.fromJson(json.decode(resp.body)));
      } on APIException catch (e) {
        yield RegisterState.registerFailed(e);
      } catch (e) {
        yield RegisterState.registerFailed(
            new AppGeneralExeption(message: e.toString()));
      }
    }
  }
}
