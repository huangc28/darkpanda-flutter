part of '../inquirer_profile.dart';

class InquirerProfilePage extends StatelessWidget {
  const InquirerProfilePage({
    this.userProfile,
    this.userRatings,
    this.userImages,
    this.userProfileStatus,
    this.userRatingsStatus,
    this.userImagesStatus,
  });

  final UserProfile userProfile;
  final UserRatings userRatings;
  final List<UserImage> userImages;
  final AsyncLoadingStatus userProfileStatus;
  final AsyncLoadingStatus userRatingsStatus;
  final AsyncLoadingStatus userImagesStatus;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (userProfileStatus == AsyncLoadingStatus.done)
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
                          rating: userProfile.rating.score != null
                              ? userProfile.rating.score
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
                      itemCount: userProfile.traits.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return traitsLabel(userProfile.traits[index]);
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

                  if (userImagesStatus == AsyncLoadingStatus.done)
                    // Inquirer image scroll view.
                    userImages != null && userImages.length > 0
                        ? Container(
                            height: 190,
                            padding: EdgeInsets.only(top: 25),
                            child: ListView.builder(
                              itemCount: userImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child:
                                      ImageCard(image: userImages[index].url),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                ],
              ),
            ),
          if (userRatingsStatus == AsyncLoadingStatus.done)
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
          if (userRatingsStatus == AsyncLoadingStatus.done)
            Column(
              children: List.generate(userRatings.userRatings.length, (index) {
                return Review(review: userRatings.userRatings[index]);
              }),
            ),
        ],
      ),
    );
  }

  Widget traitsLabel(trait) {
    String label = '岁';
    dynamic value = '';

    if (trait.type == 'age') {
      label = '岁';
      value = trait.value.toInt();
    } else if (trait.type == 'height') {
      label = 'm';
      value = trait.value;
    } else {
      label = 'kg';
      value = trait.value;
    }

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                value.toString() + label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration tagBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Color.fromRGBO(190, 172, 255, 0.3),
    );
  }
}
