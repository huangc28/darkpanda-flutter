import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

part 'update_inquitry_notifier_event.dart';
part 'update_inquitry_notifier_state.dart';

class UpdateInquiryNotifierBloc
    extends Bloc<UpdateInquiryNotifierEvent, UpdateInquiryNotifierState> {
  UpdateInquiryNotifierBloc() : super(UpdateInquiryNotifierInitial());

  @override
  Stream<UpdateInquiryNotifierState> mapEventToState(
    UpdateInquiryNotifierEvent event,
  ) async* {
    yield UpdateInquiryNotify(event.message);
  }
}
