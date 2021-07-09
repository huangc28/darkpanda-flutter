import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/models/rate_detail.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import '../../../services/service_chatroom_api.dart';

part 'load_rate_detail_event.dart';
part 'load_rate_detail_state.dart';

class LoadRateDetailBloc
    extends Bloc<LoadRateDetailEvent, LoadRateDetailState> {
  LoadRateDetailBloc({
    this.apiClient,
  }) : super(LoadRateDetailState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<LoadRateDetailState> mapEventToState(
    LoadRateDetailEvent event,
  ) async* {
    if (event is LoadRateDetail) {
      yield* _mapLoadRateDetailEventToState(event);
    }
  }

  Stream<LoadRateDetailState> _mapLoadRateDetailEventToState(
      LoadRateDetail event) async* {
    try {
      // toggle loading
      yield LoadRateDetailState.loading(state);

      // request API
      final res = await apiClient.fetchRateDetail(event.serviceUuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadRateDetailState.loadSuccess(state,
          rateDetail: RateDetail.fromJson(
            json.decode(res.body),
          ));
    } on APIException catch (err) {
      print(err);
      yield LoadRateDetailState.loadFailed(state, err);
    } catch (err) {
      print(err);
      yield LoadRateDetailState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
