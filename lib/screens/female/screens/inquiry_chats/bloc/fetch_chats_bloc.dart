import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

import '../services/inquiry_chats_apis.dart';

part 'fetch_chats_event.dart';
part 'fetch_chats_state.dart';

class FetchChatsBloc extends Bloc<FetchChatsEvent, FetchChatsState> {
  FetchChatsBloc({
    this.inquiryChatsApis,
    this.inquiryChatroomBloc,
  })  : assert(inquiryChatsApis != null),
        assert(inquiryChatroomBloc != null),
        super(FetchChatsState.init());

  final InquiryChatsApis inquiryChatsApis;
  final InquiryChatroomsBloc inquiryChatroomBloc;

  @override
  Stream<FetchChatsState> mapEventToState(
    FetchChatsEvent event,
  ) async* {
    if (event is FetchChats) {
      yield* _mapFetchChatsToState(event);
    }
    // Fetch list of inquiry chats from the backend. Subscribe to each of them if not already subscribed.
  }

  Stream<FetchChatsState> _mapFetchChatsToState(FetchChats event) async* {
    print('DEBUG _mapFetchChatsToState');
    try {
      yield FetchChatsState.loading();

      final resp = await inquiryChatsApis.fetchChats();

      print('DEBUG _mapFetchChatsToState 1 $resp');

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);
      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      print('DEBUG inquiryChatroomBloc ${chatrooms}');

      inquiryChatroomBloc.add(
        AddChatrooms(chatrooms),
      );

      yield FetchChatsState.loaded();
    } on APIException catch (e) {
      yield FetchChatsState.loadFailed(e);
    } on AppGeneralExeption catch (e) {
      yield FetchChatsState.loadFailed(e);
    } catch (e) {
      yield FetchChatsState.loadFailed(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
