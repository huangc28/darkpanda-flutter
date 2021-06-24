import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'load_rate_event.dart';
part 'load_rate_state.dart';

class LoadRateBloc extends Bloc<LoadRateEvent, LoadRateState> {
  LoadRateBloc({this.rateApiClient})
      : assert(rateApiClient != null),
        super(LoadRateState.initial());

  final RateApiClient rateApiClient;

  @override
  Stream<LoadRateState<AppBaseException>> mapEventToState(
      LoadRateEvent event) async* {
    if (event is LoadRate) {
      yield* _mapLoadRateToState(event);
    } else if (event is ClearRateState) {
      yield* _mapClearUserStateToState(event);
    }
  }

  Stream<LoadRateState> _mapLoadRateToState(LoadRate event) async* {
    try {
      yield LoadRateState.loading();

      // final jwt = await SecureStore().fsc.read(key: 'jwt');

      // rateApiClient.jwtToken = jwt;
      final resp = await rateApiClient.fetchUserRate(event.uuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userRatings = UserRatings.fromMap(
        json.decode(resp.body),
      );

      yield LoadRateState.loaded(
        userRatings: userRatings,
      );
    } on APIException catch (e) {
      yield LoadRateState.loadFailed(e);
    } catch (e) {
      yield LoadRateState.loadFailed(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Stream<LoadRateState> _mapClearUserStateToState(ClearRateState event) async* {
    yield LoadRateState.clearState();
  }
}
