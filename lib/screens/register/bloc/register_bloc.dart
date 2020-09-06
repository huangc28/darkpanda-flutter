import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/screens/register/repository.dart';
import 'package:darkpanda_flutter/models/error.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterRepository _registerRepository;

  RegisterBloc(this._registerRepository) : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is Register) {
      try {
        yield Registering();

        final resp = await _registerRepository.createNewUser(
          username: event.username,
          gender: event.gender,
          referalCode: event.referalcode,
        );

        // if response status is not equal to 200, throw an exception.
        if (resp.statusCode != HttpStatus.ok) {
          throw (resp.body);
        }

        print('DEBUG register bloc ${resp.statusCode}, ${resp.body}');
      } catch (e) {
        // transform error message to models. emit the error to bloc event
        // yield RegisterFailed
        var pe = Error.fromJson(json.decode(e.toString()));

        yield RegisterFailed(
          message: pe.message,
          code: pe.code,
        );
      }
    }
  }
}
