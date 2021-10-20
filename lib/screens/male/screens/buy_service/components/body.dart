import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/util/convertZeroDecimalToInt.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/screens/complete_buy_service/complete_buy_service.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/bloc/buy_service_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';

class Body extends StatefulWidget {
  const Body({
    this.args,
    this.onBuyService,
    this.onCancelService,
    this.cancelServiceStatus,
  });

  final InquiryDetail args;
  final VoidCallback onBuyService; // Implement later
  final VoidCallback onCancelService;
  final AsyncLoadingStatus cancelServiceStatus;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(31, 30, 56, 1),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: UserAvatar(""),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildUserInfo(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildServiceDetail(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.args.username ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetail() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(17, 16, 41, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45),
          _buildAddressTimeCardInfo(),
          SizedBox(height: 20),
          _buildDpCardInfo(),
          SizedBox(height: 20),
          _buildMyDpPointInfo(),
          SizedBox(height: 50),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildAddressTimeCardInfo() {
    final durationSplit =
        widget.args.updateInquiryMessage.duration.toString().split(':');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEachText(
            'place.png',
            '地址',
            widget.args.updateInquiryMessage?.address,
          ),
          SizedBox(height: 15),
          _buildEachText(
            'clock.png',
            '時間',
            '${DateFormat("MM/dd/yy").format(widget.args.updateInquiryMessage?.serviceTime)}, ${DateFormat("jm").format(widget.args.updateInquiryMessage?.serviceTime)}',
          ),
          SizedBox(height: 15),
          _buildEachText(
            'countDown.png',
            '時長',
            widget.args.updateInquiryMessage.duration >
                        Duration(hours: 0, minutes: 1) &&
                    widget.args.updateInquiryMessage.duration <=
                        Duration(hours: 0, minutes: 59)
                ? '${durationSplit[1]} 分'
                : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
          ),
        ],
      ),
    );
  }

  Widget _buildDpCardInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEachText(
              'pie.png',
              '服務費',
              convertZeroDecimalToInt(widget.args.updateInquiryMessage.price) +
                  'DP'),
          SizedBox(height: 15),
          _buildEachText('heart.png', '媒合費',
              widget.args.updateInquiryMessage.matchingFee.toString() + 'DP'),
        ],
      ),
    );
  }

  Widget _buildMyDpPointInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '我的DP幣：${widget.args.balance}DP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return BlocListener<BuyServiceBloc, BuyServiceState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.initial ||
            state.status == AsyncLoadingStatus.loading) {
          return LoadingScreen();
        }

        if (state.status == AsyncLoadingStatus.error) {
          developer.log(
            'failed to fetch dp balance',
            error: state.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => CompleteBuyService(args: widget.args),
            ),
            ModalRoute.withName('/'),
          );
        }
      },
      child: Column(
        children: [
          DPTextButton(
            onPressed: () {
              print('購買服務');
              BlocProvider.of<BuyServiceBloc>(context)
                  .add(CreatePayment(serviceUuid: widget.args.serviceUuid));
            },
            text: '購買服務',
            theme: DPTextButtonThemes.purple,
          ),
          SizedBox(height: 15),
          DPTextButton(
            disabled: widget.cancelServiceStatus == AsyncLoadingStatus.loading,
            loading: widget.cancelServiceStatus == AsyncLoadingStatus.loading,
            onPressed: widget.onCancelService,
            text: '取消交易',
            theme: DPTextButtonThemes.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildEachText(
    String iconName,
    String title,
    String value, {
    Color titleColor,
    double titleSize,
    double valueSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Container(
      // height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            child: Image.asset(
              'lib/screens/service_list/assets/$iconName',
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${title}:',
            style: TextStyle(
              color: titleColor != null
                  ? titleColor
                  : Color.fromRGBO(106, 109, 137, 1),
              fontSize: titleSize != null ? titleSize : 13,
              fontWeight: fontWeight,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueSize != null ? valueSize : 15,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
