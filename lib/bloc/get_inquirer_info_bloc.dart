import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_inquirer_info_event.dart';
part 'get_inquirer_info_state.dart';

class GetInquirerInfoBloc
    extends Bloc<GetInquirerInfoEvent, GetInquirerInfoState> {
  GetInquirerInfoBloc() : super(GetInquirerInfoState.initial());

  @override
  Stream<GetInquirerInfoState> mapEventToState(
    GetInquirerInfoEvent event,
  ) async* {
    if (event is GetInquirerInfo) {
      yield* _mapGetInquirerInfoToState(event);
    }
  }

  Stream<GetInquirerInfoState> _mapGetInquirerInfoToState(
      GetInquirerInfo event) async* {
    yield null;
  }
}
