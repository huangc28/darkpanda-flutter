import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bloc/verify_bank_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/screens/bank_account_detail/bank_account_detail.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/screens/bank_account_status/bank_account_status.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bloc/load_bank_status_bloc.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AuthUser _sender;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    BlocProvider.of<LoadBankStatusBloc>(context)
        .add(LoadBank(uuid: _sender.uuid));
    super.initState();
  }

  void _refreshNow(refresh) {
    if (refresh != null) {
      if (refresh == true) {
        BlocProvider.of<LoadBankStatusBloc>(context)
            .add(LoadBank(uuid: _sender.uuid));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadBankStatusBloc, LoadBankStatusState>(
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          if (state.bankStatusDetail.verifyStatus != '') {
            return BankAccountStatus(
              bankStatusDetail: state.bankStatusDetail,
              onRefresh: (bool refresh) {
                _refreshNow(refresh);
              },
            );
          } else {
            return body();
          }
        } else {
          return body();
        }
      },
    );
  }

  Widget body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                onPressed: () async {
                  bool refresh =
                      await Navigator.of(context, rootNavigator: true).push(
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
                  _refreshNow(refresh);
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
