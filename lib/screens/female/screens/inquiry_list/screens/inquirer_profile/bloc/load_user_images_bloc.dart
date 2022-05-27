import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/util/util.dart';

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
    if (event is LoadUserImages) {
      yield* _mapLoadUserImagesToState(event);
    } else if (event is ClearUserImagesState) {
      yield* _mapClearUserImagesStateToState(event);
    }
  }

  Stream<LoadUserImagesState> _mapLoadUserImagesToState(
      LoadUserImages event) async* {
    try {
      yield LoadUserImagesState.loading(state);

      // final jwt = await SecureStore().readJwtToken();
      final offset = calcNextPageOffset(
        nextPage: event.pageNum,
        perPage: 9,
      );

      // userApi.jwtToken = jwt;
      final resp = await userApi.fetchUserImages(
        event.uuid,
        offset,
      );

      final respMap = json.decode(resp.body);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final userImages = respMap['images']
          .map<UserImage>((image) => UserImage(url: image['url']))
          .toList();

      final appended = <UserImage>[
        ...state.userImages,
        ...?userImages,
      ].toList();

      final pageNum =
          userImages.length == 0 ? state.currentPage : event.pageNum;

      yield LoadUserImagesState.loaded(
        appended,
        pageNum,
      );
    } on APIException catch (err) {
      yield LoadUserImagesState.loadFailed(
        state,
        error: err,
      );
    } catch (err) {
      yield LoadUserImagesState.loadFailed(
        state,
        error: AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
  }

  Stream<LoadUserImagesState> _mapClearUserImagesStateToState(
      ClearUserImagesState event) async* {
    yield LoadUserImagesState.clearState(state);
  }
}
