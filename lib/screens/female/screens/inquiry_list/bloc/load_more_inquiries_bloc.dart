import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/util/util.dart';

import '../../../models/inquiry.dart';
import '../services/api_client.dart';
import './inquiries_bloc.dart';

part 'load_more_inquiries_event.dart';
part 'load_more_inquiries_state.dart';

class LoadMoreInquiriesBloc
    extends Bloc<LoadMoreInquiriesEvent, LoadMoreInquiriesState> {
  LoadMoreInquiriesBloc({
    this.inquiriesBloc,
    this.mockedApiToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMmM4MDhjNDEtYWI5OS00ODE3LWE0MzYtYjI5YzJhNjVmNWVhIiwiYXV0aG9yaXplZCI6ZmFsc2UsImV4cCI6MTYwMDgwNTY1NH0.q6enlJb8Zwr9bHwurIQqK5aW4IPAW8I1WYMEMzqm8no',
    this.apiClient,
  })  : assert(inquiriesBloc != null),
        assert(apiClient != null),
        super(LoadMoreInquiriesState.initial());

  final InquiriesBloc inquiriesBloc;

  final ApiClient apiClient;

  /// @TODO mocked api token, should be removed.
  final String mockedApiToken;

  StreamSubscription _inquiriesBlocSubscription;

  int currentPage;

  @override
  Stream<LoadMoreInquiriesState> mapEventToState(
    LoadMoreInquiriesEvent event,
  ) async* {
    if (event is LoadMoreInquiries) {
      yield* _mapLoadMoreInquiriesToState(event);
    }
  }

  Stream<LoadMoreInquiriesState> _mapLoadMoreInquiriesToState(
      LoadMoreInquiries event) async* {
    try {
      // toggle fetching event
      yield LoadMoreInquiriesState.loading();

      this.apiClient.jwtToken = mockedApiToken;

      // fetching data from remote, emit fetched event.
      final resp = await apiClient.fetchInquiries(
        offset: calcNextPageOffset(
          nextPage: event.nextPage,
          perPage: event.perPage,
        ),
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }
      // print('DEBUG lm 1 ${resp.body}');

      final dataMap = json.decode(resp.body);

      final newInquiries = dataMap['inquiries']
          .map<Inquiry>((data) => Inquiry.fromJson(data))
          .toList();

      print('DEBUG lm 3 ${newInquiries}');
      inquiriesBloc.add(AppendInquiries(inquiries: newInquiries));
    } on APIException catch (e) {
      print('DEBUG 2 ${e.message}');
      // yield InquiriesState.fetchFailed(
      //   state,
      //   error: e,
      // );
    } catch (e) {
      // print('DEBUG 2 $e');
      // yield InquiriesState.fetchFailed(
      //   state,
      //   error: AppGeneralExeption(
      //     message: e.toString(),
      //   ),
      // );
    }
  }

  @override
  close() async => Future.wait(<Future>[
        _inquiriesBlocSubscription.cancel(),
        super.close(),
      ]);
}
