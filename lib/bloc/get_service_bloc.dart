import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/service_apis.dart';
import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'get_service_event.dart';
part 'get_service_state.dart';

class GetServiceBloc extends Bloc<GetServiceEvent, GetServiceState> {
  GetServiceBloc({
    this.serviceApis,
  })  : assert(serviceApis != null),
        super(GetServiceState.init());

  final ServiceAPIs serviceApis;

  @override
  Stream<GetServiceState> mapEventToState(
    GetServiceEvent event,
  ) async* {
    if (event is GetService) {
      yield* _mapGetServiceToState(event);
    }
  }

  Stream<GetServiceState> _mapGetServiceToState(GetService event) async* {
    try {
      yield GetServiceState.loading(state);

      final resp =
          await serviceApis.fetchServiceByInquiryUUID(event.inquiryUUID);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final ServiceSettings serviceSettings = ServiceSettings.fromMap(
        json.decode(
          resp.body,
        ),
      );

      yield GetServiceState.loaded(serviceSettings);
    } on APIException catch (e) {
      yield GetServiceState.loadFailed(state, e);
    } on Exception catch (e) {
      yield GetServiceState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
