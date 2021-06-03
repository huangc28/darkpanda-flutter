import 'dart:async';
import 'dart:io';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/profile_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile/edit_profile.dart';

class DemoImage {
  final String image;

  DemoImage({this.image});
}

List demoImageList = [
  DemoImage(
    image: "assets/female_icon_active.png",
  ),
  DemoImage(
    image: "assets/female_icon_inactive.png",
  ),
  DemoImage(
    image: "assets/male_icon_active.png",
  ),
  DemoImage(
    image: "assets/male_icon_inactive.png",
  ),
];

class DemoReview {
  final String image;
  final String name;
  final String description;
  final String date;
  final int rate;

  DemoReview({this.image, this.name, this.description, this.date, this.rate});
}

List demoReviewList = [
  DemoReview(
    image: "assets/logo.png",
    name: "Jenny",
    description: "小姐姐人不錯，身材很好好，服務也不錯，就是希望下次能準時點。",
    date: "2020.05.20",
    rate: 5,
  ),
  DemoReview(
    image: "assets/logo.png",
    name: "Sally",
    description: "小姐姐人不錯，身材很好好，服務也不錯，就是希望下次能準時點。",
    date: "2021.05.20",
    rate: 3,
  ),
];

class LabelList {
  final String description;

  LabelList({this.description});
}

List demoLabelList = [
  LabelList(
    description: "身材",
  ),
  LabelList(
    description: "身材",
  ),
];

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

  @override
  void initState() {
    super.initState();
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    print(_sender.jwt);
    widget.loadUserBloc.add(
      LoadUser(uuid: _sender.uuid),
    );

    loadUserImagesBloc = BlocProvider.of<LoadUserImagesBloc>(context);
    loadUserImagesBloc.add(LoadUserImages(uuid: _sender.uuid));
  }

  @override
  void dispose() {
    widget.loadUserBloc.add(ClearUserState());

    super.dispose();
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
                    MyRating(),
                    Column(
                      children: List.generate(demoReviewList.length, (index) {
                        return Review(
                            context: context, review: demoReviewList[index]);
                      }),
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
      padding: EdgeInsets.only(top: 30, right: 16, left: 16, bottom: 16),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '个人主页',
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
        padding: const EdgeInsets.all(16.0),
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
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                state.userProfile.username,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  // widget.onPush(
                                  //     '/edit-profile', state.userProfile);
                                  navigateUpdateProfilePage(
                                      state, userImageList);
                                },
                                child: Image(
                                  image: AssetImage(
                                      "lib/screens/profile/assets/edit_profile.png"),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    children: <Widget>[
                                      state.userProfile.age != null &&
                                              state.userProfile.age != ""
                                          ? ageLabel(state)
                                          : SizedBox(),
                                      state.userProfile.height != null &&
                                              state.userProfile.age != ""
                                          ? heightLabel(state)
                                          : SizedBox(),
                                      state.userProfile.weight != null &&
                                              state.userProfile.age != ""
                                          ? weightLabel(state)
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                  ],
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
      listener: (context, state) {},
      builder: (context, state) {
        userImageList = state.userImages;
        for (var i = 0; i < state.userImages.length; i++) {
          if (state.userImages[i].url == null ||
              state.userImages[i].url == "") {
            state.userImages.removeAt(i);
            i--;
          }
        }
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

    Navigator.push(context, route).then(onGoBack);
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

  Widget ageLabel(state) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Text(
            state.userProfile.age.toString() + '岁',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget heightLabel(state) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Text(
            state.userProfile.height.toString() + 'm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget weightLabel(state) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Text(
            state.userProfile.weight.toString() + 'kg',
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
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          state.userProfile.description,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Review extends StatelessWidget {
  final context;
  final DemoReview review;

  const Review({
    Key key,
    this.context,
    this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(255, 255, 255, 0.1),
          border: Border.all(
            style: BorderStyle.solid,
            width: 0.5,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(review.image),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        review.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                child: StarDisplay(value: review.rate),
                              ),
                            ],
                          ),
                          Text(
                            review.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(106, 109, 137, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              review.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: List.generate(demoLabelList.length, (index) {
                        return DescriptionList(label: demoLabelList[index]);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
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

class MyRating extends StatelessWidget {
  const MyRating({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: new DecorationImage(
            image: new AssetImage(
                'lib/screens/profile/assets/my_rating_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 7.0,
                        width: 7.0,
                        transform: new Matrix4.identity()
                          ..rotateZ(45 * 3.1415927 / 180),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(254, 226, 136, 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '我的評價(13)',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: 18,
                        ),
                        child: StarDisplay(value: 3),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '4.2/5',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: <Widget>[
                          SizedBox(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                              child: Container(
                                // onPressed: () {},
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color.fromRGBO(190, 172, 255, 0.3),
                                ),
                                child: Text(
                                  '身材',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                              child: Container(
                                // onPressed: () {},
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color.fromRGBO(190, 172, 255, 0.3),
                                ),
                                child: Text(
                                  '身材',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            'Jenny',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, ProfileRoutes.editProfile);
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()),
                              );
                            },
                            child: Image(
                              image: AssetImage(
                                  "lib/screens/profile/assets/edit_profile.png"),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        // width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                children: <Widget>[
                                  SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 10.0, 10.0, 0.0),
                                      child: Container(
                                        // onPressed: () {},
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 2.0, 10.0, 2.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Color.fromRGBO(
                                              190, 172, 255, 0.3),
                                        ),
                                        child: Text(
                                          '22岁',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 10.0, 10.0, 0.0),
                                      child: Container(
                                        // onPressed: () {},
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 2.0, 10.0, 2.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Color.fromRGBO(
                                              190, 172, 255, 0.3),
                                        ),
                                        child: Text(
                                          '1.88m',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/logo.png"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "女生們看的真的不只是長相，尤其是想要追求一段長期關係的女生，只要順眼，大部分女生更在乎的是你到底是一個什麼樣的人。",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 190,
              padding: EdgeInsets.only(top: 25),
              child: ListView.builder(
                  itemCount: demoImageList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // setState(() {
                        // current = index;
                        // });
                      },
                      child: ImageCard(image: demoImageList[index].image),
                    );
                  }),
            ),
          ],
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
          // Image(
          //   image:
          Image.network(
            image,
            fit: BoxFit.cover,
            height: 150,
          ),
          // ),
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

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
