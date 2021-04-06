part of '../inquirer_profile.dart';

class InquirerProfilePage extends StatelessWidget {
  const InquirerProfilePage({
    this.userProfile,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name bar with rating stars.
          Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
            ),
            child: Row(
              children: [
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
              children: [
                // Tags: age, height, weight.
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Tag(
                    text: '22歲',
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Tag(
                    text: '188cm',
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Tag(
                    text: '70kg',
                  ),
                ),
              ],
            ),
          ),

          // Inquirer description.
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userProfile.description == null ||
                          userProfile.description.isEmpty
                      ? '沒有內容'
                      : userProfile.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          // Inquirer image scroll view.
          Container(
            padding: EdgeInsets.only(top: 17),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InquirerGalleryImage(
                      src:
                          'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InquirerGalleryImage(
                      src:
                          'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InquirerGalleryImage(
                      src:
                          'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InquirerGalleryImage(
                      src:
                          'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Comments list.
          Container(
            padding: EdgeInsets.only(
              top: 25,
              left: 16,
              right: 16,
            ),
            child: Text(
              '評價(13)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 22),
          Column(
            children: [
              Container(
                child: InquirerCommentCard(),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Container(
                child: InquirerCommentCard(),
                margin: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
