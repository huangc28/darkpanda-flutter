import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/models/load_cancel_service_response.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';

part 'load_cancel_service_event.dart';
part 'load_cancel_service_state.dart';

class LoadCancelServiceBloc
    extends Bloc<LoadCancelServiceEvent, LoadCancelServiceState> {
  LoadCancelServiceBloc({
    this.serviceAPIs,
  })  : assert(serviceAPIs != null),
        super(LoadCancelServiceState.initial());

  final ServiceAPIs serviceAPIs;

  @override
  Stream<LoadCancelServiceState> mapEventToState(
    LoadCancelServiceEvent event,
  ) async* {
    if (event is LoadCancelService) {
      yield* _mapCancelServiceToState(event);
    }
  }

  Stream<LoadCancelServiceState> _mapCancelServiceToState(
      LoadCancelService event) async* {
    try {
      yield LoadCancelServiceState.loading(state);

      final resp = await serviceAPIs.loadCancelService(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final LoadCancelServiceResponse loadCancelServiceResponse =
          LoadCancelServiceResponse.fromMap(
        json.decode(resp.body),
      );

      yield LoadCancelServiceState.loaded(
        state,
        loadCancelServiceResponse: loadCancelServiceResponse,
      );
    } on APIException catch (e) {
      yield LoadCancelServiceState.loadFailed(e);
    } catch (e) {
      yield LoadCancelServiceState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
