import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/screens/login/login_navigator.dart';
import 'package:darkpanda_flutter/screens/setting/screens/recommend_management/recommend_management.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/verify_phone.dart';
import 'package:flutter/material.dart';

import 'topup_dp/screen_arguements/args.dart';

class DemoMenu {
  final String image;

  DemoMenu({this.image});
}

List demoMenuList = [
  DemoMenu(
    image: "lib/screens/setting/assets/phone_authenticate.png",
  ),
  DemoMenu(
    image: "lib/screens/setting/assets/recommend_management.png",
  ),
  DemoMenu(
    image: "lib/screens/setting/assets/bank_account.png",
  ),
  DemoMenu(
    image: "lib/screens/setting/assets/block_list.png",
  ),
  DemoMenu(
    image: "lib/screens/setting/assets/2x/feedback.png",
  ),
];

class Setting extends StatefulWidget {
  const Setting({
    this.onPush,
  });

  final Function(String, TopUpDpArguments) onPush;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 0,
                      primary: false,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      children: <Widget>[
                        InkWell(
                          child: Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/phone_authenticate.png"),
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => VerifyPhone()),
                            );
                          },
                        ),
                        InkWell(
                          child: Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/recommend_management.png"),
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => RecommendManagement()),
                            );
                          },
                        ),
                        InkWell(
                          child: Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/bank_account.png"),
                          ),
                          onTap: () {
                            widget.onPush('/bank-account', null);
                          },
                        ),
                        InkWell(
                          child: Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/block_list.png"),
                          ),
                          onTap: () {
                            widget.onPush('/blacklist', null);
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      child: Image(
                        image: AssetImage(
                            "lib/screens/setting/assets/feedback.png"),
                      ),
                      onTap: () {
                        widget.onPush('/topup-dp', null);
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 44,
                          child: DPTextButton(
                            theme: DPTextButtonThemes.purple,
                            onPressed: () async {
                              await SecureStore().fsc.deleteAll();
                              Navigator.of(context, rootNavigator: true)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginNavigator()),
                                      (Route<dynamic> route) => false);
                            },
                            text: '登出',
                          ),
                        ),
                      ),
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
            '設定',
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
