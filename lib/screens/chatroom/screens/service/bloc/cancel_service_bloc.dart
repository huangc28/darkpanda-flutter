import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';

part 'cancel_service_event.dart';
part 'cancel_service_state.dart';

class CancelServiceBloc extends Bloc<CancelServiceEvent, CancelServiceState> {
  CancelServiceBloc({
    this.serviceAPIs,
    this.loadIncomingServiceBloc,
  })  : assert(serviceAPIs != null),
        assert(loadIncomingServiceBloc != null),
        super(CancelServiceState.initial());

  final ServiceAPIs serviceAPIs;
  final LoadIncomingServiceBloc loadIncomingServiceBloc;

  @override
  Stream<CancelServiceState> mapEventToState(
    CancelServiceEvent event,
  ) async* {
    if (event is CancelService) {
      yield* _mapCancelServiceToState(event);
    }
  }

  Stream<CancelServiceState> _mapCancelServiceToState(
      CancelService event) async* {
    try {
      yield CancelServiceState.loading(state);

      final resp = await serviceAPIs.cancelService(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // To refresh incoming service list
      loadIncomingServiceBloc.add(LoadIncomingService());

      yield CancelServiceState.loaded(state);
    } on APIException catch (e) {
      yield CancelServiceState.loadFailed(e);
    } catch (e) {
      yield CancelServiceState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
