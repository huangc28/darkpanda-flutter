import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/dp_package.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';

part 'load_dp_package_event.dart';
part 'load_dp_package_state.dart';

class LoadDpPackageBloc extends Bloc<LoadDpPackageEvent, LoadDpPackageState> {
  LoadDpPackageBloc({
    this.apiClient,
  }) : super(LoadDpPackageState.initial());

  final TopUpClient apiClient;

  @override
  Stream<LoadDpPackageState> mapEventToState(
    LoadDpPackageEvent event,
  ) async* {
    if (event is LoadDpPackage) {
      yield* _mapLoadMyDpEventToState(event);
    } else if (event is ClearDpPackageState) {
      yield* _mapClearMyDpStateToState(event);
    }
  }

  Stream<LoadDpPackageState> _mapLoadMyDpEventToState(
      LoadDpPackage event) async* {
    try {
      // toggle loading
      yield LoadDpPackageState.loading(state);

      // request API
      final res = await apiClient.fetchDpPackage();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadDpPackageState.loaded(
        dpPackageList: DpPackageList.fromJson(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadDpPackageState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadDpPackageState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadDpPackageState> _mapClearMyDpStateToState(
      ClearDpPackageState event) async* {
    yield LoadDpPackageState.clearState();
  }
}
