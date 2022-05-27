import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/service_details.dart';

// TODO move to chatroom services directory
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';

part 'load_service_detail_event.dart';
part 'load_service_detail_state.dart';

class LoadServiceDetailBloc
    extends Bloc<LoadServiceDetailEvent, LoadServiceDetailState> {
  LoadServiceDetailBloc({this.serviceAPIs})
      : assert(serviceAPIs != null),
        super(LoadServiceDetailState.initial());

  final ServiceAPIs serviceAPIs;

  @override
  Stream<LoadServiceDetailState> mapEventToState(
    LoadServiceDetailEvent event,
  ) async* {
    if (event is LoadServiceDetail) {
      yield* _mapLoadServiceQrCodeToState(event);
    } else if (event is ClearServiceDetailState) {
      yield* _mapClearServiceQrCodeStateToState(event);
    }
  }

  Stream<LoadServiceDetailState> _mapLoadServiceQrCodeToState(
      LoadServiceDetail event) async* {
    try {
      yield LoadServiceDetailState.loading();

      final resp = await serviceAPIs.fetchServiceDetail(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final serviceDetails = ServiceDetails.fromMap(
        json.decode(resp.body),
      );

      yield LoadServiceDetailState.loaded(
        serviceDetails: serviceDetails,
      );
    } on APIException catch (e) {
      yield LoadServiceDetailState.loadFailed(e);
    } catch (e) {
      yield LoadServiceDetailState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadServiceDetailState> _mapClearServiceQrCodeStateToState(
      ClearServiceDetailState event) async* {
    yield LoadServiceDetailState.clearState();
  }
}
