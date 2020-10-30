import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/bloc/private_chats_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../../../models/picked_inquiry.dart';

part 'picked_inquiries_dart_event.dart';
part 'picked_inquiries_dart_state.dart';

class PickedInquiriesDartBloc
    extends Bloc<PickedInquiriesDartEvent, PickedInquiriesDartState> {
  PickedInquiriesDartBloc({
    this.privateChatsBloc,
  })  : assert(privateChatsBloc != null),
        super(PickedInquiriesDartState.init());

  final PrivateChatsBloc privateChatsBloc;

  @override
  Stream<PickedInquiriesDartState> mapEventToState(
    PickedInquiriesDartEvent event,
  ) async* {
    if (event is AddPickedInqiury) {
      yield* _mapAddPickedInquiryToState(event);
    } else if (event is CancelStream) {
      yield* _mapCancelStreamToState(event);
    }
  }

  Stream<PickedInquiriesDartState> _mapAddPickedInquiryToState(
      AddPickedInqiury event) async* {
    try {
      // Test the adding a sample user to collection in firestore
      StreamSubscription<QuerySnapshot> streamSub = FirebaseFirestore.instance
          .collection('private_chats')
          .doc(event.pickedInquiry.channelUUID)
          .collection('messages')
          .snapshots()
          .listen(
            (QuerySnapshot snapshot) => _handlePrivateChatEvent(
                event.pickedInquiry.channelUUID, snapshot),
          );

      // Store stream to later cancel the subscription
      state.privateChatStreamMap[event.pickedInquiry.channelUUID] = streamSub;

      yield PickedInquiriesDartState.updatePrivateChatStreamMap(
        state,
        state.privateChatStreamMap,
      );
    } catch (err) {
      yield PickedInquiriesDartState.failed(
        state,
        AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
  }

  _handlePrivateChatEvent(String channelUUID, QuerySnapshot event) {
    developer.log('handle private chat on channel ID: $channelUUID');

    privateChatsBloc.add(
      DispatchMessage(
        chatroomUUID: channelUUID,
        message: Message.fromMap(event.docChanges.first.doc.data()),
      ),
    );
  }

  Stream<PickedInquiriesDartState> _mapCancelStreamToState(
      CancelStream event) async* {
    // Unsubscribe specified private chat stream.
    if (state.privateChatStreamMap.containsKey(event.channelUUID)) {
      final stream = state.privateChatStreamMap[event.channelUUID];

      stream.cancel();

      state.privateChatStreamMap.remove(event.channelUUID);

      // Remove chatroom in the app alone with it's messages.
      privateChatsBloc.add(
        RemovePrivateChatRoom(chatroomUUID: event.channelUUID),
      );
    } else {
      developer.log(
        'Stream intends to unsubscribe is\'t exist for the given  channel UUID',
        name: 'private_chat:unsubscribe_stream',
      );
    }

    yield null;
  }
}
