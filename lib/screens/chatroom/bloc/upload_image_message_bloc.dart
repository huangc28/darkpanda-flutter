import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/chat_image.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'upload_image_message_event.dart';
part 'upload_image_message_state.dart';

class UploadImageMessageBloc
    extends Bloc<UploadImageMessageEvent, UploadImageMessageState> {
  UploadImageMessageBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(UploadImageMessageState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<UploadImageMessageState> mapEventToState(
    UploadImageMessageEvent event,
  ) async* {
    if (event is UploadImageMessage) {
      yield* _mapUploadImageMessageToState(event);
    }
  }

  Stream<UploadImageMessageState> _mapUploadImageMessageToState(
      UploadImageMessage event) async* {
    try {
      yield UploadImageMessageState.loading(state);

      final resp =
          await inquiryChatroomApis.uploadChatroomImage(event.imageFile);

      final Map<String, dynamic> result = json.decode(resp.body);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield UploadImageMessageState.loaded(
        state,
        chatImages: ChatImage.fromMap(
          result,
        ),
      );
    } on APIException catch (e) {
      yield UploadImageMessageState.loadFailed(e);
    } on Exception catch (e) {
      yield UploadImageMessageState.loadFailed(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
