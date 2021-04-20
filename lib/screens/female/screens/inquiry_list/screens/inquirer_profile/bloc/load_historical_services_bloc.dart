import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import '../models/historical_service.dart';

part 'load_historical_services_event.dart';
part 'load_historical_services_state.dart';

class LoadHistoricalServicesBloc
    extends Bloc<LoadHistoricalServicesEvent, LoadHistoricalServicesState> {
  LoadHistoricalServicesBloc({this.userApi})
      : assert(userApi != null),
        super(LoadHistoricalServicesState.initial());

  final UserApis userApi;

  @override
  Stream<LoadHistoricalServicesState> mapEventToState(
    LoadHistoricalServicesEvent event,
  ) async* {
    if (event is LoadHistoricalServices) {
      yield* _mapLoadHistoricalServicesToState(event);
    }
  }

  Stream<LoadHistoricalServicesState> _mapLoadHistoricalServicesToState(
      LoadHistoricalServices event) async* {
    try {
      // toggle loading
      yield LoadHistoricalServicesState.loading(state);

      // request API
      final jwt = await SecureStore().readJwtToken();
      userApi.jwtToken = jwt;
      final res = await userApi.fetchUserHistoricalServices(
        event.uuid,
        event.offset,
      );

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final resMap = json.decode(res.body);

      yield LoadHistoricalServicesState.loaded(
        historicalServices: resMap['services']
            .map<HistoricalService>((data) => HistoricalService.fromMap(data))
            .toList(),
      );
    } on APIException catch (err) {
      yield LoadHistoricalServicesState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadHistoricalServicesState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
