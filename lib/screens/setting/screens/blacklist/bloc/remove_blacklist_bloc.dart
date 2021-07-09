import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';

part 'remove_blacklist_event.dart';
part 'remove_blacklist_state.dart';

class RemoveBlacklistBloc
    extends Bloc<RemoveBlacklistEvent, RemoveBlacklistState> {
  RemoveBlacklistBloc({this.blacklistApiClient})
      : assert(blacklistApiClient != null),
        super(RemoveBlacklistState.initial());

  final BlacklistApiClient blacklistApiClient;

  @override
  Stream<RemoveBlacklistState> mapEventToState(
    RemoveBlacklistEvent event,
  ) async* {
    if (event is RemoveBlacklist) {
      yield* _mapRemoveBlacklistEventToState(event);
    }
  }

  Stream<RemoveBlacklistState> _mapRemoveBlacklistEventToState(
      RemoveBlacklist event) async* {
    try {
      // toggle loading
      yield RemoveBlacklistState.loading(state);

      // request API
      final res = await blacklistApiClient.removeBlacklistUser(
        event.blockeeUuid,
      );

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield RemoveBlacklistState.loaded();
    } on APIException catch (err) {
      yield RemoveBlacklistState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield RemoveBlacklistState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
