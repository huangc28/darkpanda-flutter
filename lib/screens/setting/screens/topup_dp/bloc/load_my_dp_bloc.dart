import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/my_dp.dart';

part 'load_my_dp_event.dart';
part 'load_my_dp_state.dart';

class LoadMyDpBloc extends Bloc<LoadMyDpEvent, LoadMyDpState> {
  LoadMyDpBloc({
    this.apiClient,
  }) : super(LoadMyDpState.initial());

  final TopUpClient apiClient;

  @override
  Stream<LoadMyDpState> mapEventToState(
    LoadMyDpEvent event,
  ) async* {
    if (event is LoadMyDp) {
      yield* _mapLoadMyDpEventToState(event);
    } else if (event is ClearMyDpState) {
      yield* _mapClearMyDpStateToState(event);
    }
  }

  Stream<LoadMyDpState> _mapLoadMyDpEventToState(LoadMyDp event) async* {
    try {
      // toggle loading
      yield LoadMyDpState.loading(state);

      // request API
      final res = await apiClient.fetchMyDp();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadMyDpState.loaded(
        myDp: MyDp.fromJson(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadMyDpState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadMyDpState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadMyDpState> _mapClearMyDpStateToState(ClearMyDpState event) async* {
    yield LoadMyDpState.clearState();
  }
}
