import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/util/util.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show InquiryChatMessagesBloc, DispatchMessage;

import '../models/incoming_service.dart';
import '../services/service_chatroom_api.dart';

part 'load_incoming_service_event.dart';
part 'load_incoming_service_state.dart';

class LoadIncomingServiceBloc
    extends Bloc<LoadIncomingServiceEvent, LoadIncomingServiceState> {
  LoadIncomingServiceBloc({
    this.apiClient,
    this.inquiryChatMesssagesBloc,
  }) : super(LoadIncomingServiceState.initial());

  final ServiceChatroomClient apiClient;
  final InquiryChatMessagesBloc inquiryChatMesssagesBloc;

  Map<String, bool> _chatFirstCreateMap = {};

  @override
  Stream<LoadIncomingServiceState> mapEventToState(
    LoadIncomingServiceEvent event,
  ) async* {
    if (event is LoadIncomingService) {
      yield* _mapLoadIncomingServiceEventToState(event);
    } else if (event is LoadMoreIncomingService) {
      yield* _mapLoadMoreIncomingServiceEventToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is PutLatestMessage) {
      yield* _mapPutLatestMessage(event);
    } else if (event is UpdateChatroomServiceStatus) {
      yield* _mapUpdateChatroomServiceStatusToState(event);
    } else if (event is ClearIncomingServiceState) {
      yield* _mapClearIncomingServiceStateToState(event);
    }
  }

  Stream<LoadIncomingServiceState> _mapLoadIncomingServiceEventToState(
      LoadIncomingService event) async* {
    try {
      // toggle loading
      yield LoadIncomingServiceState.loading(state);
      yield LoadIncomingServiceState.clearState(state);

      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      // request API
      final res = await apiClient.fetchIncomingService(
        offset: offset,
      );

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(res.body);

      final serviceList = respMap['services']
          .map<IncomingService>((v) => IncomingService.fromMap(v))
          .toList();

      add(AddChatrooms(serviceList));
    } on APIException catch (err) {
      yield LoadIncomingServiceState.loadFailed(
        state,
        err: err,
      );
    } catch (err) {
      yield LoadIncomingServiceState.loadFailed(
        state,
        err: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadIncomingServiceState> _mapLoadMoreIncomingServiceEventToState(
      LoadMoreIncomingService event) async* {
    try {
      final offset = calcNextPageOffset(
        nextPage: state.currentPage + 1,
        perPage: event.perPage,
      );

      // request API
      final res = await apiClient.fetchIncomingService(
        offset: offset,
      );

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(res.body);

      final serviceList = respMap['services'].map<IncomingService>((v) {
        return IncomingService.fromMap(v);
      }).toList();

      final appended = <IncomingService>[
        ...state.services,
        ...?serviceList,
      ].toList();

      add(
        AddChatrooms(appended),
      );
    } on APIException catch (err) {
      yield LoadIncomingServiceState.loadFailed(
        state,
        err: err,
      );
    } catch (err) {
      yield LoadIncomingServiceState.loadFailed(
        state,
        err: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadIncomingServiceState> _mapAddChatroomsToState(
      AddChatrooms event) async* {
    // Iterate through list of chatrooms. Skip channel subscription
    // if channel uuid exists in the current map.
    for (final chatroom in event.chatrooms) {
      if (state.privateChatStreamMap.containsKey(chatroom.channelUuid)) {
        continue;
      }

      // Channel uuid does not exists in map, initiate subscription stream.
      // Store the stream in `privateChatStreamMap`.
      final streamSub = _createChatroomSubscriptionStream(chatroom.channelUuid);

      // Put a flag to indicate that the channel has just been created. Ignore
      // the first event from firestore subscription.
      _chatFirstCreateMap[chatroom.channelUuid] = true;

      state.privateChatStreamMap[chatroom.channelUuid] = streamSub;

      // Insert new chatroom at the start of the chatroom array.
      state.services.insert(0, chatroom);

      final streamSubChatroomService =
          _createServiceSubscriptionStream(chatroom.serviceUuid);

      state.serviceStreamMap[chatroom.serviceUuid] = streamSubChatroomService;
    }

    final newPrivateChatStreamMap = Map.of(state.privateChatStreamMap);
    final newServiceStreamMap = Map.of(state.serviceStreamMap);

    final chatroomLatestMessageMap = event.chatrooms.fold<Map<String, Message>>(
      {},
      (prev, chatroom) {
        prev[chatroom.channelUuid] = chatroom.messages[0];

        return prev;
      },
    );

    final serviceStatusMap =
        event.chatrooms.fold<Map<String, ServiceStatus>>({}, (prev, chatroom) {
      prev[chatroom.serviceUuid] = chatroom.status.toServiceStatusEnum();

      return prev;
    });

    yield LoadIncomingServiceState.updateChatrooms(
      state,
      services: [...event.chatrooms],
      privateChatStreamMap: newPrivateChatStreamMap,
      serviceStreamMap: newServiceStreamMap,
      chatroomLastMessage: chatroomLatestMessageMap,
      service: serviceStatusMap,
      currentPage: state.currentPage + 1,
    );
  }

  StreamSubscription<QuerySnapshot> _createChatroomSubscriptionStream(
      String channelUUID) {
    return FirebaseFirestore.instance
        .collection('private_chats')
        .doc(channelUUID)
        .collection('messages')
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        // Ignore the first event sent from firestore when the subscription first
        // created. It messes up the displaying the latest message on the chatroom
        // list.
        if (_chatFirstCreateMap[channelUUID] == false) {
          _handlePrivateChatEvent(channelUUID, snapshot);
        }

        // Toggle the flag to `false` for the subsequent event to trigger the
        // handler `_handlePrivateChatEvent`.
        _chatFirstCreateMap[channelUUID] = false;
      },
    );
  }

  _handlePrivateChatEvent(String channelUUID, QuerySnapshot event) async {
    developer.log('handle private chat on channel ID: $channelUUID');
    final message = Message.fromMap(
      event.docChanges.first.doc.data(),
    );

    //check whether inquirer_uuid or picker_uuid is me,
    //get is read
    String UserUUID = await SecureStore().readUuid();

    final parent = event.docChanges.first.doc.reference.parent.parent.get();
    await parent.then((doc) {
      if (UserUUID == doc.data()["inquirer_uuid"]) {
        message.isRead = doc.data()["inquirer_is_read"];
      }

      if (UserUUID == doc.data()["picker_uuid"]) {
        message.isRead = doc.data()["picker_is_read"];
      }
    });

    developer.log('dispatching private chat message: ${message.content}');

    add(
      PutLatestMessage(
        channelUUID: channelUUID,
        message: message,
      ),
    );

    inquiryChatMesssagesBloc.add(
      DispatchMessage(
        chatroomUUID: channelUUID,
        message: message,
      ),
    );
  }

  Stream<LoadIncomingServiceState> _mapPutLatestMessage(
      PutLatestMessage event) async* {
    final newMap = Map.of(state.chatroomLastMessage);
    newMap[event.channelUUID] = event.message;

    yield LoadIncomingServiceState.putChatroomLatestMessage(
      state,
      chatroomLastMessage: newMap,
    );
  }

  StreamSubscription<DocumentSnapshot> _createServiceSubscriptionStream(
      String serviceUuid) {
    return FirebaseFirestore.instance
        .collection('services')
        .doc(serviceUuid)
        .snapshots()
        .listen(
      (DocumentSnapshot snapshot) {
        _handleServiceStatusChange(serviceUuid, snapshot);
      },
    );
  }

  _handleServiceStatusChange(String serviceUuid, DocumentSnapshot snapshot) {
    String status = snapshot['status'] as String;

    developer.log(
        'firestore service list changes received: ${snapshot.data().toString()}');

    add(
      UpdateChatroomServiceStatus(
        serviceUuid: serviceUuid,
        status: status.toServiceStatusEnum(),
      ),
    );
  }

  Stream<LoadIncomingServiceState> _mapUpdateChatroomServiceStatusToState(
      UpdateChatroomServiceStatus event) async* {
    developer.log(
        'Service list found: ${event.serviceUuid}, updating status: ${event.status.toString()}');

    final newMap = Map.of(state.service);
    newMap[event.serviceUuid] = event.status;

    // Replace current service list witht updated list.
    yield LoadIncomingServiceState.putChatroomService(
      state,
      service: newMap,
    );
  }

  Stream<LoadIncomingServiceState> _mapClearIncomingServiceStateToState(
      ClearIncomingServiceState event) async* {
    yield LoadIncomingServiceState.clearState(state);
  }
}
