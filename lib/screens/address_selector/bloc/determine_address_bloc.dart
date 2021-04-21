import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/address.dart';

part 'determine_address_event.dart';
part 'determine_address_state.dart';

class DetermineAddressBloc
    extends Bloc<DetermineAddressEvent, DetermineAddressState> {
  DetermineAddressBloc({
    this.apiClient,
  }) : super(DetermineAddressInitial());

  final AddressSelectorAPIClient apiClient;

  @override
  Stream<DetermineAddressState> mapEventToState(
    DetermineAddressEvent event,
  ) async* {
    if (event is DetermineAddressFromLocation) {
      yield* _mapDetermineAddressFromLocationToState(event);
    }
  }

  Stream<DetermineAddressState> _mapDetermineAddressFromLocationToState(
      DetermineAddressFromLocation event) async* {
    try {
      final resp = await apiClient.getAddressFromLocation(
        event.latitude,
        event.longtitude,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException(message: 'Failed to get address from location.');
      }

      final respMap = json.decode(resp.body);

      List<AddressComponent> results = respMap['results'][0]
              ['address_components']
          .map<AddressComponent>((data) => AddressComponent.fromMap(data))
          .toList();

      // Convert response body to address model.
      final address = results.reversed
          .skip(2)
          .fold('', (value, element) => '${value}${element.shortName}');

      yield DetermineAddressDone(
        address: Address(address: address),
      );
    } on APIException catch (e) {
      yield DetermineAddressError(e);
    } catch (e) {
      yield DetermineAddressError(
        AppGeneralExeption(message: e.toString()),
      );
    }
  }
}
