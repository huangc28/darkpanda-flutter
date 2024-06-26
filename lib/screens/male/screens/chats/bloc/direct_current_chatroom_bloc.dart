import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';
import 'package:darkpanda_flutter/models/cancel_service_message.dart';
import 'package:darkpanda_flutter/models/image_message.dart';
import 'package:darkpanda_flutter/models/payment_completed_message.dart';
import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'package:darkpanda_flutter/enums/message_types.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show UpdateInquiryNotifierBloc, UpdateInquiryConfirmed;

import 'load_direct_inquiry_chatrooms_bloc.dart';

part 'direct_current_chatroom_event.dart';
part 'direct_current_chatroom_state.dart';

class DirectCurrentChatroomBloc
    extends Bloc<DirectCurrentChatroomEvent, DirectCurrentChatroomState> {
  DirectCurrentChatroomBloc({
    this.inquiryChatroomApis,
    this.userApis,
    this.loadDirectInquiryChatroomsBloc,
    this.currentServiceBloc,
    this.serviceConfirmNotifierBloc,
    this.updateInquiryNotifierBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(userApis != null),
        assert(loadDirectInquiryChatroomsBloc != null),
        assert(currentServiceBloc != null),
        assert(serviceConfirmNotifierBloc != null),
        assert(updateInquiryNotifierBloc != null),
        super(DirectCurrentChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final UserApis userApis;

  final LoadDirectInquiryChatroomsBloc loadDirectInquiryChatroomsBloc;
  final CurrentServiceBloc currentServiceBloc;
  final ServiceConfirmNotifierBloc serviceConfirmNotifierBloc;
  final UpdateInquiryNotifierBloc updateInquiryNotifierBloc;

  @override
  Stream<DirectCurrentChatroomState> mapEventToState(
    DirectCurrentChatroomEvent event,
  ) async* {
    if (event is InitDirectCurrentChatroom) {
      yield* _mapInitDirectCurrentChatroomToState(event);
    } else if (event is DispatchNewMessage) {
      yield* _mapDispatchNewMessageToState(event);
    } else if (event is FetchMoreHistoricalMessages) {
      yield* _mapFetchMoreHistoricalMessagesToState(event);
    } else if (event is LeaveDirectCurrentChatroom) {
      yield* _mapLeaveDirectCurrentChatroomToState(event);
    }
  }

  Stream<DirectCurrentChatroomState> _mapFetchMoreHistoricalMessagesToState(
      FetchMoreHistoricalMessages event) async* {
    try {
      await DirectCurrentChatroomState.loading(state);

      // Fetching historical messages.
      final resp = await inquiryChatroomApis.fetchInquiryHistoricalMessages(
        event.channelUUID,
        event.perPage,
        state.page + 1,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);

      final prevPageMessage = respMap['messages'].map<Message>((data) {
        if (data['type'] == MessageType.service_detail.name) {
          return ServiceDetailMessage.fromMap(data);
        } else if (data['type'] == MessageType.confirmed_service.name) {
          return ServiceConfirmedMessage.fromMap(data);
        } else if (data['type'] == MessageType.update_inquiry_detail.name) {
          return UpdateInquiryMessage.fromMap(data);
        } else if (data['type'] == MessageType.disagree_inquiry.name) {
          return DisagreeInquiryMessage.fromMap(data);
        } else if (data['type'] == MessageType.quit_chatroom.name) {
          return QuitChatroomMessage.fromMap(data);
        } else if (data['type'] == MessageType.images.name) {
          return ImageMessage.fromMap(data);
        } else if (data['type'] == MessageType.complete_payment.name) {
          return PaymentCompletedMessage.fromMap(data);
        } else if (data['type'] == MessageType.cancel_service.name) {
          return CancelServiceMessage.fromMap(data);
        } else if (data['type'] == MessageType.bot_invitation_chat_text.name) {
          return BotInvitationChatMessage.fromMap(data);
        } else {
          return Message.fromMap(data);
        }
      }).toList();

      final newMessages = List<Message>.from(state.historicalMessages)
        ..addAll(prevPageMessage);

      yield DirectCurrentChatroomState.loaded(
        state,
        historicalMessages: newMessages,
        page: state.page + 1,
      );
    } on APIException catch (e) {
      yield DirectCurrentChatroomState.loadFailed(state, e);
    } on Exception catch (e) {
      yield DirectCurrentChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<DirectCurrentChatroomState> _mapDispatchNewMessageToState(
      DispatchNewMessage event) async* {
    final messages = List<Message>.from(state.currentMessages)
      ..insert(0, event.message);

    yield DirectCurrentChatroomState.updateCurrentMessage(
      state,
      messages,
    );
  }

  Stream<DirectCurrentChatroomState> _mapInitDirectCurrentChatroomToState(
      InitDirectCurrentChatroom event) async* {
    try {
      // Fetch historical messages
      yield DirectCurrentChatroomState.loading(state);
      yield DirectCurrentChatroomState.init();

      final resp = await inquiryChatroomApis.fetchInquiryHistoricalMessages(
        event.channelUUID,
        event.perPage,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }
      // Convert response data to list of messages and store them to historical messages.
      final Map<String, dynamic> respMap = json.decode(resp.body);

      if (respMap['messages'].isEmpty) {
        return;
      }

      // Convert response data to list of messages and store them to historical messages.
      final historicalMessages = respMap['messages'].map<Message>((data) {
        if (data['type'] == MessageType.service_detail.name) {
          return ServiceDetailMessage.fromMap(data);
        } else if (data['type'] == MessageType.confirmed_service.name) {
          return ServiceConfirmedMessage.fromMap(data);
        } else if (data['type'] == MessageType.update_inquiry_detail.name) {
          return UpdateInquiryMessage.fromMap(data);
        } else if (data['type'] == MessageType.disagree_inquiry.name) {
          return DisagreeInquiryMessage.fromMap(data);
        } else if (data['type'] == MessageType.quit_chatroom.name) {
          return QuitChatroomMessage.fromMap(data);
        } else if (data['type'] == MessageType.images.name) {
          return ImageMessage.fromMap(data);
        } else if (data['type'] == MessageType.complete_payment.name) {
          return PaymentCompletedMessage.fromMap(data);
        } else if (data['type'] == MessageType.cancel_service.name) {
          return CancelServiceMessage.fromMap(data);
        } else if (data['type'] == MessageType.bot_invitation_chat_text.name) {
          return BotInvitationChatMessage.fromMap(data);
        } else {
          return Message.fromMap(data);
        }
      }).toList();

      // Fetch inquirer profile.
      final upResp = await userApis.fetchUser(event.inquirerUUID);

      final inquirerProfile = UserProfile.fromJson(
        json.decode(upResp.body),
      );

      // Grab chatroom subscription and listen to incoming messages. Push new message to
      // current message array.
      final subStream = loadDirectInquiryChatroomsBloc
          .state.privateChatStreamMap[event.channelUUID];

      subStream.onData((data) {
        _handleCurrentMessage(data, event.channelUUID);
      });

      yield DirectCurrentChatroomState.loaded(
        state,
        inquirerProfile: inquirerProfile,
        historicalMessages: historicalMessages,
      );
    } on APIException catch (e) {
      yield DirectCurrentChatroomState.loadFailed(
        state,
        e,
      );
    } on Exception catch (e) {
      yield DirectCurrentChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  _handleCurrentMessage(data, String channelUUID) {
    final QuerySnapshot msgSnapShot = data;
    final rawMsg = msgSnapShot.docChanges.first.doc.data() as Map;

    developer
        .log('Current chatroom incoming message ${rawMsg['type'].toString()}');

    final isServiceDetailMsg =
        (String type) => type == MessageType.service_detail.name;
    final isConfirmedServiceMsg =
        (String type) => type == MessageType.confirmed_service.name;
    final isUpdateInquiryDetailMsg =
        (String type) => type == MessageType.update_inquiry_detail.name;
    final isDisagreeInquiryMsg =
        (String type) => type == MessageType.disagree_inquiry.name;
    final isQuitChatroomMsg =
        (String type) => type == MessageType.quit_chatroom.name;
    final isCompletedPaymentMsg =
        (String type) => type == MessageType.complete_payment.name;
    final isImagesMsg = (String type) => type == MessageType.images.name;
    final isCancelServiceMsg =
        (String type) => type == MessageType.cancel_service.name;
    final isBotInvitationChatText =
        (type) => type == MessageType.bot_invitation_chat_text.name;

    // Transform to different message object according to type.
    // Dispatch new message to current chat message array.
    Message msg;

    if (isServiceDetailMsg(rawMsg['type'])) {
      msg = ServiceDetailMessage.fromMap(rawMsg);

      currentServiceBloc.add(
        UpdateCurrentServiceByMessage(
          messasge: msg,
        ),
      );
    } else if (isConfirmedServiceMsg(rawMsg['type'])) {
      msg = ServiceConfirmedMessage.fromMap(rawMsg);

      serviceConfirmNotifierBloc.add(NotifyServiceConfirmed(msg));
    } else if (isUpdateInquiryDetailMsg(rawMsg['type'])) {
      msg = UpdateInquiryMessage.fromMap(rawMsg);

      updateInquiryNotifierBloc.add(UpdateInquiryConfirmed(msg));
    } else if (isDisagreeInquiryMsg(rawMsg['type'])) {
      msg = DisagreeInquiryMessage.fromMap(rawMsg);
    } else if (isQuitChatroomMsg(rawMsg['type'])) {
      msg = QuitChatroomMessage.fromMap(rawMsg);

      // **
      // Have to delete chatroom message as well
      // inquiryChatroomsBloc.add(
      //   LeaveMaleChatroom(channelUUID: channelUUID),
      // );
    } else if (isCompletedPaymentMsg(rawMsg['type'])) {
      msg = PaymentCompletedMessage.fromMap(rawMsg);
    } else if (isImagesMsg(rawMsg['type'])) {
      msg = ImageMessage.fromMap(rawMsg);
    } else if (isCancelServiceMsg(rawMsg['type'])) {
      msg = CancelServiceMessage.fromMap(rawMsg);
    } else if (isBotInvitationChatText(rawMsg['type'])) {
      msg = BotInvitationChatMessage.fromMap(rawMsg);
    } else {
      msg = Message.fromMap(rawMsg);
    }

    add(DispatchNewMessage(message: msg));
  }

  Stream<DirectCurrentChatroomState> _mapLeaveDirectCurrentChatroomToState(
      LeaveDirectCurrentChatroom event) async* {
    // Reset current chatroom messages.
    // Reset current chatroom historical messages.
    // Reset page number.
    yield DirectCurrentChatroomState.init();
  }
}
