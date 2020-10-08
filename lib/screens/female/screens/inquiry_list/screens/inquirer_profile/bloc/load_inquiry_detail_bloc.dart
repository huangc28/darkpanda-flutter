import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'load_inquiry_detail_event.dart';
part 'load_inquiry_detail_state.dart';

class LoadInquiryDetailBloc
    extends Bloc<FetchInquiryDetailEvent, LoadInquiryDetailState> {
  LoadInquiryDetailBloc() : super(LoadInquiryDetailState.initial());

  @override
  Stream<LoadInquiryDetailState> mapEventToState(
    FetchInquiryDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
