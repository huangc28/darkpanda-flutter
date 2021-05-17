import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/args.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screens/topup_payment/topup_payment.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({
    this.args,
    this.onPush,
  });

  final TopUpDpArguments args;
  final Function(String, TopUpDpArguments) onPush;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final int fiveHundred = 500;
  final int fiveThousand = 5000;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(31, 30, 56, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 30.0),
                child: Row(
                  children: <Widget>[
                    Image(
                      image:
                          AssetImage("lib/screens/setting/assets/big_coin.png"),
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
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "0",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "DP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  InputTextLabel(label: "充值金額"),
                  SizedBox(height: 30.0),
                  GridView.count(
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 10,
                    primary: false,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: (3 / 1),
                    children: <Widget>[
                      Container(
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
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => BuyDpBloc(
                                        apiClient: TopUpClient(),
                                      ),
                                    ),
                                  ],
                                  child: TopupPayment(amount: fiveHundred),
                                );
                              }),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  fiveHundred.toString() + ' DP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    "\$" + fiveHundred.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
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
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => BuyDpBloc(
                                        apiClient: TopUpClient(),
                                      ),
                                    ),
                                  ],
                                  child: TopupPayment(amount: fiveThousand),
                                );
                              }),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  fiveThousand.toString() + ' DP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    "\$" + fiveThousand.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "*您只能在 Dark Panda 上使用 DP幣。",
                        style: TextStyle(
                          fontSize: 18,
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
              color: Color.fromRGBO(254, 226, 136, 1),
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
