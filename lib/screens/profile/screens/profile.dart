import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';
import 'package:darkpanda_flutter/screens/profile/services/profile_api_client.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'components/review.dart';
import 'edit_profile/edit_profile.dart';

class DemoImage {
  final String image;

  DemoImage({this.image});
}

// class DemoReview {
//   final String image;
//   final String name;
//   final String description;
//   final String date;
//   final int rate;

//   DemoReview({
//     this.image,
//     this.name,
//     this.description,
//     this.date,
//     this.rate,
//   });
// }

class LabelList {
  final String description;

  LabelList({this.description});
}

class Profile extends StatefulWidget {
  final LoadUserBloc loadUserBloc;
  final UserProfile args;
  final Function(String, UserProfile) onPush;

  const Profile({this.loadUserBloc, this.args, this.onPush});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthUser _sender;
  LoadUserImagesBloc loadUserImagesBloc;
  List<UserImage> userImageList = [];

  UserRatings userRatings = UserRatings();

  @override
  void initState() {
    super.initState();
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    // print(_sender.jwt);
    widget.loadUserBloc.add(
      LoadUser(uuid: _sender.uuid),
    );

    loadUserImagesBloc = BlocProvider.of<LoadUserImagesBloc>(context);
    loadUserImagesBloc.add(LoadUserImages(uuid: _sender.uuid));

    BlocProvider.of<LoadRateBloc>(context).add(LoadRate(uuid: _sender.uuid));
  }

  @override
  void dispose() {
    widget.loadUserBloc.add(ClearUserState());
    loadUserImagesBloc.add(ClearUserImagesState());

    super.dispose();
  }

  @override
  void deactivate() {
    widget.loadUserBloc.add(ClearUserState());
    loadUserImagesBloc.add(ClearUserImagesState());

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildProfileDetail(),
                    BlocBuilder<LoadRateBloc, LoadRateState>(
                      builder: (context, state) {
                        if (state.status == AsyncLoadingStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error.message),
                            ),
                          );

                          return Container();
                        }
                        if (state.status == AsyncLoadingStatus.done) {
                          userRatings = state.userRatings;

                          return Column(
                            children: List.generate(
                                userRatings.userRatings.length, (index) {
                              return Review(
                                  review: userRatings.userRatings[index]);
                            }),
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              LoadingScreen(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 16,
        left: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 10),
          Text(
            '個人主頁',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.screenWidth * 0.05,
          SizeConfig.screenHeight * 0.03,
          SizeConfig.screenWidth * 0.05,
          SizeConfig.screenHeight * 0.03,
        ),
        child: BlocConsumer<LoadUserBloc, LoadUserState>(
          listener: (BuildContext context, LoadUserState state) {},
          builder: (BuildContext context, LoadUserState state) {
            if (state.status == AsyncLoadingStatus.initial ||
                state.status == AsyncLoadingStatus.loading) {
              return Row(
                children: [
                  LoadingScreen(),
                ],
              );
            }
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: state?.userProfile?.avatarUrl == "" ||
                              state?.userProfile?.avatarUrl == null
                          ? AssetImage("assets/logo.png")
                          : NetworkImage(state?.userProfile?.avatarUrl),
                    ),
                    SizedBox(width: SizeConfig.screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                state?.userProfile?.username == null
                                    ? ''
                                    : state?.userProfile?.username,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.025),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  navigateUpdateProfilePage(
                                      state, userImageList);
                                },
                                child: Image(
                                  width: 24,
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                      "lib/screens/profile/assets/edit_profile.png"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: state.userProfile.traits.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return traitsLabel(state.userProfile.traits[index]);
                    },
                  ),
                ),
                descriptionText(state),
                imageList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget imageList() {
    return BlocConsumer<LoadUserImagesBloc, LoadUserImagesState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          for (var i = 0; i < state.userImages.length; i++) {
            if (state.userImages[i].url == null ||
                state.userImages[i].url == "") {
              state.userImages.removeAt(i);
              i--;
            }
          }
        }
      },
      builder: (context, state) {
        userImageList = state.userImages;

        if (state.status == AsyncLoadingStatus.initial ||
            state.status == AsyncLoadingStatus.loading) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        }

        return state.userImages.length > 0
            ? Container(
                height: 190,
                padding: EdgeInsets.only(top: 25),
                child: ListView.builder(
                  itemCount:
                      state.userImages[state.userImages.length - 1].url == ""
                          ? state.userImages.length - 1
                          : state.userImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: ImageCard(image: state.userImages[index].url),
                    );
                  },
                ),
              )
            : SizedBox();
      },
    );
  }

  // write this way is to call inistate after pop from edit profile page
  void navigateUpdateProfilePage(state, userImage) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UpdateProfileBloc(
                profileApiClient: ProfileApiClient(),
              ),
            ),
          ],
          child: EditProfile(
            args: state.userProfile,
            imageList: userImage,
          ),
        );
      },
    );

    Navigator.of(context, rootNavigator: true).push(route).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      widget.loadUserBloc.add(
        LoadUser(
          uuid: _sender.uuid,
        ),
      );
      loadUserImagesBloc.add(ClearUserImagesState());
      loadUserImagesBloc.add(LoadUserImages(uuid: _sender.uuid));
    });
  }

  Widget traitsLabel(trait) {
    String label = '岁';
    dynamic value = '';
    double paddingHeight = 2.0;

    if (trait.type == 'age') {
      label = '岁';
      value = trait.value.toInt();
      paddingHeight = 2.0;
    } else if (trait.type == 'height') {
      label = 'm';
      value = trait.value;
      paddingHeight = 6.0;
    } else {
      label = 'kg';
      value = trait.value;
      paddingHeight = 6.0;
    }

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding:
              EdgeInsets.fromLTRB(10.0, paddingHeight, 10.0, paddingHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Text(
            value.toString() + label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget descriptionText(state) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.screenHeight * 0.02, //16.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          state?.userProfile?.description == null ||
                  state?.userProfile?.description == ""
              ? '沒有內容'
              : state.userProfile.description,
          style: TextStyle(
            fontSize: 15, //SizeConfig.screenHeight * 0.02, //15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DescriptionList extends StatelessWidget {
  final LabelList label;

  const DescriptionList({
    Key key,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0.0,
          10.0, //SizeConfig.screenHeight * 0.02, //10.0,
          10.0,
          0.0,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Text(
            label.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatefulWidget {
  final String image;

  const ImageCard({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  _ImageCardState createState() => _ImageCardState(this.image);
}

class _ImageCardState extends State<ImageCard> {
  final String image;

  _ImageCardState(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Image.network(
            image,
            fit: BoxFit.cover,
            height: 150,
          ),
        ],
      ),
    );
  }
}

class ImageCardFile extends StatefulWidget {
  final File image;

  const ImageCardFile({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  _ImageCardFileState createState() => _ImageCardFileState(this.image);
}

class _ImageCardFileState extends State<ImageCardFile> {
  final File image;

  _ImageCardFileState(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Image.file(
            image,
            height: 150,
          ),
        ],
      ),
    );
  }
}
