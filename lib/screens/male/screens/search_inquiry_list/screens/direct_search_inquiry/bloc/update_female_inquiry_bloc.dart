import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/models/female_list.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'update_female_inquiry_event.dart';
part 'update_female_inquiry_state.dart';

class UpdateFemaleInquiryBloc
    extends Bloc<UpdateFemaleInquiryEvent, UpdateFemaleInquiryState> {
  UpdateFemaleInquiryBloc() : super(UpdateFemaleInquiryState.initial());

  @override
  Stream<UpdateFemaleInquiryState> mapEventToState(
    UpdateFemaleInquiryEvent event,
  ) async* {
    if (event is UpdateFemaleInquiry) {
      yield* _mapUpdateFemaleInquiryToState(event);
    } else if (event is UpdateInquiryStatus) {
      yield* _mapUpdateInquiryStatusToState(event);
    }
  }

  Stream<UpdateFemaleInquiryState> _mapUpdateFemaleInquiryToState(
      UpdateFemaleInquiry event) async* {
    try {
      yield UpdateFemaleInquiryState.loading(state);

      final FemaleUser femaleUser = event.femaleUser;

      yield UpdateFemaleInquiryState.loaded(
        state,
        femaleUser: femaleUser,
        inquiryStreamMap: _createInquirySubscriptionStreamMap(femaleUser),
      );
    } on APIException catch (e) {
      yield UpdateFemaleInquiryState.loadFailed(state, e);
    } catch (e) {
      yield UpdateFemaleInquiryState.loadFailed(
        state,
        AppGeneralExeption(message: e.toString()),
      );
    }
  }

  Map<String, StreamSubscription<DocumentSnapshot>>
      _createInquirySubscriptionStreamMap(FemaleUser femaleUsers) {
    Map<String, StreamSubscription<DocumentSnapshot>> _streamMap = {};

    if (femaleUsers.inquiryStatus == InquiryStatus.asking ||
        femaleUsers.inquiryStatus == InquiryStatus.chatting) {
      _streamMap[femaleUsers.inquiryUuid] =
          _createInquirySubscriptionStream(femaleUsers.inquiryUuid);
    }

    return _streamMap;
  }

  StreamSubscription<DocumentSnapshot> _createInquirySubscriptionStream(
      String inquiryUuid) {
    return FirebaseFirestore.instance
        .collection('inquiries')
        .doc(inquiryUuid)
        .snapshots()
        .listen(
      (DocumentSnapshot snapshot) {
        // If male user alter the inquiry to either `canceled` or `chatting`, We need to update
        // the inquiry status in the app to reflect on the screen.
        _handleInquiryStatusChange(inquiryUuid, snapshot);
      },
    );
  }

  _handleInquiryStatusChange(String inquiryUuid, DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    String iqStatus = data['status'] as String;
    String iqChannelUuid = data['channel_uuid'] as String;
    String iqServiceUuid = data['service_uuid'] as String;

    developer.log(
        'firestore inquiry changes recieved: ${snapshot.data().toString()}');

    add(
      UpdateInquiryStatus(
        inquiryUuid: inquiryUuid,
        channelUuid: iqChannelUuid,
        serviceUuid: iqServiceUuid,
        inquiryStatus: iqStatus.toInquiryStatusEnum(),
      ),
    );
  }

  Stream<UpdateFemaleInquiryState> _mapUpdateInquiryStatusToState(
      UpdateInquiryStatus event) async* {
    final updatedInquiry = state.femaleUser.copyWith(
      inquiryUuid: event.inquiryUuid,
      channelUuid: event.channelUuid,
      serviceUuid: event.serviceUuid,
      inquiryStatus: event.inquiryStatus,
    );

    // Replace current inquiry list witht updated list.
    yield UpdateFemaleInquiryState.putInquiries(
      state,
      femaleUser: updatedInquiry,
    );
  }
}
