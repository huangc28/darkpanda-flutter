import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review.dart';
import 'package:darkpanda_flutter/screens/profile/screens/profile.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';

import 'package:darkpanda_flutter/components/user_traits.dart';

import 'female_service_grid.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.userProfile,
    this.userRatings,
    this.userImages,
    this.userServices,
    this.userProfileStatus,
    this.userRatingsStatus,
    this.userImagesStatus,
    this.onTapService,
  }) : super(key: key);

  final UserProfile userProfile;
  final UserRatings userRatings;
  final List<UserImage> userImages;
  final List<UserServiceResponse> userServices;
  final AsyncLoadingStatus userProfileStatus;
  final AsyncLoadingStatus userRatingsStatus;
  final AsyncLoadingStatus userImagesStatus;
  final ValueChanged<UserServiceResponse> onTapService;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return widget.userProfileStatus == AsyncLoadingStatus.done
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                  ),
                  child: Column(
                    children: <Widget>[
                      // Name bar with rating stars.
                      Container(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 16,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.userProfile.username,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            RatingBarIndicator(
                              unratedColor: Colors.grey,
                              rating: widget.userProfile.rating.score != null
                                  ? widget.userProfile.rating.score
                                  : 0,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.only(
                          left: 16,
                        ),
                        child: ListView.builder(
                          itemCount: widget.userProfile.traits.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return UserTraits(
                                userTrait: widget.userProfile.traits[index]);
                          },
                        ),
                      ),

                      // Inquirer description.
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.userProfile.description == null ||
                                      widget.userProfile.description.isEmpty
                                  ? '沒有內容'
                                  : widget.userProfile.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),

                      if (widget.userImagesStatus == AsyncLoadingStatus.done)
                        // Inquirer image scroll view.
                        widget.userImages != null &&
                                widget.userImages.length > 0
                            ? Container(
                                height: 190,
                                padding: EdgeInsets.only(top: 25),
                                child: ListView.builder(
                                  itemCount: widget.userImages.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: ImageCard(
                                        image: widget.userImages[index].url,
                                        userImage: widget.userImages,
                                        index: index,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                    ],
                  ),
                ),
                _userServiceLabel(),
                SizedBox(height: 20),
                _userServiceList(),
                if (widget.userRatingsStatus == AsyncLoadingStatus.done)
                  // Comments list.
                  _ratingLabel(),
                SizedBox(height: 20),
                if (widget.userRatingsStatus == AsyncLoadingStatus.done)
                  _ratingList(),
              ],
            ),
          )
        : Row(
            children: [
              LoadingScreen(),
            ],
          );
  }

  Widget _userServiceList() {
    return UserServiceList(
      userServices: widget.userServices,
      scrollPhysics: NeverScrollableScrollPhysics(),
      userServiceBuilder: (context, service, index) {
        return InkWell(
          onTap: () {
            widget.onTapService(service);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: FemaleServiceGrid(
            userService: service,
            serviceLength: widget.userServices.length,
            index: index,
          ),
        );
      },
    );
  }

  Widget _userServiceLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 25),
      child: Row(
        children: <Widget>[
          Container(
            height: 7.0,
            width: 7.0,
            transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(254, 226, 136, 1),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            child: Text(
              '提供服務',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 25),
      child: Row(
        children: <Widget>[
          Container(
            height: 7.0,
            width: 7.0,
            transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(254, 226, 136, 1),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            child: Text(
              '評價(${widget.userRatings.userRatings.length})',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingList() {
    return Column(
      children: List.generate(widget.userRatings.userRatings.length, (index) {
        return Review(review: widget.userRatings.userRatings[index]);
      }),
    );
  }
}
