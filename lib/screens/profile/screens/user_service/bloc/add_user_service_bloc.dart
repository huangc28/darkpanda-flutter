import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/services/user_service_api_client.dart';

part 'add_user_service_event.dart';
part 'add_user_service_state.dart';

class AddUserServiceBloc
    extends Bloc<AddUserServiceEvent, AddUserServiceState> {
  AddUserServiceBloc({
    this.userServiceApiClient,
  }) : super(AddUserServiceState.initial());

  final UserServiceApiClient userServiceApiClient;

  @override
  Stream<AddUserServiceState> mapEventToState(
    AddUserServiceEvent event,
  ) async* {
    if (event is AddUserService) {
      yield* _mapAddUserServiceToState(event);
    }
  }

  Stream<AddUserServiceState> _mapAddUserServiceToState(
      AddUserService event) async* {
    try {
      yield AddUserServiceState.loading();

      final resp = await userServiceApiClient.createUserService(
        event.name,
        event.description,
        event.price,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield AddUserServiceState.done();
    } on APIException catch (e) {
      yield AddUserServiceState.error(e);
    } catch (e) {
      yield AddUserServiceState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
