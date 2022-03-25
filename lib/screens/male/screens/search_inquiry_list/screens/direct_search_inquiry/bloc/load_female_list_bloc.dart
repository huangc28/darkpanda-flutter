import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/models/female_list.dart';
import 'package:darkpanda_flutter/util/util.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

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
      yield* _mapLoadFemaleListToState(event);
    } else if (event is LoadMoreFemaleList) {
      yield* _mapLoadMoreFemaleListToState(event);
    } else if (event is ClearFemaleListState) {
      yield* _mapClearUserStateToState(event);
    } else if (event is UpdateFemaleProfileInList) {
      yield* _mapUpdateFemaleProfileInList(event);
    }
  }

  Stream<LoadFemaleListState> _mapLoadFemaleListToState(
      LoadFemaleList event) async* {
    try {
      yield LoadFemaleListState.loading(state);
      yield LoadFemaleListState.initial();

      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await searchInquiryAPIs.fetchFemaleList(
        offset: offset,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final femaleUserList = FemaleUserList.fromJson(
        json.decode(resp.body),
      );

      yield LoadFemaleListState.loaded(
        state,
        femaleUsers: [...femaleUserList.femaleUsers],
        currentPage: state.currentPage + 1,
      );
    } on APIException catch (e) {
      yield LoadFemaleListState.loadFailed(state, e);
    } catch (e) {
      yield LoadFemaleListState.loadFailed(
        state,
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadFemaleListState> _mapLoadMoreFemaleListToState(
      LoadMoreFemaleList event) async* {
    try {
      final offset = calcNextPageOffset(
        nextPage: state.currentPage + 1,
        perPage: event.perPage,
      );

      final resp = await searchInquiryAPIs.fetchFemaleList(
        offset: offset,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);

      final femaleUsers = respMap['girls'].map<FemaleUser>((v) {
        return FemaleUser.fromMap(v);
      }).toList();

      final appended = <FemaleUser>[
        ...state.femaleUsers,
        ...?femaleUsers,
      ].toList();

      yield LoadFemaleListState.loaded(
        state,
        femaleUsers: appended,
        currentPage: state.currentPage + 1,
      );
    } on APIException catch (e) {
      yield LoadFemaleListState.loadFailed(state, e);
    } catch (e) {
      yield LoadFemaleListState.loadFailed(
        state,
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadFemaleListState> _mapClearUserStateToState(
      ClearFemaleListState event) async* {
    yield LoadFemaleListState.clearState(state);
  }

// NOTE: This bloc only updates female's `hasInquiry` status since this attribute is the only one that we need.
// We could added more attributes later on.
  Stream<LoadFemaleListState> _mapUpdateFemaleProfileInList(
      UpdateFemaleProfileInList event) async* {
    List<FemaleUser> newFemaleList = [];

    // Iterate current female list, update `hasInquiry` status.
    for (FemaleUser femaleInList in state.femaleUsers) {
      if (femaleInList.uuid == event.femaleUser.uuid) {
        newFemaleList.add(
          femaleInList.copyWith(
            hasInquiry: event.femaleUser.hasInquiry,
          ),
        );
      } else {
        newFemaleList.add(femaleInList);
      }
    }

    yield LoadFemaleListState.updateFemaleList(state,
        femaleUsers: newFemaleList);
  }
}
