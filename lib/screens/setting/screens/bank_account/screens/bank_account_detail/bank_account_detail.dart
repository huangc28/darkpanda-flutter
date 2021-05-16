import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bloc/verify_bank_bloc.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

typedef OpenRefreshCallback = void Function(bool refresh);

class BankAccountDetail extends StatefulWidget {
  BankAccountDetail({
    Key key,
    this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  _BankAccountDetailState createState() => _BankAccountDetailState();
}

class _BankAccountDetailState extends State<BankAccountDetail> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  AuthUser _sender;

  String _bankName;
  String _asyncBankNameErrStr = '';
  String _branch;
  String _asyncBranchErrStr = '';
  String _accountNumber;
  String _asyncAccountNumberErrStr = '';
  bool _disableVerify = true;

  @override
  void initState() {
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    if (widget.formKey != null) {
      _formKey = widget.formKey;
    }

    super.initState();
  }

  void _submit() {
    setState(() {
      _asyncBankNameErrStr = '';
      _asyncBranchErrStr = '';
      _asyncAccountNumberErrStr = '';
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    BlocProvider.of<VerifyBankBloc>(context).add(
      VerifyBank(
        uuid: _sender.uuid,
        bankName: _bankName,
        branch: _branch,
        accoutNumber: _accountNumber,
      ),
    );
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: BlocListener<VerifyBankBloc, VerifyBankState>(
              listener: (context, state) {
                loading = state.status == AsyncLoadingStatus.loading;
                //user done update bank account.
                if (state.status == AsyncLoadingStatus.done) {
                  Navigator.pop<bool>(context, true);
                }
              },
              child: BlocBuilder<VerifyBankBloc, VerifyBankState>(
                builder: (context, state) {
                  return Form(
                    onChanged: () {
                      setState(() {
                        _disableVerify = !_formKey.currentState.validate();
                      });
                    },
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        InputTextLabel(label: "帳戶名稱"),
                        SizedBox(height: 20),
                        buildBankNameInput(),
                        SizedBox(height: 24),
                        InputTextLabel(label: "銀行代碼"),
                        SizedBox(height: 20),
                        buildBankNumberInput(),
                        SizedBox(height: 24),
                        InputTextLabel(label: "銀行賬號"),
                        SizedBox(height: 20),
                        buildBankAccountNumberInput(),
                        buildVerifyButton(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBankNameInput() {
    return Column(
      children: <Widget>[
        DPTextFormField(
          validator: (String v) {
            // Bank name can not be empty
            if (v.trim().isEmpty) {
              return 'bank name is required';
            }

            if (_asyncBankNameErrStr != null &&
                _asyncBankNameErrStr.isNotEmpty) {
              return _asyncBankNameErrStr;
            }

            return null;
          },
          onSaved: (String v) {
            _bankName = v;
          },
          hintText: '請輸入您的帳戶名稱',
          theme: DPTextFieldThemes.transparent,
        ),
        // TextField(
        //   style: TextStyle(color: Colors.white),
        //   decoration: inputDecoration(),
        // ),
      ],
    );
  }

  Widget buildBankNumberInput() {
    return Column(
      children: <Widget>[
        DPTextFormField(
          validator: (String v) {
            // branch can not be empty
            if (v.trim().isEmpty) {
              return 'branch is required';
            }

            if (_asyncBranchErrStr != null && _asyncBranchErrStr.isNotEmpty) {
              return _asyncBranchErrStr;
            }

            return null;
          },
          onSaved: (String v) {
            _branch = v;
          },
          hintText: '請輸入銀行代碼',
          theme: DPTextFieldThemes.transparent,
        ),

        // TextField(
        //   style: TextStyle(color: Colors.white),
        //   decoration: inputDecoration(),
        // ),
      ],
    );
  }

  Widget buildBankAccountNumberInput() {
    return Column(
      children: <Widget>[
        DPTextFormField(
          validator: (String v) {
            // account number can not be empty
            if (v.trim().isEmpty) {
              return 'account number is required';
            }

            if (_asyncAccountNumberErrStr != null &&
                _asyncAccountNumberErrStr.isNotEmpty) {
              return _asyncAccountNumberErrStr;
            }

            return null;
          },
          onSaved: (String v) {
            _accountNumber = v;
          },
          hintText: '請輸入銀行賬號',
          theme: DPTextFieldThemes.transparent,
        ),

        // TextField(
        //   style: TextStyle(color: Colors.white),
        //   decoration: inputDecoration(),
        // ),
      ],
    );
  }

  Widget buildVerifyButton() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 4,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 44,
          child: DPTextButton(
            disabled: _disableVerify,
            loading: loading,
            theme: DPTextButtonThemes.purple,
            onPressed: _submit,
            text: '驗證帳戶',
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

InputDecoration inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(255, 255, 255, 0.1),
    labelStyle: TextStyle(color: Colors.white),
    // hintText: 'Enter Username',
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
  );
}
