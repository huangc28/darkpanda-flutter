import 'dart:async';
import 'package:flutter/material.dart';

import 'submit_result.dart';

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

    Map<String, dynamic> mockedResponse = {
      'status': 200,
    };

    final resp = await Future.delayed(Duration(seconds: 2)).then((v) {
      print('DEBUG 4');

      return mockedResponse;
    });

    print('DEBUG 5 $resp');

    _responseBloc.submitResultSink.add(resp);
  }

  void dispose() {
    _registerStateController.close();
  }
}
