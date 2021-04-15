import 'package:darkpanda_flutter/screens/setting/screens/bank_account/screens/bank_account_status/bank_account_status.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'screens/bank_account_detail/bank_account_detail.dart';

class BankAccount extends StatefulWidget {
  @override
  _BankAccountState createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('銀行帳戶'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(),
    );
  }
}
