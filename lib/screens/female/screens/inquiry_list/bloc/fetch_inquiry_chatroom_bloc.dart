import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';

import '../services/api_client.dart';

part 'fetch_inquiry_chatroom_event.dart';
part 'fetch_inquiry_chatroom_state.dart';

class FetchInquiryChatroomBloc
    extends Bloc<FetchInquiryChatroomEvent, FetchInquiryChatroomState> {
  final ApiClient apis;
  final InquiryChatroomsBloc inquiryChatroomBloc;

  FetchInquiryChatroomBloc({
    this.apis,
    this.inquiryChatroomBloc,
  })  : assert(apis != null),
        assert(inquiryChatroomBloc != null),
        super(FetchInquiryChatroomInitial());

  @override
  Stream<FetchInquiryChatroomState> mapEventToState(
      FetchInquiryChatroomEvent event) async* {
    if (event is FetchInquiryChatroom) {
      yield* _mapFetchInquiryChatroomToState(event);
    }
  }

  Stream<FetchInquiryChatroomState> _mapFetchInquiryChatroomToState(
      FetchInquiryChatroom event) async* {
    try {
      yield FetchingInquiryChatroom();

      final resp = await apis.fetchInquiryChatroom(event.inquiryUUID);

      // We add chatroom to inquiry_chatrooms_bloc
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(jsonDecode(resp.body));
      }

      final Map<String, dynamic> respMap = jsonDecode(resp.body);
      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      // if no chatroom of that inquiry is found, we throw an error
      // TODO: display text message in i18n.
      if (chatrooms.length == 0) {
        throw APIException(message: '聊天室不存在喔');
      }

      inquiryChatroomBloc.add(AddChatrooms(chatrooms));

      yield FetchInquiryChatroomSuccess(chatrooms.first);
    } on APIException catch (e) {
      yield FetchInquiryChatroomFailed(error: e);
    } catch (e) {
      yield FetchInquiryChatroomFailed(error: AppGeneralExeption(message: e));
    }
  }
}
