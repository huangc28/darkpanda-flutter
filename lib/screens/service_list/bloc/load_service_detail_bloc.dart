import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/inquiry_chat_messages_bloc.dart';

import '../models/historical_service.dart';
import '../services/service_chatroom_api.dart';

part 'load_service_detail_event.dart';
part 'load_service_detail_state.dart';

class LoadServiceDetailBloc
    extends Bloc<LoadServiceDetailEvent, LoadServiceDetailState> {
  LoadServiceDetailBloc({
    this.apiClient,
  }) : super(LoadServiceDetailState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<LoadServiceDetailState> mapEventToState(
    LoadServiceDetailEvent event,
  ) async* {
    if (event is LoadServiceDetail) {
      yield* _mapLoadServiceDetailEventToState(event);
    }
  }

  Stream<LoadServiceDetailState> _mapLoadServiceDetailEventToState(
      LoadServiceDetail event) async* {
    try {
      // toggle loading
      yield LoadServiceDetailState.loading(state);

      // request API
      final res = await apiClient.fetchOverdueService();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(res.body);

      final serviceList = respMap['services'].map<HistoricalService>((v) {
        return HistoricalService.fromMap(v);
      }).toList();

      add(
        AddChatrooms(serviceList),
      );
    } on APIException catch (err) {
      yield LoadServiceDetailState.loadFailed(state, err);
    } catch (err) {
      yield LoadServiceDetailState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
