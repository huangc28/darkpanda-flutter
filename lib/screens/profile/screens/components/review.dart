import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:intl/intl.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';

import 'review_star.dart';

class Review extends StatelessWidget {
  final UserRating review;

  const Review({
    Key key,
    this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.screenWidth * 0.04, //16.0,
        SizeConfig.screenHeight * 0.0, //16.0,
        SizeConfig.screenWidth * 0.04, //16.0,
        SizeConfig.screenHeight * 0.02, //16.0,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.screenWidth * 0.04, //16.0,
          SizeConfig.screenHeight * 0.022, //20.0,
          SizeConfig.screenWidth * 0.04, //16.0,
          SizeConfig.screenHeight * 0.022, //16.0,
        ),
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
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(review.raterAvatarUrl, radius: 20),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.04, //15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        review.raterUsername,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.011, //10,
                      ),
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
                                child: ReviewStar(value: review.rating),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('yyyy.MM.dd').format(review.createdAt),
                            // '2021.06.24',
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
            review.comment != ""
                ? SizedBox(
                    height: SizeConfig.screenHeight * 0.02, //16,
                  )
                : Container(),
            review.comment != ""
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      review.comment,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
