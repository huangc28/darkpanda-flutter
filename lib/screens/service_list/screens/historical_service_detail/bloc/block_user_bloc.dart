import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import '../../../services/service_chatroom_api.dart';

part 'block_user_event.dart';
part 'block_user_state.dart';

class BlockUserBloc extends Bloc<BlockUserEvent, BlockUserState> {
  BlockUserBloc({
    this.apiClient,
  }) : super(BlockUserState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<BlockUserState> mapEventToState(
    BlockUserEvent event,
  ) async* {
    if (event is BlockUser) {
      yield* _mapBlockUserEventToState(event);
    }
  }

  Stream<BlockUserState> _mapBlockUserEventToState(BlockUser event) async* {
    try {
      // toggle loading
      yield BlockUserState.loading(state);

      // request API
      final res = await apiClient.blockUser(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield BlockUserState.loadSuccess(state);
    } on APIException catch (err) {
      print(err);
      yield BlockUserState.loadFailed(state, err);
    } catch (err) {
      print(err);
      yield BlockUserState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
