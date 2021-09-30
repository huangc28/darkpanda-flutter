import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review.dart';
import 'package:darkpanda_flutter/screens/profile/screens/profile.dart';

import './models/historical_service.dart';
import '../../screen_arguments/args.dart';

part 'components/inquirer_profile_status_bar.dart';
part 'components/inquirer_profile_tabs.dart';
part 'components/inquirer_profile_images.dart';
part 'components/inquirer_profile_services.dart';
part 'components/inquirer_description.dart';
part 'components/inquirer_gallery_image.dart';
part 'components/inquirer_comment_card.dart';
part 'components/inquirer_profile_page.dart';

enum ProfileTabs {
  images,
  transactions,
}

Map<ProfileTabs, ValueKey> ProfileTabKey = {
  ProfileTabs.images: ValueKey('images'),
  ProfileTabs.transactions: ValueKey('transactions'),
};

class InquirerProfile extends StatefulWidget {
  const InquirerProfile({
    this.args,
    this.loadUserBloc,
  });

  final LoadUserBloc loadUserBloc;
  final InquirerProfileArguments args;

  @override
  _InquirerProfileState createState() => _InquirerProfileState();
}

class _InquirerProfileState extends State<InquirerProfile>
    with SingleTickerProviderStateMixin {
  UserRatings userRatings = UserRatings();
  UserProfile userProfile = UserProfile();
  List<UserImage> userImages;

  AsyncLoadingStatus _userProfileStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _userRatingsStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _userImagesStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    widget.loadUserBloc.add(
      LoadUser(uuid: widget.args.uuid),
    );

    BlocProvider.of<LoadUserImagesBloc>(context)
        .add(LoadUserImages(uuid: widget.args.uuid));

    BlocProvider.of<LoadRateBloc>(context)
        .add(LoadRate(uuid: widget.args.uuid));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('檔案'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<LoadUserBloc, LoadUserState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userProfile = state.userProfile;
                }

                setState(() {
                  _userProfileStatus = state.status;
                });
              },
            ),
            BlocListener<LoadUserImagesBloc, LoadUserImagesState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userImages = state.userImages;
                }

                setState(() {
                  _userImagesStatus = state.status;
                });
              },
            ),
            BlocListener<LoadRateBloc, LoadRateState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userRatings = state.userRatings;
                }

                setState(() {
                  _userRatingsStatus = state.status;
                });
              },
            ),
          ],
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: InquirerProfilePage(
              userProfile: userProfile,
              userRatings: userRatings,
              userImages: userImages,
              userProfileStatus: _userProfileStatus,
              userRatingsStatus: _userRatingsStatus,
              userImagesStatus: _userImagesStatus,
            ),
          ),
        ),
      ),
    );
  }
}
