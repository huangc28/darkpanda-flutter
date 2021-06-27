import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import '../bank_account/bank_account.dart';
import '../recommend_management/recommend_management.dart';
import '../verify_phone/verify_phone.dart';

import '../../bloc/logout_bloc.dart';
import '../topup_dp/screen_arguements/args.dart';

class MaleSettings extends StatefulWidget {
  const MaleSettings({
    this.onPushTopupDP,
  });

  final Function(TopUpDpArguments) onPushTopupDP;

  @override
  _MaleSettingsState createState() => _MaleSettingsState();
}

class _MaleSettingsState extends State<MaleSettings> {
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
                                "lib/screens/setting/assets/buy_dp.png"),
                          ),
                          onTap: () {
                            widget.onPushTopupDP(TopUpDpArguments(amount: 200));
                          },
                        ),
                        InkWell(
                          child: Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/block_list.png"),
                          ),
                          onTap: () {
                            // widget.onPush('/blacklist', null);
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      child: Image(
                        image: AssetImage(
                            "lib/screens/setting/assets/feedback.png"),
                      ),
                      onTap: () {},
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            height: 44,
                            child: BlocListener<LogoutBloc, LogoutState>(
                              listener: (context, state) {
                                if (state.status == AsyncLoadingStatus.done) {
                                  // Redirect back to login page.
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(MainRoutes.login);
                                }
                              },
                              child: DPTextButton(
                                theme: DPTextButtonThemes.purple,
                                onPressed: () {
                                  BlocProvider.of<LogoutBloc>(context)
                                      .add(Logout());
                                },
                                text: '登出',
                              ),
                            )),
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
