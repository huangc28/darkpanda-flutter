import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/models/user_image.dart';

part 'load_user_images_event.dart';
part 'load_user_images_state.dart';

class LoadUserImagesBloc
    extends Bloc<LoadUserImagesEvent, LoadUserImagesState> {
  LoadUserImagesBloc({this.userApi})
      : assert(userApi != null),
        super(LoadUserImagesState.initial());

  final UserApis userApi;

  @override
  Stream<LoadUserImagesState> mapEventToState(
    LoadUserImagesEvent event,
  ) async* {
    print('DEBUG trigger LoadUserImagesBloc');
    if (event is LoadUserImages) {
      yield* _mapLoadUserImagesToState(event);
    }
  }

  Stream<LoadUserImagesState> _mapLoadUserImagesToState(
      LoadUserImages event) async* {
    try {
      yield LoadUserImagesState.loading();

      final jwt = await SecureStore().readJwtToken();

      userApi.jwtToken = jwt;
      final resp = await userApi.fetchUserImages(event.uuid);
      final respMap = json.decode(resp.body);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userImages = respMap['images']
          .map<UserImage>((image) => UserImage(url: image['url']))
          .toList();

      // print('DEBUG userImages ${userImages[0].url}');
      yield LoadUserImagesState.loaded(userImages);
    } on APIException catch (err) {
      yield LoadUserImagesState.loadFailed(err);
    } catch (err) {
      print('DEBUG 7 ${err.toString()}');
      // yield LoadUserImagesState.loadFailed(
      //     AppGeneralExeption(message: err.message));
    }
  }
}
