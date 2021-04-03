import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/util/util.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import '../services/api_client.dart';
import '../../../models/inquiry.dart';

part 'inquiries_event.dart';
part 'inquiries_state.dart';

class InquiriesBloc extends Bloc<InquiriesEvent, InquiriesState> {
  final ApiClient apiClient;

  InquiriesBloc({
    this.apiClient,
  }) : super(InquiriesState.initial());

  @override
  Stream<InquiriesState> mapEventToState(
    InquiriesEvent event,
  ) async* {
    if (event is FetchInquiries) {
      yield* _mapFetchInquiriesToState(event);
    }

    if (event is LoadMoreInquiries) {
      yield* _mapLoadMoreInquiries(event);
    }

    if (event is UpdateInquiryStatus) {
      yield* _mapUpdateInquiryStatusToState(event);
    }
  }

  Stream<InquiriesState> _mapFetchInquiriesToState(
      FetchInquiries event) async* {
    try {
      yield InquiriesState.fetching(state);
      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await apiClient.fetchInquiries(
        offset: offset,
      );

      // if response status is not OK, emit fail event
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model
      final dataMap = json.decode(resp.body);

      yield InquiriesState.fetched(
        state,
        inquiries: dataMap['inquiries']
            .map<Inquiry>((data) => Inquiry.fromJson(data))
            .toList(),
        currentPage: event.nextPage,
        hasMore: dataMap['has_more'],
      );
    } on APIException catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } on AppGeneralExeption catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.message,
        ),
      );
    }
  }

  Stream<InquiriesState> _mapLoadMoreInquiries(LoadMoreInquiries event) async* {
    try {
      yield InquiriesState.fetching(state);

      // If there are no more records to load, don't bother to request the API.
      if (!state.hasMore) {
        return;
      }

      final jwt = await SecureStore().fsc.read(key: 'jwt');

      this.apiClient.jwtToken = jwt;

      // Calculate the number to offset to skip when fetching the next page.
      final resp = await apiClient.fetchInquiries(
        offset: calcNextPageOffset(
          nextPage: state.currentPage + 1,
          perPage: event.perPage,
        ),
      );

      // if response status is not OK, emit fail event
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model
      final dataMap = json.decode(resp.body);
      final newInquiries = dataMap['inquiries']
          .map<Inquiry>((data) => Inquiry.fromJson(data))
          .toList();

      final appended = <Inquiry>[
        ...state.inquiries,
        ...?newInquiries,
      ].toList();

      yield InquiriesState.fetched(
        state,
        inquiries: appended,
        currentPage: state.currentPage + 1,
        hasMore: dataMap['has_more'],
      );
    } on APIException catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<InquiriesState> _mapUpdateInquiryStatusToState(
      UpdateInquiryStatus event) async* {
    // Iterate through current inquiries try to find the one that matches
    // the `uuid`. Update it's status.
    final updatedInquiries = state.inquiries.map<Inquiry>((inquiry) {
      // If matches in uuid, update it's inquiry status status.
      if (inquiry.uuid == event.inquiryUuid) {
        return inquiry.copyWith(
          inquiryStatus: event.inquiryStatus,
        );
      }

      return inquiry;
    }).toList();

    print('DEBUG 8811 ${updatedInquiries[0].inquiryStatus}');

    // Replace current inquiry list witht updated list.
    yield InquiriesState.putInquiries(
      state,
      inquiries: updatedInquiries,
    );
  }
}
