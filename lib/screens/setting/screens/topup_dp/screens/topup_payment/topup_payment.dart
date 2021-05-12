import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/utils/card_month_input_formatter.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/utils/card_number_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tappayflutterplugin/tappayflutterplugin.dart';

import '../../utils//card_utils.dart';
import '../../models/payment_card.dart';
import 'components/topup_payment_confirmation_dialog.dart';

class TopupPayment extends StatefulWidget {
  const TopupPayment({
    this.amount,
  });

  final int amount;

  @override
  _TopupPaymentState createState() => _TopupPaymentState();
}

class _TopupPaymentState extends State<TopupPayment> {
  AuthUser _sender;
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _formKey = new GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;
  var _buyCoin = BuyCoin();

  @override
  void initState() {
    super.initState();
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.dispose();
    super.dispose();
  }

  void _validateInputs() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      String input = CardUtils.getCleanedNumber(numberController.text);
      PrimeModel prime = await Tappayflutterplugin.getPrime(
        cardNumber: input,
        dueMonth: _paymentCard.month,
        dueYear: _paymentCard.year,
        ccv: _paymentCard.cvv.toString(),
      );

      _paymentCard.prime = prime.prime;
      _buyCoin.uuid = _sender.uuid;
      _buyCoin.rechargeId = 1;
      _buyCoin.paymentType = "CreditCard";
      _buyCoin.paymentCard = _paymentCard;
      _buyCoin.amount = widget.amount;
      _buyCoin.cost = widget.amount;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return TopupUPaymentConfirmationDialog();
        },
      ).then((value) {
        if (value) {
          BlocProvider.of<BuyDpBloc>(context).add(
            BuyDp(_buyCoin),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Tappayflutterplugin.setupTappay(
        appId: 17098,
        appKey:
            'app_7OYnhykZUdLACsoYJiCSoxu7MbDUo9SNFcekYcgGJlnsDtC6oB9VhRFP8mMy',
        serverType: TappayServerType.sandBox,
        errorMessage: (error) {
          print(error);
        });

    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('購買DP幣'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<BuyDpBloc, BuyDpState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.error) {
                _showInSnackBar(state.error.message);
              } else if (state.status == AsyncLoadingStatus.done) {
                _showInSnackBar('充值成功！');
                Navigator.pop(context, true);
              }
            },
            child: Column(
              children: <Widget>[
                buildAmountDetail(),
                buildPaymentDetail(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaymentDetail() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          InputTextLabel(label: "充值金額"),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(255, 255, 255, 0.1),
              border: Border.all(
                style: BorderStyle.solid,
                width: 0.5,
                color: Color.fromRGBO(106, 109, 137, 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  children: <Widget>[
                    InputTextLabelWhite(
                      label: "信用卡號",
                    ),
                    SizedBox(height: 15),
                    buildCreditCardNumberInput(),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InputTextLabelWhite(
                            label: "到期日",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: InputTextLabelWhite(
                            label: "安全碼",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: buildValidInput(),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildCVCInput(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    DPTextButton(
                      theme: DPTextButtonThemes.purple,
                      onPressed: () async {
                        _validateInputs();
                      },
                      text: '信用卡付款',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          DPTextButton(
            theme: DPTextButtonThemes.purple,
            onPressed: () {},
            text: '通過 Paypal 付款',
          ),
        ],
      ),
    );
  }

  Widget buildAmountDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(31, 30, 56, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      "您總共購買了" + widget.amount.toString() + "DP",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(254, 226, 136, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      "總金額：",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.amount.toString(),
                      style: TextStyle(
                        fontSize: 46,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "NTD",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Image(
                  image: AssetImage("lib/screens/setting/assets/big_coin.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCreditCardNumberInput() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(19),
            new CardNumberInputFormatter(),
          ],
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("請輸入您的卡號"),
          controller: numberController,
          onSaved: (String value) {
            _paymentCard.number = CardUtils.getCleanedNumber(value);
          },
          validator: CardUtils.validateCardNum,
        ),
      ],
    );
  }

  Widget buildValidInput() {
    return Column(
      children: <Widget>[
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
            new CardMonthInputFormatter(),
          ],
          validator: CardUtils.validateDate,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("月/日"),
          onSaved: (value) {
            List<String> expiryDate = CardUtils.getExpiryDate(value);
            _paymentCard.month = expiryDate[0];
            _paymentCard.year = expiryDate[1];
          },
        ),
      ],
    );
  }

  Widget buildCVCInput() {
    return Column(
      children: <Widget>[
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
          ],
          validator: CardUtils.validateCVV,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("請輸入您的安全碼"),
          onSaved: (value) {
            _paymentCard.cvv = int.parse(value);
          },
        ),
      ],
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
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

class InputTextLabelWhite extends StatelessWidget {
  final String label;

  const InputTextLabelWhite({
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

InputDecoration inputDecoration(hintText) {
  return InputDecoration(
    hintText: hintText,
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
