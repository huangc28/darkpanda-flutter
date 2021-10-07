import 'package:flutter/material.dart';

import 'components/body.dart';

class FemaleProfile extends StatefulWidget {
  const FemaleProfile({
    Key key,
  }) : super(key: key);

  @override
  _FemaleProfileState createState() => _FemaleProfileState();
}

class _FemaleProfileState extends State<FemaleProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('檔案'),
        centerTitle: true,
        leading: IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                print('[Debug] 馬上聊聊');
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Align(
                child: Text(
                  '馬上聊聊',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Body(),
      ),
    );
  }
}
