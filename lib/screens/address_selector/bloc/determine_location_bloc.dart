import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/apis.dart';
import '../models/location.dart';

part 'determine_location_event.dart';
part 'determine_location_state.dart';

/// Set the default location to be Taipei 101 if
/// both inquiry address and current location are
/// unretrievable from the device.
const defaultLocation = Location(
  latitude: 25.033976,
  longtitude: 121.5623502,
);

class DetermineLocationBloc
    extends Bloc<DetermineLocationEvent, DetermineLocationState> {
  DetermineLocationBloc({
    this.apiClient,
  })  : assert(apiClient != null),
        super(
          DetermineLocationState.init(),
        );

  final AddressSelectorAPIClient apiClient;

  @override
  Stream<DetermineLocationState> mapEventToState(
    DetermineLocationEvent event,
  ) async* {
    if (event is DetermineCurrentLocation) {
      yield* _mapDetermineCurrentLocationToState(event);
    }

    if (event is DetermineLocationFromAddress) {
      yield* _mapDetermineLocationFromAddress(event);
    }

    // if (event is DetermineAddressFromLocation) {
    //   yield* _mapDetermineAddressFromLocationToState(event);
    // }
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///
  /// Please refer to the official document.
  Future<Position> _determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Stream<DetermineLocationState> _mapDetermineCurrentLocationToState(
      DetermineCurrentLocation event) async* {
    yield DetermineLocationState.loading();

    try {
      final position = await _determineCurrentPosition();

      yield DetermineLocationState.done(
        Location(
          longtitude: position.longitude,
          latitude: position.latitude,
        ),
      );
    } catch (e) {
      // User denied to shared current location. we should have a default location to draw
      // on the map.
      developer.log(
          'Failed to be granted location permission on device. Using default location instead');

      yield DetermineLocationState.done(defaultLocation);
    }
  }

  Stream<DetermineLocationState> _mapDetermineLocationFromAddress(
      DetermineLocationFromAddress event) async* {
    yield DetermineLocationState.loading();
    try {
      final resp = await apiClient.getCoordinateFromAddress(event.address);

      if (resp.statusCode != HttpStatus.ok) {
        final err = json.decode(resp.body);
        throw APIException(message: err['error_message']);
      }

      final resMap = json.decode(resp.body);
      final locations = resMap['results']
          .map<Location>(
            (res) => Location.fromMap(res['geometry']['location']),
          )
          .toList();

      // If result is an empty array, we throw an exception to notify the user that the address is not found.
      if (locations.length == 0) {
        developer.log(
            'Address undetermined, location not found ${event.address}. Determining current location...');

        // We retrieve current location to initialize the map instead!
        add(DetermineCurrentLocation());

        throw AppBaseException(
            message: 'Address undetermined, location not found');
      }

      // If results is not an empty array, we retrieve the first element in the result array.
      final location = locations[0];

      yield DetermineLocationState.done(location);
    } on APIException catch (e) {
      yield DetermineLocationState.error(e);
    } catch (e) {
      yield DetermineLocationState.error(e);
    }
  }
}
