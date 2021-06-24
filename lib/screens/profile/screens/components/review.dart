import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';
import 'package:flutter/material.dart';

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
                  backgroundImage: review.raterAvatarUrl == null
                      ? AssetImage('assets/logo.png')
                      : NetworkImage(review.raterAvatarUrl),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        review.raterUsername,
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
                                child: ReviewStar(value: review.rating),
                              ),
                            ],
                          ),
                          Text(
                            // review.date,
                            '2021.06.24',
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                review.comment,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
