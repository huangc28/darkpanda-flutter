import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/screens/register/repository.dart';
import 'package:darkpanda_flutter/models/error.dart';

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
          throw (resp.body);
        }
        yield RegisterState.registered(
            RegisteredUser.fromJson(json.decode(resp.body)));
      } catch (e) {
        // transform error message to models. emit the error to bloc event
        var pe = Error.fromJson(json.decode(e.toString()));

        print('DEBUG pe ${pe.code} ${pe.message}');

        yield RegisterState.registerFailed(pe);
      }
    }
  }
}
