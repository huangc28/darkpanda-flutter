import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tappay/flutter_tappay.dart';

import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/bloc/buy_service_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/buy_service.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/utils/card_month_input_formatter.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/utils/card_number_input_formatter.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import '../../utils//card_utils.dart';
import '../../models/payment_card.dart';
import 'components/topup_payment_confirmation_dialog.dart';

class TopupPayment extends StatefulWidget {
  const TopupPayment({
    this.amount,
    this.packageId,
    this.args,
  });

  final int amount;
  final int packageId;
  final InquiryDetail args;

  @override
  _TopupPaymentState createState() => _TopupPaymentState();
}

class _TopupPaymentState extends State<TopupPayment> {
  TextEditingController _numberController = TextEditingController();

  FlutterTappay _payer = FlutterTappay();
  FlutterTappay payer = FlutterTappay();

  PaymentCard _paymentCard = PaymentCard();
  final GlobalKey<FormState> _formKeyTopup = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  bool isLoading = false;

  InquiryDetail _inquiryDetail;

  @override
  void initState() {
    super.initState();

    _inquiryDetail = widget.args;

    _initTappay();

    payer
        .init(
      appKey:
          'app_7OYnhykZUdLACsoYJiCSoxu7MbDUo9SNFcekYcgGJlnsDtC6oB9VhRFP8mMy',
      appId: 17098,
      serverType: FlutterTappayServerType.Sandbox,
    )
        .then((_) {
      print('tappay instance instantiated.');
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _numberController.dispose();
    super.dispose();
  }

  void _initTappay() async {
    _payer = await FlutterTappay()
      ..init(
        appKey:
            'app_7OYnhykZUdLACsoYJiCSoxu7MbDUo9SNFcekYcgGJlnsDtC6oB9VhRFP8mMy',
        appId: 17098,
        serverType: FlutterTappayServerType.Sandbox,
      );
  }

  void _validateInputs() async {
    final FormState form = _formKeyTopup.currentState;

    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      String input = CardUtils.getCleanedNumber(_numberController.text);

      try {
        var resp = await _payer.sendToken(
          cardNumber: input,
          dueMonth: _paymentCard.month,
          dueYear: _paymentCard.year,
          ccv: _paymentCard.cvv.toString(),
        );

        _paymentCard.prime = resp.prime;
        _paymentCard.packageId = widget.packageId;

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return TopupUPaymentConfirmationDialog();
          },
        ).then((value) {
          if (value) {
            BlocProvider.of<BuyDpBloc>(context).add(
              BuyDp(_paymentCard),
            );
          }
        });
      } catch (err) {
        print(err);
        _showInSnackBar(err.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('購買DP幣'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      body: SafeArea(
        child: UnfocusPrimary(
          child: SingleChildScrollView(
            child: BlocListener<BuyDpBloc, BuyDpState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.loading ||
                    state.status == AsyncLoadingStatus.initial) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state.status == AsyncLoadingStatus.error) {
                  setState(() {
                    isLoading = false;
                  });
                  _showInSnackBar(state.error.message);
                } else if (state.status == AsyncLoadingStatus.done) {
                  setState(() {
                    isLoading = false;
                  });

                  _inquiryDetail.balance += widget.amount;

                  _showInSnackBar('充值成功！');
                  // If args is null, means topup is from settings

                  if (widget.args == null) {
                    Navigator.pop(context, true);
                  }
                  // Else not enough DP which is from male accept to pay inquiry
                  else {
                    // Go to payment screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => BuyServiceBloc(
                                  searchInquiryAPIs: SearchInquiryAPIs(),
                                ),
                              ),
                              BlocProvider(
                                create: (context) => CancelServiceBloc(
                                  serviceAPIs: ServiceAPIs(),
                                ),
                              ),
                            ],
                            child: BuyService(
                              args: _inquiryDetail,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
              child: Column(
                children: <Widget>[
                  _buildAmountDetail(),
                  _buildPaymentDetail(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetail() {
    return Padding(
      // padding: EdgeInsets.all(20),
      padding: EdgeInsets.fromLTRB(
        SizeConfig.screenWidth * 0.05,
        SizeConfig.screenHeight * 0.03,
        SizeConfig.screenWidth * 0.05,
        SizeConfig.screenHeight * 0.03,
      ),
      child: Column(
        children: [
          InputTextLabel(label: "充值金額"),
          SizedBox(
            height: SizeConfig.screenHeight * 0.022, //20
          ),
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
              // padding: const EdgeInsets.all(20.0),
              padding: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenHeight * 0.03,
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenHeight * 0.03,
              ),
              child: Form(
                key: _formKeyTopup,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  children: <Widget>[
                    InputTextLabelWhite(
                      label: "信用卡號",
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.018, //15
                    ),
                    _buildCreditCardNumberInput(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.022, //20
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InputTextLabelWhite(
                            label: "到期日",
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.04, //10,
                        ),
                        Expanded(
                          child: InputTextLabelWhite(
                            label: "安全碼",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.018, //15
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildValidInput(),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildCVCInput(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.022, //20
                    ),
                    DPTextButton(
                      loading: isLoading,
                      disabled: isLoading,
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
        ],
      ),
    );
  }

  Widget _buildAmountDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(31, 30, 56, 1),
      ),
      child: Padding(
        // padding: const EdgeInsets.all(20.0),
        padding: EdgeInsets.fromLTRB(
          SizeConfig.screenWidth * 0.05,
          SizeConfig.screenHeight * 0.03,
          SizeConfig.screenWidth * 0.05,
          SizeConfig.screenHeight * 0.03,
        ),
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
                        fontSize: SizeConfig.screenHeight * 0.02, //18,
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
                        fontSize: SizeConfig.screenHeight * 0.02, //18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.amount.toString(),
                      style: TextStyle(
                        fontSize: SizeConfig.screenHeight * 0.05, //46,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "NTD",
                      style: TextStyle(
                        fontSize: SizeConfig.screenHeight * 0.02, //18,
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

  Widget _buildCreditCardNumberInput() {
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
          controller: _numberController,
          onSaved: (String value) {
            _paymentCard.cardNumber = CardUtils.getCleanedNumber(value);
          },
          validator: CardUtils.validateCardNum,
        ),
      ],
    );
  }

  Widget _buildValidInput() {
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

  Widget _buildCVCInput() {
    return Column(
      children: <Widget>[
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
          ],
          validator: CardUtils.validateCVV,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Colors.white,
            // fontSize: SizeConfig.screenHeight * 0.02, //18,
          ),
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
          height: SizeConfig.screenHeight * 0.007, //7.0,
          width: SizeConfig.screenWidth * 0.014, //7.0,
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
            fontSize: SizeConfig.screenHeight * 0.02, //18,
          ),
        ),
      ],
    );
  }
}

InputDecoration inputDecoration(hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.screenHeight * 0.022, //18,
    ),
    filled: true,
    fillColor: Color.fromRGBO(255, 255, 255, 0.1),
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.screenHeight * 0.02, //18,
    ),
    contentPadding: EdgeInsets.only(
      left: SizeConfig.screenWidth * 0.05, //14.0,
      bottom: SizeConfig.screenHeight * 0.01, //8.0,
      top: SizeConfig.screenHeight * 0.01, //8.0,
    ),
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
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
  );
}
