import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/male/screens/direct_search_inquiry/models/female_list.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';

part 'load_female_list_event.dart';
part 'load_female_list_state.dart';

class LoadFemaleListBloc
    extends Bloc<LoadFemaleListEvent, LoadFemaleListState> {
  LoadFemaleListBloc({this.searchInquiryAPIs})
      : assert(searchInquiryAPIs != null),
        super(LoadFemaleListState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<LoadFemaleListState> mapEventToState(
    LoadFemaleListEvent event,
  ) async* {
    if (event is LoadFemaleList) {
      yield* _mapLoadUserToState(event);
    } else if (event is ClearFemaleListState) {
      yield* _mapClearUserStateToState(event);
    }
  }

  Stream<LoadFemaleListState> _mapLoadUserToState(LoadFemaleList event) async* {
    try {
      yield LoadFemaleListState.loading();

      final resp = await searchInquiryAPIs.fetchFemaleList();

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final femaleUserList = FemaleUserList.fromJson(
        json.decode(resp.body),
      );

      yield LoadFemaleListState.loaded(
        femaleUserList: femaleUserList,
      );
    } on APIException catch (e) {
      yield LoadFemaleListState.loadFailed(e);
    } catch (e) {
      yield LoadFemaleListState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadFemaleListState> _mapClearUserStateToState(
      ClearFemaleListState event) async* {
    yield LoadFemaleListState.clearState();
  }
}
