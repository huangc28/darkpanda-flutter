import 'package:darkpanda_flutter/screens/setting/screens/bank_account/screens/bank_account_detail/bank_account_detail.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    width: 40,
                    image: AssetImage("assets/logo.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "(warning icon) 您還未完成帳戶設定，需要填寫帳戶資訊，才可以開始接案喔！",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, // background
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  // Navigator.of(context, rootNavigator: true).push(
                  //   MaterialPageRoute(
                  //       builder: (context) => BankAccountDetail()),
                  // );
                },
                child: Text(
                  '前往帳戶設定',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
