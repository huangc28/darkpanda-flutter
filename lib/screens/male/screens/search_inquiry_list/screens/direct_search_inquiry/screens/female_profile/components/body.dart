import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:darkpanda_flutter/components/user_traits.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        'Joanne',
                        // userProfile.username,
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
                        rating: 5,
                        // rating: userProfile.rating.score != null
                        //     ? userProfile.rating.score
                        //     : 0,
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
                    // itemCount: userProfile.traits.length,
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container();
                      // return UserTraits(userProfile.traits[index]);
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
                        '沒有內容',
                        // userProfile.description == null ||
                        //         userProfile.description.isEmpty
                        //     ? '沒有內容'
                        //     : userProfile.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                // if (userImagesStatus == AsyncLoadingStatus.done)
                // Inquirer image scroll view.
                // userImages != null && userImages.length > 0
                //     ? Container(
                //         height: 190,
                //         padding: EdgeInsets.only(top: 25),
                //         child: ListView.builder(
                //           itemCount: userImages.length,
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: (context, index) {
                //             return GestureDetector(
                //               onTap: () {},
                //               child: ImageCard(
                //                 image: userImages[index].url,
                //                 userImage: userImages,
                //                 index: index,
                //               ),
                //             );
                //           },
                //         ),
                //       )
                //     : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
