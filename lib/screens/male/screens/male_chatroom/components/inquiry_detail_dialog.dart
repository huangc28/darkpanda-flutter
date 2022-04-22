import 'package:darkpanda_flutter/contracts/chatroom.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/send_emit_service_confirm_message_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/negotiating_inquiry_detail.dart';

class InquiryDetailDialog extends StatefulWidget {
  const InquiryDetailDialog({
    Key key,
    this.negotiatingInquiryDetail,
  }) : super(key: key);
  final NegotiatingServiceDetail negotiatingInquiryDetail;

  @override
  _InquiryDetailDialogState createState() => _InquiryDetailDialogState();
}

class _InquiryDetailDialogState extends State<InquiryDetailDialog> {
  int isFirstCall = 0;

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
                            channelUUID:
                                widget.negotiatingInquiryDetail.channelUUID,
                            inquiryUUID:
                                widget.negotiatingInquiryDetail.inquiryUUID,
                            counterPartUUID:
                                widget.negotiatingInquiryDetail.counterPartUUID,
                            serviceUUID:
                                widget.negotiatingInquiryDetail.serviceUUID,
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
          widget.negotiatingInquiryDetail.serviceUUID =
              state.emitServiceConfirmMessageResponse.serviceChannelUuid;

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
              BlocProvider.of<SendEmitServiceConfirmMessageBloc>(context).add(
                EmitServiceConfirmMessage(
                  widget.negotiatingInquiryDetail.serviceUUID,
                ),
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
              '${widget.negotiatingInquiryDetail.price}',
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
    final durationSplit =
        widget.negotiatingInquiryDetail.duration.toString().split(':');
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
              widget.negotiatingInquiryDetail.serviceType ?? '',
              icon: Icons.article,
            ),
            SizedBox(height: 8),
            _buildEachText(
              'place.png',
              '地址',
              widget.negotiatingInquiryDetail.address ?? '',
            ),
            SizedBox(height: 8),
            _buildEachText(
                'clock.png',
                '時間',
                widget.negotiatingInquiryDetail.serviceTime != null
                    ? '${DateFormat("MM/dd/yy, hh: mm a").format(widget.negotiatingInquiryDetail.serviceTime)}'
                    : ''),
            SizedBox(height: 8),
            if (durationSplit.length > 0)
              _buildEachText(
                'countDown.png',
                '時長',
                widget.negotiatingInquiryDetail.duration >
                            Duration(hours: 0, minutes: 1) &&
                        widget.negotiatingInquiryDetail.duration <=
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
      widget.negotiatingInquiryDetail.username + '已向你發送請求',
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
