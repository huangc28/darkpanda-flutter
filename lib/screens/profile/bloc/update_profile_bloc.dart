import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/chat_image.dart';
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
    } else if (event is AvatarImageChanged) {
      yield _mapAvatarImageChangedToState(event, state);
    } else if (event is NicknameChanged) {
      yield _mapNicknameChangedToState(event, state);
    }
  }

  Stream<UpdateProfileState> _mapUpdateUserProfileToState(
      UpdateUserProfile event, UpdateProfileState state) async* {
    try {
      yield UpdateProfileState.updating(
        UpdateProfileState.copyFrom(state),
      );

      // 1. Upload avatar image
      String avatarImageLink = state.avatarUrl == "" ? null : state.avatarUrl;

      if (event.avatarImage != null) {
        final resAvatarImage =
            await profileApiClient.updateAvatarImage(event.avatarImage);

        if (resAvatarImage != null) {
          if (resAvatarImage.statusCode != HttpStatus.ok) {
            throw APIException.fromJson(json.decode(resAvatarImage.body));
          }
        }

        final Map<String, dynamic> resultAvatar =
            json.decode(resAvatarImage.body);

        ChatImage avatarImageList = ChatImage.fromMap(resultAvatar);

        avatarImageLink = avatarImageList.thumbnails[0];
      }

      // 2. Upload image listing
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

        ChatImage chatImage = ChatImage.fromMap(result);

        imageStringList = chatImage.thumbnails
            .map<UserImage>((image) => UserImage(url: image))
            .toList();
      }

      // 3. Update user profile
      UserProfile userProfile = await getUserProfile(
        state,
        imageStringList,
        removeImageList,
        avatarImageLink,
        event.userProfile,
      );

      updateProfile = new UpdateProfile(userProfile: userProfile);

      final res = await profileApiClient.updateUserProfile(updateProfile);

      if (res != null) {
        if (res.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(res.body));
        }
      }

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

  UpdateProfileState _mapAvatarImageChangedToState(
    AvatarImageChanged event,
    UpdateProfileState state,
  ) {
    final avatarImage = event.avatarImage;

    return state.copyWith(
      avatarImage: avatarImage,
    );
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

  Stream<UpdateProfileState> _mapUserLoadedToState(
    FetchProfileEdit event,
    UpdateProfileState state,
  ) async* {
    if (event is FetchProfileEdit) {
      try {
        final UserProfile userProfile = event.userProfile;
        double age;
        double height;
        double weight;

        for (int i = 0; i < userProfile.traits.length; i++) {
          if (userProfile.traits[i].type == 'age') {
            age = userProfile.traits[i].value;
          } else if (userProfile.traits[i].type == 'height') {
            height = userProfile.traits[i].value;
          } else {
            weight = userProfile.traits[i].value;
          }
        }

        yield (state.copyWith(
          ready: true,
          uuid: userProfile.uuid,
          username: userProfile.username,
          nickname: userProfile.nickname,
          age: age == null ? age : age.toInt(),
          height: height,
          weight: weight,
          description: userProfile.description,
          avatarUrl: userProfile.avatarUrl,
        ));
      } catch (_) {
        yield (state.copyWith(
          ready: false,
        ));
      }
    }
  }

  Future<UserProfile> getUserProfile(
      state, imageList, removeImageList, avatarUrl, userProfile) async {
    UserProfile createPetObject;

    createPetObject = new UserProfile(
      uuid: state.uuid,
      username: state.username,
      age: userProfile.age,
      height: userProfile.height,
      weight: userProfile.weight,
      description: userProfile.description,
      imageList: imageList,
      removeImageList: removeImageList,
      avatarUrl: avatarUrl,
    );

    return createPetObject;
  }
}
