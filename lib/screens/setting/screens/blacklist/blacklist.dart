import 'package:flutter/material.dart';

import 'components/body.dart';

class BlackList extends StatefulWidget {
  @override
  _BlackListState createState() => _BlackListState();
}

class _BlackListState extends State<BlackList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('封鎖名單'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(),
    );
  }
}
