import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'load_user_service_event.dart';
part 'load_user_service_state.dart';

class LoadUserServiceBloc
    extends Bloc<LoadUserServiceEvent, LoadUserServiceState> {
  LoadUserServiceBloc({this.rateApiClient})
      : assert(rateApiClient != null),
        super(LoadUserServiceState.initial());

  final RateApiClient rateApiClient;

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

      final resp = await rateApiClient.fetchUserRate(event.uuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userRatings = UserRatings.fromMap(
        json.decode(resp.body),
      );

      yield LoadUserServiceState.loaded(
        userRatings: userRatings,
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
