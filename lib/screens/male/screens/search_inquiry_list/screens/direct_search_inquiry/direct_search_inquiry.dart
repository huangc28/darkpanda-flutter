import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review_star.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import 'bloc/direct_inquiry_form_bloc.dart';
import 'models/female_list.dart';
import 'screens/female_profile/female_profile.dart';

class DirectSearchInquiry extends StatefulWidget {
  const DirectSearchInquiry({
    Key key,
    this.femaleUserList,
    this.onRefresh,
    this.onLoadMore,
  }) : super(key: key);

  final List<FemaleUser> femaleUserList;
  final Function onRefresh;
  final Function onLoadMore;

  @override
  _DirectSearchInquiryState createState() => _DirectSearchInquiryState();
}

class _DirectSearchInquiryState extends State<DirectSearchInquiry> {
  List<FemaleUser> femaleUsers = [];

  @override
  void initState() {
    super.initState();
  }

  Route _createRoute(String uuid) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => LoadUserImagesBloc(
              userApi: UserApis(),
            ),
          ),
          BlocProvider(
            create: (context) => LoadRateBloc(
              rateApiClient: RateApiClient(),
            ),
          ),
          BlocProvider(
            create: (context) => DirectInquiryFormBloc(
              searchInquiryAPIs: SearchInquiryAPIs(),
            ),
          ),
        ],
        child: FemaleProfile(
          uuid: uuid,
        ),
      ),
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
      ),
      child: LoadMoreScrollable(
        onLoadMore: widget.onLoadMore,
        builder: (context, scrollController) => RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: Container(
            height: SizeConfig.screenHeight,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: scrollController,
              itemCount: widget.femaleUserList?.length,
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
                    ).push(_createRoute(widget.femaleUserList[index].uuid));
                  },
                  child: _userList(widget.femaleUserList[index], index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _userList(FemaleUser user, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: _boxDecorationUserImage(user),
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
                              user.username,
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
                            child: ReviewStar(
                              value: user.userRating.score != null
                                  ? user.userRating.score.toInt()
                                  : 0,
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
                                user.description == null ||
                                        user.description.isEmpty
                                    ? '沒有內容'
                                    : user.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

  BoxDecoration _boxDecorationUserImage(FemaleUser user) {
    return user.avatarUrl == ""
        ? BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/default_avatar.png'),
              fit: BoxFit.contain,
            ),
          )
        : BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(user.avatarUrl),
              fit: BoxFit.fitHeight,
            ),
          );
  }
}
