import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'update_is_read_event.dart';
part 'update_is_read_state.dart';

class UpdateIsReadBloc extends Bloc<UpdateIsReadEvent, UpdateIsReadState> {
  UpdateIsReadBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(UpdateIsReadState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<UpdateIsReadState> mapEventToState(
    UpdateIsReadEvent event,
  ) async* {
    if (event is UpdateIsRead) {
      yield* _mapUpdateIsReadToState(event);
    }
  }

  Stream<UpdateIsReadState> _mapUpdateIsReadToState(UpdateIsRead event) async* {
    try {
      yield UpdateIsReadState.loading();

      final resp = await inquiryChatroomApis.updateIsRead(
        event.channelUUID,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield UpdateIsReadState.loaded();
    } on APIException catch (e) {
      yield UpdateIsReadState.loadFailed(e);
    } on Exception catch (e) {
      yield UpdateIsReadState.loadFailed(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
