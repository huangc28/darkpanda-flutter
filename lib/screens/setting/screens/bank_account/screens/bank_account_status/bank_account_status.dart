import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/models/bank_status_detail.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/screens/bank_account_detail/bank_account_detail.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bloc/verify_bank_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/services/apis.dart';

typedef RefreshCallback = void Function(bool refresh);

class BankAccountStatus extends StatefulWidget {
  BankAccountStatus({
    Key key,
    this.bankStatusDetail,
    this.onRefresh,
  }) : super(key: key);

  final BankStatusDetail bankStatusDetail;
  final RefreshCallback onRefresh;

  @override
  _BankAccountStatusState createState() => _BankAccountStatusState();
}

class _BankAccountStatusState extends State<BankAccountStatus> {
  BankStatusDetail bankStatusDetail;

  @override
  void initState() {
    bankStatusDetail = widget.bankStatusDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 26, 20, 0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
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
                      InputTextLabel(
                        label: "户名：",
                        value: bankStatusDetail.bankName,
                      ),
                      SizedBox(height: 10),
                      InputTextLabel(
                        label: "銀行：",
                        value: bankStatusDetail.branch,
                      ),
                      SizedBox(height: 10),
                      InputTextLabel(
                        label: "帳號：",
                        value: bankStatusDetail.accoutNumber,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (bankStatusDetail.verifyStatus == 'pending' ||
                  bankStatusDetail.verifyStatus == 'verifying')
                statusText("驗證中", Color.fromRGBO(254, 226, 136, 1)),
              if (bankStatusDetail.verifyStatus == 'verified')
                statusText("已驗證", Colors.white),
              if (bankStatusDetail.verifyStatus == 'verify_failed')
                statusText("驗證失敗", Color.fromRGBO(236, 97, 88, 1)),
              if (bankStatusDetail.verifyStatus == 'verified' ||
                  bankStatusDetail.verifyStatus == 'verify_failed')
                buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusText(String status, Color color) {
    return Text(
      status,
      style: TextStyle(
        fontSize: 18,
        color: color,
      ),
    );
  }

  Widget buildVerifyButton() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 2.3,
      ),
      // padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 44,
          child: DPTextButton(
            theme: DPTextButtonThemes.purple,
            onPressed: () async {
              bool refresh =
                  await Navigator.of(context, rootNavigator: true).push<bool>(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => VerifyBankBloc(
                          bankAPIClient: BankAPIClient(),
                        ),
                      ),
                    ],
                    child: BankAccountDetail(),
                  ),
                ),
              );
              if (refresh != null) {
                if (refresh == true) {
                  widget.onRefresh(true);
                }
              }
            },
            text: '帳戶設定',
          ),
        ),
      ),
    );
  }
}

class InputTextLabel extends StatelessWidget {
  final String label;
  final String value;

  const InputTextLabel({Key key, this.label, this.value}) : super(key: key);

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
            color: Color.fromRGBO(106, 109, 137, 1),
            fontSize: 18,
          ),
        ),
        SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
