import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'add_user_service_event.dart';
part 'add_user_service_state.dart';

class AddUserServiceBloc
    extends Bloc<AddUserServiceEvent, AddUserServiceState> {
  AddUserServiceBloc({
    this.searchInquiryAPIs,
    this.loadInquiryBloc,
  }) : super(AddUserServiceState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadInquiryBloc loadInquiryBloc;

  @override
  Stream<AddUserServiceState> mapEventToState(
    AddUserServiceEvent event,
  ) async* {
    if (event is AddUserService) {
      yield* _mapAddUserServiceToState(event);
    }
  }

  Stream<AddUserServiceState> _mapAddUserServiceToState(
      AddUserService event) async* {
    try {
      yield AddUserServiceState.loading();

      final resp = await searchInquiryAPIs.cancelInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      loadInquiryBloc.add(
        RemoveLoadInquiry(inquiryUuid: event.inquiryUuid),
      );

      yield AddUserServiceState.done();
    } on APIException catch (e) {
      yield AddUserServiceState.error(e);
    } catch (e) {
      yield AddUserServiceState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
