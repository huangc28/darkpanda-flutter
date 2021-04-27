import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/recommend_detail.dart';

part 'load_general_recommend_event.dart';
part 'load_general_recommend_state.dart';

class LoadGeneralRecommendBloc
    extends Bloc<LoadGeneralRecommendEvent, LoadGeneralRecommendState> {
  LoadGeneralRecommendBloc({this.apiClient})
      : assert(apiClient != null),
        super(LoadGeneralRecommendState.initial());

  final RecommendAPIClient apiClient;

  @override
  Stream<LoadGeneralRecommendState> mapEventToState(
    LoadGeneralRecommendEvent event,
  ) async* {
    if (event is LoadGeneralRecommend) {
      yield* _mapLoadGeneralRecommendEventToState(event);
    }
  }

  Stream<LoadGeneralRecommendState> _mapLoadGeneralRecommendEventToState(
      LoadGeneralRecommend event) async* {
    try {
      // toggle loading
      yield LoadGeneralRecommendState.loading(state);

      // request API
      final res = await apiClient.fetchGeneralRecommend(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadGeneralRecommendState.loaded(
        recommendDetail: RecommendDetail.fromJson(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadGeneralRecommendState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadGeneralRecommendState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
