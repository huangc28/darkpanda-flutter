import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/models/error.dart';

import '../data_provider.dart';

part 'mobile_verify_event.dart';
part 'mobile_verify_state.dart';

class MobileVerifyBloc extends Bloc<MobileVerifyEvent, MobileVerifyState> {
  final PhoneVerifyDataProvider dataProvider;

  MobileVerifyBloc({this.dataProvider})
      : assert(dataProvider != null),
        super(MobileVerifyState.unknown());

  @override
  Stream<MobileVerifyState> mapEventToState(
    MobileVerifyEvent event,
  ) async* {
    // if (event is SendSMSCode) {
    // try {
    //     yield MobileVerifyState.verifying();

    //     print('DEBUG 998');

    //     final resp = await dataProvider.verifyPhone(
    //       countryCode: event.countryCode,
    //       mobileNumber: event.mobileNumber,
    //       uuid: event.uuid,
    //     );

    //     print('DEBUG 999 ${resp.body}');

    //     if (resp.statusCode != HttpStatus.ok) {}

    //     //print('DEBUG 87 ${event.countryCode} ${event.uuid}');
    //     // print('DEBUG 87 gg ${resp.body}');
    //   } catch (e) {
    //     print('DEBUG ${e.toString()}');
    //   }
    // }
  }
}
