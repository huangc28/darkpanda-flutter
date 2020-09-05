import 'dart:async';
import 'package:flutter/material.dart';

import 'submit_result.dart';
import '../apis.dart' as apis;

class RegisterEvent {
  String username;
  String gender;
  String referalCode;

  RegisterEvent({
    @required this.username,
    @required this.gender,
    @required this.referalCode,
  });
}

class SubmitBloc {
  String _username;
  String _gender;
  String _referalCode;

  /// Handles submit form emitted from the client.
  final _registerStateController = StreamController<RegisterEvent>();

  /// Handles submitted result from the backend
  final _responseBloc = SubmitResult();

  Sink<RegisterEvent> get registerSink => _registerStateController.sink;

  SubmitBloc() {
    _registerStateController.stream.listen(_register);
  }

  _register(RegisterEvent evt) async {
    print(
        'DEBUG 1 register form ${evt.username} ${evt.gender} ${evt.referalCode}');

    // Emit different event based on different status code
    final resp = await apis.createNewUser(
      username: evt.username,
      gender: evt.gender,
      referalCode: evt.referalCode,
    );

    print('DEBUG 8 ${resp.body}');

    if (resp.statusCode != 200) {
      _responseBloc.registerFailedSink.add(RegisterFailedEvent(
        error: 'failed to create user',
      ));

      return;
    }

    _responseBloc.submitResultSink.add(resp);
  }

  void dispose() {
    _registerStateController.close();
  }
}
