import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'get_inquiry_event.dart';
part 'get_inquiry_state.dart';

class GetInquiryBloc extends Bloc<GetInquiryEvent, GetInquiryState> {
  GetInquiryBloc() : super(GetInquiryState.init());

  @override
  Stream<GetInquiryState> mapEventToState(
    GetInquiryEvent event,
  ) async* {
    if (event is GetInquiry) {
      yield* _mapGetInquiryToState(event);
    }
  }

  Stream<GetInquiryState> _mapGetInquiryToState(GetInquiry event) async* {
    print('DEBUG trigger _mapGetInquiryToState ${event.inquiryUuid}');

    yield null;
  }
}
