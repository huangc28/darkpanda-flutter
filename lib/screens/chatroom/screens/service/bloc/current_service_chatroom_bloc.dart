import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:darkpanda_flutter/models/bot_invitation_chat_message.dart';
import 'package:darkpanda_flutter/models/cancel_service_message.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/models/image_message.dart';
import 'package:darkpanda_flutter/models/payment_completed_message.dart';
import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';
import 'package:darkpanda_flutter/models/start_service_message.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/payment_complete_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/service_start_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/models/incoming_service.dart';

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
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';

part 'current_service_chatroom_event.dart';
part 'current_service_chatroom_state.dart';

// TODO we should create service chatroom stream when fetching service chatroom list
// instead of creating service chatroom stream after redirected to service chatroom.
class CurrentServiceChatroomBloc
    extends Bloc<CurrentServiceChatroomEvent, CurrentServiceChatroomState> {
  CurrentServiceChatroomBloc({
    this.inquiryChatroomApis,
    this.userApis,
    this.loadIncomingServiceBloc,
    this.currentServiceBloc,
    this.serviceConfirmNotifierBloc,
    this.serviceStartNotifierBloc,
    this.paymentCompleteNotifierBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(userApis != null),
        assert(loadIncomingServiceBloc != null),
        assert(currentServiceBloc != null),
        assert(serviceConfirmNotifierBloc != null),
        assert(serviceStartNotifierBloc != null),
        assert(paymentCompleteNotifierBloc != null),
        super(CurrentServiceChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final UserApis userApis;

  final LoadIncomingServiceBloc loadIncomingServiceBloc;
  final CurrentServiceBloc currentServiceBloc;
  final ServiceConfirmNotifierBloc serviceConfirmNotifierBloc;
  final ServiceStartNotifierBloc serviceStartNotifierBloc;
  final PaymentCompleteNotifierBloc paymentCompleteNotifierBloc;

  @override
  Stream<CurrentServiceChatroomState> mapEventToState(
    CurrentServiceChatroomEvent event,
  ) async* {
    if (event is InitCurrentServiceChatroom) {
      yield* _mapInitCurrentChatroomToState(event);
    } else if (event is DispatchNewMessage) {
      yield* _mapDispatchNewMessageToState(event);
    } else if (event is FetchMoreHistoricalMessages) {
      yield* _mapFetchMoreHistoricalMessagesToState(event);
    } else if (event is UpdateServiceStatus) {
      yield* _mapUpdateServiceStatusToState(event);
    } else if (event is LeaveCurrentServiceChatroom) {
      yield* _mapLeaveCurrentChatroomToState(event);
    }
  }

  Stream<CurrentServiceChatroomState> _mapFetchMoreHistoricalMessagesToState(
      FetchMoreHistoricalMessages event) async* {
    try {
      await CurrentServiceChatroomState.loading(state);

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
        } else if (data['type'] == MessageType.complete_payment.name) {
          return PaymentCompletedMessage.fromMap(data);
        } else if (data['type'] == MessageType.start_service.name) {
          return StartServiceMessage.fromMap(data);
        } else if (data['type'] == MessageType.images.name) {
          return ImageMessage.fromMap(data);
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

      yield CurrentServiceChatroomState.loaded(
        state,
        historicalMessages: newMessages,
        page: state.page + 1,
      );
    } on APIException catch (e) {
      yield CurrentServiceChatroomState.loadFailed(state, e);
    } on Exception catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<CurrentServiceChatroomState> _mapDispatchNewMessageToState(
      DispatchNewMessage event) async* {
    final messages = List<Message>.from(state.currentMessages)
      ..insert(0, event.message);

    yield CurrentServiceChatroomState.updateCurrentMessage(
      state,
      messages,
    );
  }

  Stream<CurrentServiceChatroomState> _mapInitCurrentChatroomToState(
      InitCurrentServiceChatroom event) async* {
    try {
      // Fetch historical messages
      yield CurrentServiceChatroomState.loading(state);
      yield CurrentServiceChatroomState.clearCurrentChatroom();

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
        } else if (data['type'] == MessageType.complete_payment.name) {
          return PaymentCompletedMessage.fromMap(data);
        } else if (data['type'] == MessageType.start_service.name) {
          return StartServiceMessage.fromMap(data);
        } else if (data['type'] == MessageType.images.name) {
          return ImageMessage.fromMap(data);
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
      final subStream =
          loadIncomingServiceBloc.state.privateChatStreamMap[event.channelUUID];

      subStream.onData((data) {
        _handleCurrentMessage(data, event.channelUUID);
      });

      final service = loadIncomingServiceBloc.state.services
          .where((element) => element.channelUuid == event.channelUUID)
          .toList()
          .first;

      yield CurrentServiceChatroomState.loaded(
        state,
        historicalMessages: historicalMessages,
        inquirerProfile: inquirerProfile,
        service: service,
        serviceStreamMap: _createServiceSubscriptionStreamMap(service),
      );
    } on APIException catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
        state,
        e,
      );
    } on Exception catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
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
    final isStartServiceMsg =
        (String type) => type == MessageType.start_service.name;
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
    } else if (isDisagreeInquiryMsg(rawMsg['type'])) {
      msg = DisagreeInquiryMessage.fromMap(rawMsg);
    } else if (isQuitChatroomMsg(rawMsg['type'])) {
      msg = QuitChatroomMessage.fromMap(rawMsg);
    } else if (isCompletedPaymentMsg(rawMsg['type'])) {
      msg = PaymentCompletedMessage.fromMap(rawMsg);

      paymentCompleteNotifierBloc.add(NotifyPaymentCompleted(msg));
    } else if (isStartServiceMsg(rawMsg['type'])) {
      msg = StartServiceMessage.fromMap(rawMsg);

      serviceStartNotifierBloc.add(NotifyServiceStarted(msg));
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

  Stream<CurrentServiceChatroomState> _mapLeaveCurrentChatroomToState(
      LeaveCurrentServiceChatroom event) async* {
    // Reset current chatroom messages.
    // Reset current chatroom historical messages.
    // Reset page number.
    yield CurrentServiceChatroomState.clearCurrentChatroom();
  }

  Map<String, StreamSubscription<DocumentSnapshot>>
      _createServiceSubscriptionStreamMap(IncomingService service) {
    Map<String, StreamSubscription<DocumentSnapshot>> _streamMap = {};

    if (service.status == ServiceStatus.unpaid.name ||
        service.status == ServiceStatus.to_be_fulfilled.name) {
      _streamMap[service.serviceUuid] =
          _createServiceSubscriptionStream(service.serviceUuid);
    }

    return _streamMap;
  }

  StreamSubscription<DocumentSnapshot> _createServiceSubscriptionStream(
      String serviceUuid) {
    return FirebaseFirestore.instance
        .collection('services')
        .doc(serviceUuid)
        .snapshots()
        .listen(
      (DocumentSnapshot snapshot) {
        // If male user alter the inquiry to either `unpaid` or `to_be_fulfiiled`, We need to update
        // the service status in the app to reflect on the screen.
        _handleServiceStatusChange(serviceUuid, snapshot);
      },
    );
  }

  _handleServiceStatusChange(String serviceUuid, DocumentSnapshot snapshot) {
    String status = snapshot['status'] as String;

    developer.log(
        'firestore service changes received: ${snapshot.data().toString()}');

    add(
      UpdateServiceStatus(
        serviceUuid: serviceUuid,
        status: status.toServiceStatusEnum(),
      ),
    );
  }

  Stream<CurrentServiceChatroomState> _mapUpdateServiceStatusToState(
      UpdateServiceStatus event) async* {
    developer.log(
        'Service found: ${event.serviceUuid}, updating status: ${event.status.toString()}');

    final newService = state.service.copyWith(
      status: event.status.name,
    );

    yield CurrentServiceChatroomState.putService(
      state,
      service: newService,
    );
  }
}
