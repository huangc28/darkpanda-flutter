part of '../inquirer_profile.dart';

class InquirerProfilePage extends StatelessWidget {
  const InquirerProfilePage({
    this.userProfile,
    this.userRatings,
  });

  final UserProfile userProfile;
  final UserRatings userRatings;

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
                        userProfile.username,
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
                        rating: 3,
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
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Tags: age, height, weight.
                      userProfile.age != null && userProfile.age != ""
                          ? ageLabel()
                          : SizedBox(),
                      userProfile.height != null && userProfile.age != ""
                          ? heightLabel()
                          : SizedBox(),
                      userProfile.weight != null && userProfile.age != ""
                          ? weightLabel()
                          : SizedBox(),
                    ],
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
                        userProfile.description == null ||
                                userProfile.description.isEmpty
                            ? '沒有內容'
                            : userProfile.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                // Inquirer image scroll view.
                userProfile.imageList != null &&
                        userProfile.imageList.length > 0
                    ? Container(
                        height: 190,
                        padding: EdgeInsets.only(top: 25),
                        child: ListView.builder(
                          itemCount: userProfile.imageList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: ImageCard(
                                  image: userProfile.imageList[index].url),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),

          // Comments list.
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25),
            child: Row(
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
                Container(
                  child: Text(
                    '評價(${userRatings.userRatings.length})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Column(
            children: List.generate(userRatings.userRatings.length, (index) {
              return Review(review: userRatings.userRatings[index]);
            }),
          ),
        ],
      ),
    );
  }

  Widget ageLabel() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
          decoration: tagBoxDecoration(),
          child: Text(
            userProfile.age.toString() + '岁',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget heightLabel() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
          decoration: tagBoxDecoration(),
          child: Text(
            userProfile.height.toString() + 'm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget weightLabel() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
          decoration: tagBoxDecoration(),
          child: Text(
            userProfile.weight.toString() + 'kg',
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

BoxDecoration tagBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Color.fromRGBO(190, 172, 255, 0.3),
  );
}
