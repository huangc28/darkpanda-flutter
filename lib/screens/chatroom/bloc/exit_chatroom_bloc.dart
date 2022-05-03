import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'exit_chatroom_event.dart';
part 'exit_chatroom_state.dart';

class ExitChatroomBloc extends Bloc<ExitChatroomEvent, ExitChatroomState> {
  ExitChatroomBloc({
    this.searchInquiryAPIs,
    this.inquiryChatroomsBloc,
  }) : super(ExitChatroomState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final InquiryChatroomsBloc inquiryChatroomsBloc;

  @override
  Stream<ExitChatroomState> mapEventToState(
    ExitChatroomEvent event,
  ) async* {
    if (event is QuitChatroom) {
      yield* _mapQuitChatroomFormToState(event);
    }
  }

  Stream<ExitChatroomState> _mapQuitChatroomFormToState(
      QuitChatroom event) async* {
    try {
      yield ExitChatroomState.loading(state);

      final resp = await searchInquiryAPIs.quitChatroom(event.channelUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      // TODO Have to delete chatroom message as well
      inquiryChatroomsBloc.add(
        LeaveMaleChatroom(channelUUID: event.channelUuid),
      );

      print('DEBUG before exit');

      yield ExitChatroomState.done(state);
    } on APIException catch (e) {
      yield ExitChatroomState.error(e);
    } catch (e) {
      yield ExitChatroomState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
