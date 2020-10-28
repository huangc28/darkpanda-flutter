import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/picked_inquiry.dart';

part 'picked_inquiries_dart_event.dart';
part 'picked_inquiries_dart_state.dart';

class PickedInquiriesDartBloc
    extends Bloc<PickedInquiriesDartEvent, PickedInquiriesDartState> {
  PickedInquiriesDartBloc() : super(PickedInquiriesDartState.init());

  @override
  Stream<PickedInquiriesDartState> mapEventToState(
    PickedInquiriesDartEvent event,
  ) async* {
    if (event is AddPickedInqiury) {
      yield* _mapAddPickedInquiry(event);
    }
  }

  Stream<PickedInquiriesDartState> _mapAddPickedInquiry(
      AddPickedInqiury event) async* {
    try {
      print(
          'DEBUG trigger 4 PickedInquiriesDartBloc ${event.pickedInquiry.channelUUID}');
      // Test the adding a sample user to collection in firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final data = await users.doc('me').get();

      print('DEBUG trigger 5 PickedInquiriesDartBloc ${data.data()}');

      // Subscribe to channel uuid provided by the backend
      // final subscription = await DarkPubNub().pubnub.subscribe(
      //   channels: {event.pickedInquiry.channelUUID},
      //   withPresence: true,
      // );

      // // Store subscription in a key map
      // print('DEBUG trigger 1 PickedInquiriesDartBloc $subscription');

      // // subscription.messages.listen(_messageListener);
      // subscription.messages.listen((event) {
      //   print('DEBUG trigger 4 PickedInquiriesDartBloc ${event.payload}');
      // });

      // print('DEBUG trigger 2 PickedInquiriesDartBloc ${DarkPubNub().pubnub}');
      yield null;
    } catch (err) {
      print('DEBUG trigger 3 PickedInquiriesDartBloc ${err.toString()}');
    }
  }

  // _messageListener(pn.Envelope event) {
  //   // event.
  //   print('DEBUG trigger 2 PickedInquiriesDartBloc ${event.payload}');
  // }
}
