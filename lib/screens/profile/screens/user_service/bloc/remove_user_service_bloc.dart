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

part 'remove_user_service_event.dart';
part 'remove_user_service_state.dart';

class RemoveUserServiceBloc
    extends Bloc<RemoveUserServiceEvent, RemoveUserServiceState> {
  RemoveUserServiceBloc({
    this.searchInquiryAPIs,
    this.loadInquiryBloc,
  }) : super(RemoveUserServiceState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadInquiryBloc loadInquiryBloc;

  @override
  Stream<RemoveUserServiceState> mapEventToState(
    RemoveUserServiceEvent event,
  ) async* {
    if (event is RemoveUserService) {
      yield* _mapRemoveUserServiceToState(event);
    }
  }

  Stream<RemoveUserServiceState> _mapRemoveUserServiceToState(
      RemoveUserService event) async* {
    try {
      yield RemoveUserServiceState.loading();

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

      yield RemoveUserServiceState.done();
    } on APIException catch (e) {
      yield RemoveUserServiceState.error(e);
    } catch (e) {
      yield RemoveUserServiceState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
