import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/male/bottom_navigation.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/screens/female/bottom_navigation.dart';

class CompleteRate extends StatefulWidget {
  const CompleteRate({
    Key key,
    this.chatPartnerAvatarURL,
  }) : super(key: key);

  final String chatPartnerAvatarURL;

  @override
  _CompleteRateState createState() => _CompleteRateState();
}

class _CompleteRateState extends State<CompleteRate>
    with SingleTickerProviderStateMixin {
  var gender;

  @override
  void initState() {
    super.initState();

    gender = BlocProvider.of<AuthUserBloc>(context).state.user.gender;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (gender == Gender.female) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamedAndRemoveUntil(
            MainRoutes.female,
            ModalRoute.withName('/'),
            arguments: TabItem.manage,
          );
        }

        if (gender == Gender.male) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamedAndRemoveUntil(
            MainRoutes.male,
            ModalRoute.withName('/'),
            arguments: MaleAppTabItem.manage,
          );
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 16, 41, 1),
          title: Text('評價'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1), //change your color here
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100),
                Center(
                  child: UserAvatar(widget.chatPartnerAvatarURL),
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
                      print('回到項目服務');

                      if (gender == Gender.female) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          MainRoutes.female,
                          ModalRoute.withName('/'),
                          arguments: TabItem.manage,
                        );
                      }

                      if (gender == Gender.male) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          MainRoutes.male,
                          ModalRoute.withName('/'),
                          arguments: MaleAppTabItem.manage,
                        );
                      }
                    },
                    text: '回到項目服務',
                    theme: DPTextButtonThemes.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
