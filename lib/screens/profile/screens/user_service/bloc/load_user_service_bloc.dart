import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/services/user_service_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';

part 'load_user_service_event.dart';
part 'load_user_service_state.dart';

class LoadUserServiceBloc
    extends Bloc<LoadUserServiceEvent, LoadUserServiceState> {
  LoadUserServiceBloc({this.userServiceApiClient})
      : assert(userServiceApiClient != null),
        super(LoadUserServiceState.initial());

  final UserServiceApiClient userServiceApiClient;

  @override
  Stream<LoadUserServiceState<AppBaseException>> mapEventToState(
      LoadUserServiceEvent event) async* {
    if (event is LoadUserService) {
      yield* _mapLoadUserServiceToState(event);
    } else if (event is ClearUserServiceState) {
      yield* _mapClearUserServiceToState(event);
    }
  }

  Stream<LoadUserServiceState> _mapLoadUserServiceToState(
      LoadUserService event) async* {
    try {
      yield LoadUserServiceState.loading();

      final resp = await userServiceApiClient.fetchUserService(event.uuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userServices = UserServiceListResponse.fromMap(
        json.decode(resp.body),
      );

      yield LoadUserServiceState.loaded(
        userServiceListResponse: userServices,
      );
    } on APIException catch (e) {
      yield LoadUserServiceState.loadFailed(e);
    } catch (e) {
      yield LoadUserServiceState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadUserServiceState> _mapClearUserServiceToState(
      ClearUserServiceState event) async* {
    yield LoadUserServiceState.clearState();
  }
}
