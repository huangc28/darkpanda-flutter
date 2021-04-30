import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/profile/models/update_profile.dart';
import 'package:darkpanda_flutter/screens/profile/services/profile_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../../../models/user_profile.dart' as models;

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({
    this.profileApiClient,
  }) : super(UpdateProfileState.initial());

  final ProfileApiClient profileApiClient;

  @override
  Stream<UpdateProfileState> mapEventToState(
    UpdateProfileEvent event,
  ) async* {
    if (event is FetchProfileEdit) {
      yield* _mapUserLoadedToState(event, state);
    } else if (event is UpdateUserProfile) {
      yield* _mapUpdateUserProfileToState(event, state);
    } else if (event is UpdateUserImage) {
      yield* _mapUpdateUserImageToState(event, state);
    } else if (event is NicknameChanged) {
      yield _mapNicknameChangedToState(event, state);
    } else if (event is AgeChanged) {
      yield _mapAgeChangedToState(event, state);
    } else if (event is HeightChanged) {
      yield _mapHeightChangedToState(event, state);
    } else if (event is WeightChanged) {
      yield _mapWeightChangedToState(event, state);
    } else if (event is DescriptionChanged) {
      yield _mapDescriptionChangedToState(event, state);
    }
  }

  Stream<UpdateProfileState> _mapUpdateUserProfileToState(
      UpdateUserProfile event, UpdateProfileState state) async* {
    try {
      yield UpdateProfileState.updating(
        UpdateProfileState.copyFrom(state),
      );

      List<UserImage> imageList = event.imageList;
      List<UserImage> removeImageList = event.removeImageList;

      UpdateProfile updateProfile = new UpdateProfile(userImageList: imageList);

      final resp = await profileApiClient.updateUserProfileImage(updateProfile);

      List<UserImage> imageStringList = [];

      if (resp != null) {
        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        final Map<String, dynamic> result = json.decode(resp.body);

        imageStringList = result['links']
            .map<UserImage>((image) => UserImage(url: image))
            .toList();
      }

      UserProfile userProfile =
          await getUserProfile(state, imageStringList, removeImageList);

      updateProfile = new UpdateProfile(userProfile: userProfile);

      await profileApiClient.updateUserProfile(updateProfile);

      yield UpdateProfileState.updated();
    } on APIException catch (e) {
      yield UpdateProfileState.updateFailed(UpdateProfileState.copyFrom(
        state,
        error: e,
      ));
    } catch (e) {
      yield UpdateProfileState.updateFailed(
        UpdateProfileState.copyFrom(
          state,
          error: AppGeneralExeption(message: e.toString()),
        ),
      );
    }
  }

  Stream<UpdateProfileState> _mapUpdateUserImageToState(
      UpdateUserImage event, UpdateProfileState state) async* {
    try {
      yield UpdateProfileState.updated();
    } on APIException catch (e) {
      yield UpdateProfileState.updateFailed(UpdateProfileState.copyFrom(
        state,
        error: e,
      ));
    } catch (e) {
      yield UpdateProfileState.updateFailed(
        UpdateProfileState.copyFrom(
          state,
          error: AppGeneralExeption(message: e.toString()),
        ),
      );
    }
  }

  UpdateProfileState _mapNicknameChangedToState(
    NicknameChanged event,
    UpdateProfileState state,
  ) {
    final nickname = event.nickname;

    return state.copyWith(
      nickname: nickname,
    );
  }

  UpdateProfileState _mapAgeChangedToState(
    AgeChanged event,
    UpdateProfileState state,
  ) {
    final age = event.age;

    return state.copyWith(
      age: age,
    );
  }

  UpdateProfileState _mapHeightChangedToState(
    HeightChanged event,
    UpdateProfileState state,
  ) {
    final height = event.height;

    return state.copyWith(
      height: height,
    );
  }

  UpdateProfileState _mapWeightChangedToState(
    WeightChanged event,
    UpdateProfileState state,
  ) {
    final weight = event.weight;

    return state.copyWith(
      weight: weight,
    );
  }

  UpdateProfileState _mapDescriptionChangedToState(
    DescriptionChanged event,
    UpdateProfileState state,
  ) {
    final description = event.description;

    return state.copyWith(
      description: description,
    );
  }

  Stream<UpdateProfileState> _mapUserLoadedToState(
    FetchProfileEdit event,
    UpdateProfileState state,
  ) async* {
    if (event is FetchProfileEdit) {
      try {
        final UserProfile userProfile = event.userProfile;

        yield (state.copyWith(
          ready: true,
          uuid: userProfile.uuid,
          username: userProfile.username,
          nickname: userProfile.nickname,
          age: userProfile.age,
          height: userProfile.height,
          weight: userProfile.weight,
          description: userProfile.description,
        ));
      } catch (_) {
        yield (state.copyWith(
          ready: false,
        ));
      }
    }
  }

  Future<UserProfile> getUserProfile(state, imageList, removeImageList) async {
    UserProfile createPetObject;

    createPetObject = new UserProfile(
      uuid: state.uuid,
      username: state.username,
      age: state.age,
      height: state.height,
      weight: state.weight,
      description: state.description,
      imageList: imageList,
      removeImageList: removeImageList,
    );

    return createPetObject;
  }
}
