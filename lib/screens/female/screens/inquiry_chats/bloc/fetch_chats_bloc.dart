import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/inquiry_chats_apis.dart';
import '../models/inquiry_chats.dart';

part 'fetch_chats_event.dart';
part 'fetch_chats_state.dart';

class FetchChatsBloc extends Bloc<FetchChatsEvent, FetchChatsState> {
  FetchChatsBloc({
    this.inquiryChatsApis,
  })  : assert(inquiryChatsApis != null),
        super(FetchChatsState.init());

  final InquiryChatsApis inquiryChatsApis;

  @override
  Stream<FetchChatsState> mapEventToState(
    FetchChatsEvent event,
  ) async* {
    print('DEBUG trigger _mapFetchChatsToState 1');
    if (event is FetchChats) {
      yield* _mapFetchChatsToState(event);
    }
    // Fetch list of inquiry chats from the backend. Subscribe to each of them if not already subscribed.
  }

  Stream<FetchChatsState> _mapFetchChatsToState(FetchChats event) async* {
    try {
      yield FetchChatsState.loading();

      final resp = await inquiryChatsApis.fetchChats();

      print('DEBUG *&^ ${resp.body}');

      yield null;
    } on Error catch (e) {
      print('DEBUG trigger _mapFetchChatsToState 2 ${e.toString()}');
    }
  }
}
