import 'package:flutter/material.dart';

class DemoUser {
  final String image;
  final String name;

  DemoUser({
    this.image,
    this.name,
  });
}

List demoUserList = [
  DemoUser(
    image: "assets/logo.png",
    name: "Jenny",
  ),
  DemoUser(
    image: "assets/logo.png",
    name: "Ali",
  ),
  DemoUser(
    image: "assets/logo.png",
    name: "John",
  ),
  DemoUser(
    image: "assets/logo.png",
    name: "Kane",
  ),
];

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 26, 20, 0),
          child: Column(
            children: List.generate(demoUserList.length, (index) {
              return userList(context: context, user: demoUserList[index]);
            }),
          ),
        ),
      ),
    );
  }

  Widget userList({BuildContext context, user}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(user.image),
                    ),
                    SizedBox(width: 15),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // background
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        '解除封鎖',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
