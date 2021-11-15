import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/profile/services/user_service_api_client.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'remove_user_service_event.dart';
part 'remove_user_service_state.dart';

class RemoveUserServiceBloc
    extends Bloc<RemoveUserServiceEvent, RemoveUserServiceState> {
  RemoveUserServiceBloc({
    this.userServiceApiClient,
  }) : super(RemoveUserServiceState.initial());

  final UserServiceApiClient userServiceApiClient;

  @override
  Stream<RemoveUserServiceState> mapEventToState(
    RemoveUserServiceEvent event,
  ) async* {
    if (event is RemoveUserService) {
      yield* _mapRemoveUserServiceToState(event);
    }
  }

  Stream<RemoveUserServiceState> _mapRemoveUserServiceToState(
      RemoveUserService event) async* {
    try {
      yield RemoveUserServiceState.loading();

      final resp =
          await userServiceApiClient.deleteUserService(event.serviceOptionId);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield RemoveUserServiceState.done();
    } on APIException catch (e) {
      yield RemoveUserServiceState.error(e);
    } catch (e) {
      yield RemoveUserServiceState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
