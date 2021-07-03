import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/recommend_detail.dart';

part 'load_agent_recommend_event.dart';
part 'load_agent_recommend_state.dart';

class LoadAgentRecommendBloc
    extends Bloc<LoadAgentRecommendEvent, LoadAgentRecommendState> {
  LoadAgentRecommendBloc({this.apiClient})
      : assert(apiClient != null),
        super(LoadAgentRecommendState.initial());

  final RecommendAPIClient apiClient;

  @override
  Stream<LoadAgentRecommendState> mapEventToState(
    LoadAgentRecommendEvent event,
  ) async* {
    if (event is LoadAgentRecommend) {
      yield* _mapLoadAgentRecommendEventToState(event);
    }
  }

  Stream<LoadAgentRecommendState> _mapLoadAgentRecommendEventToState(
      LoadAgentRecommend event) async* {
    try {
      // toggle loading
      yield LoadAgentRecommendState.loading(state);

      // request API
      final res = await apiClient.fetchAgentRecommend(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadAgentRecommendState.loaded(
        recommendDetail: RecommendDetail.fromJson(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadAgentRecommendState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadAgentRecommendState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
