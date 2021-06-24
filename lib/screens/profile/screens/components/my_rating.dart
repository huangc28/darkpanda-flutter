import 'package:flutter/material.dart';

import 'review_star.dart';

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
                        child: ReviewStar(value: 3),
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
