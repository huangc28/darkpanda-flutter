import 'package:clipboard/clipboard.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/setting/screens/recommend_management/bloc/load_general_recommend_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 1,
    );

    BlocProvider.of<LoadGeneralRecommendBloc>(context)
        .add(LoadGeneralRecommend());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.53,
                  ),
                  tabs: [
                    Tab(text: '普通推薦'),
                    // Tab(text: '經紀人推薦'),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    normal(),
                    // manager(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget normal() {
    return SingleChildScrollView(
      // padding: EdgeInsets.fromLTRB(20.0, 26, 20, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(31, 30, 56, 1),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 26, 20, 0),
              child: Column(
                children: [
                  InputTextLabel(label: "複製你的推薦碼並分享"),
                  SizedBox(height: 20),
                  clipboard(),
                  SizedBox(height: 30),
                  divider(),
                  SizedBox(height: 20),
                  shareOption(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          nameList("普通推薦名單"),
        ],
      ),
    );
  }

  Widget manager() {
    return SingleChildScrollView(
      // padding: EdgeInsets.fromLTRB(20.0, 26, 20, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(31, 30, 56, 1),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 26, 20, 0),
              child: Column(
                children: [
                  InputTextLabel(label: "複製你的推薦碼並分享"),
                  SizedBox(height: 20),
                  clipboard(),
                  SizedBox(height: 30),
                  divider(),
                  SizedBox(height: 20),
                  shareOption(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          nameList("經紀人推薦名單"),
        ],
      ),
    );
  }

  Widget nameList(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 26, 20, 0),
      child: Column(
        children: [
          InputTextLabel(label: label),
          SizedBox(height: 20),
          Container(
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
                        UserAvatar("", radius: 20),
                        SizedBox(width: 15),
                        Text(
                          'Jenny',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "200 USD",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Image(
                                image: AssetImage(
                                    "lib/screens/setting/assets/coin.png"),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "12个交易",
                              style: TextStyle(
                                color: Color.fromRGBO(106, 109, 137, 1),
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
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
                  children: <Widget>[
                    UserAvatar("", radius: 20),
                    SizedBox(width: 15),
                    Text(
                      'Jenny',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shareOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.1),
              ),
              child: Image(
                image: AssetImage("lib/screens/setting/assets/mail.png"),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "邮箱",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.1),
              ),
              child: Image(
                image: AssetImage("lib/screens/setting/assets/more.png"),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "邮箱",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget divider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1.0,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            "或經由以下平台分享",
            style: TextStyle(
              color: Color.fromRGBO(106, 109, 137, 1),
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.0,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
      ],
    );
  }

  Widget clipboard() {
    return BlocListener<LoadGeneralRecommendBloc, LoadGeneralRecommendState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          textEditingController.text = state.recommendDetail.referralCode;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                  labelStyle: TextStyle(color: Colors.white),
                  // hintText: 'Enter Username',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                controller: textEditingController,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  FlutterClipboard.copy(textEditingController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Referral Code copied!'),
                    ),
                  );
                },
                icon: Icon(Icons.content_copy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputTextLabel extends StatelessWidget {
  final String label;

  const InputTextLabel({
    Key key,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 7.0,
          width: 7.0,
          transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
