import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/load_cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/bloc/buy_service_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/buy_service.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/send_emit_service_confirm_message_bloc.dart';

class InquiryDetailDialog extends StatefulWidget {
  const InquiryDetailDialog({
    Key key,
    this.inquiryDetail,
    this.serviceUuid,
    this.messages,
  }) : super(key: key);

  final InquiryDetail inquiryDetail;
  final String serviceUuid;
  final UpdateInquiryMessage messages;

  @override
  _InquiryDetailDialogState createState() => _InquiryDetailDialogState();
}

class _InquiryDetailDialogState extends State<InquiryDetailDialog> {
  InquiryDetail inquiryDetail;
  int isFirstCall = 0;

  @override
  void initState() {
    super.initState();

    inquiryDetail = widget.inquiryDetail;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBarTheme(
      data: ButtonBarThemeData(
        alignment: MainAxisAlignment.center,
      ),
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              _titleText(),
              SizedBox(height: 16),
              _inquiryDetail(),
              SizedBox(height: 16),
              _inquiryAmountDetail(),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _rejectButton(context),
                SizedBox(width: 16),

                // Load Incoming Service
                BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
                  listener: (context, state) {
                    if (state.status == AsyncLoadingStatus.loading ||
                        state.status == AsyncLoadingStatus.initial) {
                      return Row(
                        children: [
                          LoadingScreen(),
                        ],
                      );
                    }

                    if (state.status == AsyncLoadingStatus.done) {
                      isFirstCall++;

                      // status done will be called twice, so implement isFirstCall to solve this issue
                      if (isFirstCall == 1) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(
                          MainRoutes.serviceChatroom,
                          arguments: ServiceChatroomScreenArguments(
                            channelUUID: inquiryDetail.channelUuid,
                            inquiryUUID: inquiryDetail.inquiryUuid,
                            counterPartUUID: inquiryDetail.counterPartUuid,
                            serviceUUID: inquiryDetail.serviceUuid,
                            routeTypes: RouteTypes.fromBuyService,
                          ),
                        );
                      }
                    }
                  },
                  child: _payButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _payButton(context) {
    return BlocConsumer<SendEmitServiceConfirmMessageBloc,
        SendEmitServiceConfirmMessageState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          inquiryDetail.serviceUuid =
              state.emitServiceConfirmMessageResponse.serviceChannelUuid;

          // Dismiss inquiry_detail_dialog
          // Navigator.pop(context, true);

          BlocProvider.of<LoadIncomingServiceBloc>(context)
              .add(LoadIncomingService());
        }
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: DPTextButton(
            theme: DPTextButtonThemes.purple,
            loading: state.status == AsyncLoadingStatus.loading,
            disabled: state.status == AsyncLoadingStatus.loading,
            onPressed: () async {
              // Navigator.pop(context, true);
              BlocProvider.of<SendEmitServiceConfirmMessageBloc>(context).add(
                EmitServiceConfirmMessage(widget.serviceUuid),
              );
            },
            text: '接受', //'去支付',
          ),
        );
      },
    );
  }

  Widget _rejectButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: DPTextButton(
        theme: DPTextButtonThemes.grey,
        onPressed: () async {
          Navigator.pop(context, false);
        },
        text: '拒絕',
      ),
    );
  }

  Widget _inquiryAmountDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(239, 239, 244, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        child: Column(
          children: <Widget>[
            _buildEachText(
              'pie.png',
              '服務費',
              '${widget.inquiryDetail.updateInquiryMessage.price}DP',
              fontWeight: FontWeight.bold,
            ),
            // SizedBox(height: 8),
            // _buildEachText('heart.png', '媒合費',
            //     '${widget.inquiryDetail.updateInquiryMessage.matchingFee}DP'),
          ],
        ),
      ),
    );
  }

  Widget _inquiryDetail() {
    final durationSplit = widget.inquiryDetail.updateInquiryMessage.duration
        .toString()
        .split(':');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(239, 239, 244, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        child: Column(
          children: <Widget>[
            _buildEachText(
              '',
              '服務',
              widget.messages.serviceType != null
                  ? widget.messages.serviceType
                  : '',
              icon: Icons.article,
            ),
            SizedBox(height: 8),
            _buildEachText(
                'place.png',
                '地址',
                widget.inquiryDetail.updateInquiryMessage.address != null
                    ? widget.inquiryDetail.updateInquiryMessage.address
                    : ''),
            SizedBox(height: 8),
            _buildEachText(
                'clock.png',
                '時間',
                widget.inquiryDetail.updateInquiryMessage.serviceTime != null
                    ? '${DateFormat("MM/dd/yy, hh: mm a").format(widget.inquiryDetail.updateInquiryMessage.serviceTime)}'
                    : ''),
            SizedBox(height: 8),
            if (durationSplit.length > 0)
              _buildEachText(
                'countDown.png',
                '時長',
                widget.inquiryDetail.updateInquiryMessage.duration >
                            Duration(hours: 0, minutes: 1) &&
                        widget.inquiryDetail.updateInquiryMessage.duration <=
                            Duration(hours: 0, minutes: 59)
                    ? '${durationSplit[1]} 分'
                    : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
              ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Text(
      widget.inquiryDetail.username + '已向你發送請求',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color.fromRGBO(49, 50, 53, 1),
      ),
      textAlign: TextAlign.center,
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
    IconData icon,
  }) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            child: iconName != ''
                ? Image.asset(
                    'lib/screens/service_list/assets/$iconName',
                  )
                : CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 223, 214, 255),
                    child: Icon(
                      icon,
                      color: Color.fromRGBO(155, 127, 255, 1),
                      size: 15.0,
                    ),
                  ),
          ),
          SizedBox(width: 4),
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
                color: Colors.black,
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
