import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/blacklist_user.dart';

part 'load_blacklist_user_event.dart';
part 'load_blacklist_user_state.dart';

class LoadBlacklistUserBloc
    extends Bloc<LoadBlacklistUserEvent, LoadBlacklistUserState> {
  LoadBlacklistUserBloc({this.blacklistApiClient})
      : assert(blacklistApiClient != null),
        super(LoadBlacklistUserState.initial());

  final BlacklistApiClient blacklistApiClient;

  @override
  Stream<LoadBlacklistUserState> mapEventToState(
    LoadBlacklistUserEvent event,
  ) async* {
    if (event is LoadBlacklistUser) {
      yield* _mapLoadBlacklistUserToState(event);
    }
  }

  Stream<LoadBlacklistUserState> _mapLoadBlacklistUserToState(
      LoadBlacklistUser event) async* {
    try {
      // toggle loading
      yield LoadBlacklistUserState.loading(state);

      // request API
      final res = await blacklistApiClient.fetchBlacklistUser(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      // Normalize response with blacklist user model.
      final dataMap = json.decode(res.body);

      List<BlacklistUser> blacklistUser = [];

      if (dataMap.containsKey('blocked_users')) {
        blacklistUser =
            dataMap['blocked_users'].map<BlacklistUser>((blacklistUser) {
          return BlacklistUser.fromJson(blacklistUser);
        }).toList();
      }

      yield LoadBlacklistUserState.loaded(
        blacklistUserList: blacklistUser,
      );
    } on APIException catch (err) {
      yield LoadBlacklistUserState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadBlacklistUserState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
