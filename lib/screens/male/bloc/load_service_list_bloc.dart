import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/service_list.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/dp_package.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'load_service_list_event.dart';
part 'load_service_list_state.dart';

class LoadServiceListBloc
    extends Bloc<LoadServiceListEvent, LoadServiceListState> {
  LoadServiceListBloc({
    this.searchInquiryAPIs,
  }) : super(LoadServiceListState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<LoadServiceListState> mapEventToState(
    LoadServiceListEvent event,
  ) async* {
    if (event is LoadServiceList) {
      yield* _mapLoadMyDpEventToState(event);
    } else if (event is ClearServiceListState) {
      yield* _mapClearMyDpStateToState(event);
    }
  }

  Stream<LoadServiceListState> _mapLoadMyDpEventToState(
      LoadServiceList event) async* {
    try {
      // toggle loading
      yield LoadServiceListState.loading(state);

      // request API
      final res = await searchInquiryAPIs.fetchServiceList();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadServiceListState.loaded(
        serviceList: ServiceList.fromMap(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadServiceListState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadServiceListState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadServiceListState> _mapClearMyDpStateToState(
      ClearServiceListState event) async* {
    yield LoadServiceListState.clearState();
  }
}
