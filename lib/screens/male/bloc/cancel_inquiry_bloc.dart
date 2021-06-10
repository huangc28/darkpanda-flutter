import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'cancel_inquiry_event.dart';
part 'cancel_inquiry_state.dart';

class CancelInquiryBloc extends Bloc<CancelInquiryEvent, CancelInquiryState> {
  CancelInquiryBloc({
    this.searchInquiryAPIs,
    this.loadInquiryBloc,
    this.inquiryChatroomsBloc,
  }) : super(CancelInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadInquiryBloc loadInquiryBloc;
  final InquiryChatroomsBloc inquiryChatroomsBloc;

  @override
  Stream<CancelInquiryState> mapEventToState(
    CancelInquiryEvent event,
  ) async* {
    if (event is CancelInquiry) {
      yield* _mapCancelInquiryFormToState(event);
    } else if (event is SkipInquiry) {
      yield* _mapSkipInquiryFormToState(event);
    } else if (event is QuitChatroom) {
      yield* _mapQuitChatroomFormToState(event);
    } else if (event is DisagreeInquiry) {
      yield* _mapDisagressInquiryFormToState(event);
    }
  }

  Stream<CancelInquiryState> _mapCancelInquiryFormToState(
      CancelInquiry event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.cancelInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      loadInquiryBloc.add(
        RemoveLoadInquiry(inquiryUuid: event.inquiryUuid),
      );

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }

  Stream<CancelInquiryState> _mapSkipInquiryFormToState(
      SkipInquiry event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.skipInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }

  Stream<CancelInquiryState> _mapQuitChatroomFormToState(
      QuitChatroom event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.quitChatroom(event.channelUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      // **
      // Have to delete chatroom message as well
      inquiryChatroomsBloc.add(
        LeaveMaleChatroom(channelUUID: event.channelUuid),
      );

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }

  Stream<CancelInquiryState> _mapDisagressInquiryFormToState(
      DisagreeInquiry event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.disagreeInquiry(event.channelUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
