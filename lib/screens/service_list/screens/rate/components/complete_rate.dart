import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:flutter/material.dart';

class CompleteRate extends StatefulWidget {
  const CompleteRate({
    Key key,
  }) : super(key: key);

  @override
  _CompleteRateState createState() => _CompleteRateState();
}

class _CompleteRateState extends State<CompleteRate>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Center(
              child:
                  UserAvatar('https://www.w3schools.com/howto/img_avatar.png'),
            ),
            SizedBox(height: 30),
            Text(
              '謝謝你的評價！',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '他們會收到您的反饋，以及您的姓名和照片',
              style: TextStyle(
                color: Color.fromRGBO(106, 109, 137, 1),
                fontSize: 12,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5,
                left: 20,
                right: 20,
              ),
              child: DPTextButton(
                onPressed: () {
                  print('回到項目管理');
                  Navigator.of(context).pop();
                },
                text: '回到項目管理',
                theme: DPTextButtonThemes.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
