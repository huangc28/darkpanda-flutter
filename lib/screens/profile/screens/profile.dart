import 'package:flutter/material.dart';

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
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ProfileDetail(),
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
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  final String image;

  const ImageCard({
    Key key,
    this.operation,
    this.selectedIcon,
    this.unselectedIcon,
    this.isSelected,
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
          Image(
            image: AssetImage(image),
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
