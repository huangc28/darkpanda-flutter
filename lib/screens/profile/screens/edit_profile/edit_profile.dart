import 'package:flutter/material.dart';

import 'components/body.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key key,
    this.onPush,
  }) : super(key: key);

  final ValueChanged<String> onPush;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('編輯個人檔案'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(),
    );
  }
}
