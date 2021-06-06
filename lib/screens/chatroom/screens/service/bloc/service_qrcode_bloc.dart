import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/scan_qrcode.dart';
import 'package:darkpanda_flutter/models/service_qrcode.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_qrcode_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'service_qrcode_event.dart';
part 'service_qrcode_state.dart';

class ServiceQrCodeBloc extends Bloc<ServiceQrCodeEvent, ServiceQrCodeState> {
  ServiceQrCodeBloc({this.serviceQrCodeApis})
      : assert(serviceQrCodeApis != null),
        super(ServiceQrCodeState.initial());

  final ServiceQrCodeAPIs serviceQrCodeApis;

  @override
  Stream<ServiceQrCodeState> mapEventToState(
    ServiceQrCodeEvent event,
  ) async* {
    if (event is LoadServiceQrCode) {
      yield* _mapLoadServiceQrCodeToState(event);
    } else if (event is ScanServiceQrCode) {
      yield* _mapScanServiceQrCodeToState(event);
    } else if (event is ClearServiceQrCodeState) {
      yield* _mapClearServiceQrCodeStateToState(event);
    }
  }

  Stream<ServiceQrCodeState> _mapLoadServiceQrCodeToState(
      LoadServiceQrCode event) async* {
    try {
      yield ServiceQrCodeState.loading();

      final resp = await serviceQrCodeApis
          .fetchServiceQrCodeByServiceUUID(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final serviceQrCode = ServiceQrCode.fromJson(
        json.decode(resp.body),
      );

      yield ServiceQrCodeState.loaded(
        serviceQrCode: serviceQrCode,
      );
    } on APIException catch (e) {
      yield ServiceQrCodeState.loadFailed(e);
    } catch (e) {
      yield ServiceQrCodeState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<ServiceQrCodeState> _mapScanServiceQrCodeToState(
      ScanServiceQrCode event) async* {
    try {
      yield ServiceQrCodeState.loading();

      final resp = await serviceQrCodeApis.scanServiceQrCode(event.scanQrCode);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final serviceQrCode = ServiceQrCode.fromJson(
        json.decode(resp.body),
      );

      yield ServiceQrCodeState.loaded(
        serviceQrCode: serviceQrCode,
      );
    } on APIException catch (e) {
      yield ServiceQrCodeState.loadFailed(e);
    } catch (e) {
      yield ServiceQrCodeState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<ServiceQrCodeState> _mapClearServiceQrCodeStateToState(
      ClearServiceQrCodeState event) async* {
    yield ServiceQrCodeState.clearState();
  }
}
