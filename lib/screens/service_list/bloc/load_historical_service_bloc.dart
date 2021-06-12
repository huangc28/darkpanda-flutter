import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../models/historical_service.dart';
import '../services/service_chatroom_api.dart';

part 'load_historical_service_event.dart';
part 'load_historical_service_state.dart';

class LoadHistoricalServiceBloc
    extends Bloc<LoadHistoricalServiceEvent, LoadHistoricalServiceState> {
  LoadHistoricalServiceBloc({
    this.apiClient,
  }) : super(LoadHistoricalServiceState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<LoadHistoricalServiceState> mapEventToState(
    LoadHistoricalServiceEvent event,
  ) async* {
    if (event is LoadHistoricalService) {
      yield* _mapLoadHistoricalServiceEventToState(event);
    } else if (event is ClearHistoricalServiceState) {
      yield* _mapClearIncomingServiceStateToState(event);
    }
  }

  Stream<LoadHistoricalServiceState> _mapLoadHistoricalServiceEventToState(
      LoadHistoricalService event) async* {
    try {
      // toggle loading
      yield LoadHistoricalServiceState.loading(state);

      // request API
      final res = await apiClient.fetchOverdueService();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(res.body);

      final serviceList = respMap['services'].map<HistoricalService>((v) {
        return HistoricalService.fromMap(v);
      }).toList();

      yield LoadHistoricalServiceState.loadSuccess(
        state,
        services: [...serviceList],
      );
    } on APIException catch (err) {
      yield LoadHistoricalServiceState.loadFailed(state, err);
    } catch (err) {
      yield LoadHistoricalServiceState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadHistoricalServiceState> _mapClearIncomingServiceStateToState(
      ClearHistoricalServiceState event) async* {
    yield LoadHistoricalServiceState.clearState(state);
  }
}
