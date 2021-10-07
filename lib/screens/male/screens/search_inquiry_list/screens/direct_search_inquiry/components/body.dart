import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/screens/female_profile/female_profile.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review_star.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

List<String> images = [
  "https://thumbs.dreamstime.com/b/portrait-beautiful-asian-girl-summer-hat-105033823.jpg",
  "https://image.winudf.com/v2/image/dHJhbm1pbmgudHVhbi5iZWF1dHlnaXJsYXNpYW5fc2NyZWVuXzdfMTUzMTcyNzk5OV8wNjA/screen-7.jpg?fakeurl=1&type=.jpg",
  "https://i.pinimg.com/originals/43/9a/b2/439ab2a8ad2dc976c583e8660cdce6e3.jpg",
  "https://images.unsplash.com/photo-1541823709867-1b206113eafd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YXNpYW4lMjBnaXJsfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
];

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => FemaleProfile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*24 is for notification bar on Android*/
    final double itemHeight =
        (SizeConfig.screenHeight - kToolbarHeight - 24) / 2;
    final double itemWidth = SizeConfig.screenWidth / 2;

    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 8.0,
        bottom: 0.0,
      ),
      child: LoadMoreScrollable(
        onLoadMore: () {},
        builder: (context, scrollController) => RefreshIndicator(
          onRefresh: () {},
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print('[Debug] girl profile $index');
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(_createRoute());

                  // Navigator.of(
                  //   context,
                  //   rootNavigator: true,
                  // ).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => FemaleProfile(),
                  //   ),
                  // );
                },
                child: _userList(index),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _userList(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: images[index] == ""
                      ? AssetImage('assets/default_avatar.png')
                      : NetworkImage(images[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(31, 30, 56, 1),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 1),
                          Flexible(
                            child: Text(
                              'Joanne',
                              // userProfile.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          IconTheme(
                            data: IconThemeData(
                              color: Colors.amber,
                              size: 15,
                            ),
                            child: ReviewStar(value: 5
                                // value: userProfile.rating.score != null
                                //     ? userProfile.rating.score.toInt()
                                //     : 0,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 2),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '沒有內容 沒有內容 沒有內容 沒有內容',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // userProfile.description == null ||
                                //         userProfile.description.isEmpty
                                //     ? '沒有內容'
                                //     : userProfile.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
