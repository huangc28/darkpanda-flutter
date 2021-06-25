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

part 'scan_service_qrcode_event.dart';
part 'scan_service_qrcode_state.dart';

class ScanServiceQrCodeBloc
    extends Bloc<ScanServiceQrCodeEvent, ScanServiceQrCodeState> {
  ScanServiceQrCodeBloc({this.serviceQrCodeApis})
      : assert(serviceQrCodeApis != null),
        super(ScanServiceQrCodeState.initial());

  final ServiceQrCodeAPIs serviceQrCodeApis;

  @override
  Stream<ScanServiceQrCodeState> mapEventToState(
    ScanServiceQrCodeEvent event,
  ) async* {
    if (event is ScanServiceQrCode) {
      yield* _mapScanServiceQrCodeToState(event);
    }
  }

  Stream<ScanServiceQrCodeState> _mapScanServiceQrCodeToState(
      ScanServiceQrCode event) async* {
    try {
      yield ScanServiceQrCodeState.loading();

      final resp = await serviceQrCodeApis.scanServiceQrCode(event.scanQrCode);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final serviceQrCode = ServiceQrCode.fromJson(
        json.decode(resp.body),
      );

      yield ScanServiceQrCodeState.loaded(
        serviceQrCode: serviceQrCode,
      );
    } on APIException catch (e) {
      yield ScanServiceQrCodeState.loadFailed(e);
    } catch (e) {
      yield ScanServiceQrCodeState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
