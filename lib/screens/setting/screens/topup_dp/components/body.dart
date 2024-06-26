import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/dp_package.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/my_dp.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/args.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screens/topup_payment/topup_payment.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/contracts/chatroom.dart' show InquiryDetail;

class Body extends StatefulWidget {
  const Body({
    this.args,
    this.onPush,
  });

  final InquiryDetail args;
  final Function(String, TopUpDpArguments) onPush;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  LoadMyDpBloc loadMyDpBloc = new LoadMyDpBloc();
  LoadDpPackageBloc loadDpPackageBloc = new LoadDpPackageBloc();
  MyDp myDp = new MyDp();
  DpPackageList dpPackageList = new DpPackageList();
  InquiryDetail _inquiryDetail = InquiryDetail();

  @override
  void initState() {
    super.initState();

    _inquiryDetail = widget.args;

    BlocProvider.of<LoadMyDpBloc>(context).add(LoadMyDp());

    BlocProvider.of<LoadDpPackageBloc>(context).add(LoadDpPackage());
  }

  @override
  void dispose() {
    loadMyDpBloc.add(ClearMyDpState());
    loadDpPackageBloc.add(ClearDpPackageState());

    loadDpPackageBloc.close();

    super.dispose();
  }

  // write this way is to call inistate after pop from Buy DP page
  void navigateBuyDpPage(amount, id, args) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BuyDpBloc(
                apiClient: TopUpClient(),
              ),
            ),
          ],
          child: TopupPayment(
            amount: amount,
            packageId: id,
            args: args,
          ),
        );
      },
    );

    Navigator.of(context, rootNavigator: true).push(route).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      BlocProvider.of<LoadMyDpBloc>(context).add(LoadMyDp());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _myDpBalance(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenHeight * 0.03,
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenHeight * 0.03,
              ),
              child: Column(
                children: <Widget>[
                  InputTextLabel(label: "充值金額"),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.03, //30
                  ),
                  _topupPackage(),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.03, //30
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "*您只能在 Dark Panda 上使用 DP幣。",
                        style: TextStyle(
                          fontSize: SizeConfig.screenHeight * 0.02, //18,
                          color: Color.fromRGBO(254, 226, 136, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topupPackage() {
    return BlocConsumer<LoadDpPackageBloc, LoadDpPackageState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            dpPackageList = state.dpPackageList;
          });
        }
      },
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          return GridView.count(
            mainAxisSpacing: 25,
            crossAxisSpacing: 10,
            primary: false,
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: (3 / 1),
            children: List.generate(dpPackageList.packages.length, (index) {
              return Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // background
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Color.fromRGBO(106, 109, 137, 1),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // If route from settings, it is null
                    if (widget.args != null) {
                      if (widget.args.routeTypes ==
                          RouteTypes.fromServiceChatroom) {
                        _inquiryDetail.routeTypes = RouteTypes.fromTopupDp;
                      }
                    }
                    navigateBuyDpPage(
                      dpPackageList.packages[index].cost,
                      dpPackageList.packages[index].id,
                      _inquiryDetail,
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dpPackageList.packages[index].dpCoin.toString() +
                              ' DP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.screenHeight * 0.02, //18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.01, //2,
                      ),
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          padding: EdgeInsets.fromLTRB(
                            SizeConfig.screenWidth * 0.02,
                            SizeConfig.screenHeight * 0.01,
                            SizeConfig.screenWidth * 0.02,
                            SizeConfig.screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Text(
                            "\$" +
                                dpPackageList.packages[index].cost.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.screenHeight * 0.02, //18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _myDpBalance() {
    return BlocListener<LoadMyDpBloc, LoadMyDpState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            myDp = state.myDp;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(31, 30, 56, 1),
        ),
        child: Padding(
          // padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 30.0),
          padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth * 0.1,
            SizeConfig.screenHeight * 0.04,
            SizeConfig.screenWidth * 0.1,
            SizeConfig.screenHeight * 0.04,
          ),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage("lib/screens/setting/assets/big_coin.png"),
              ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "我的DP幣：",
                        style: TextStyle(
                          color: Color.fromRGBO(106, 109, 137, 1),
                          fontSize: SizeConfig.screenHeight * 0.023, //20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        myDp.balance == null ? "0" : myDp.balance.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.screenHeight * 0.058, //50,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "DP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.screenHeight * 0.023, //20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
          height: SizeConfig.screenHeight * 0.007, //7.0,
          width: SizeConfig.screenWidth * 0.014, //7.0,
          transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(254, 226, 136, 1),
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.screenHeight * 0.02, //18,
          ),
        ),
      ],
    );
  }
}
