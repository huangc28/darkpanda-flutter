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

                // Load my darkpanda coin balance
                // If enough balance will go to service payment screen
                // else go to topup dp screen
                BlocListener<LoadMyDpBloc, LoadMyDpState>(
                  listener: (context, state) {
                    if (state.status == AsyncLoadingStatus.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error.message),
                        ),
                      );
                    }

                    if (state.status == AsyncLoadingStatus.done) {
                      // Dismiss inquiry_detail_dialog
                      Navigator.pop(context, true);

                      final total = widget
                              .inquiryDetail.updateInquiryMessage.price +
                          widget.inquiryDetail.updateInquiryMessage.matchingFee;

                      inquiryDetail.balance = state.myDp.balance;

                      // Go to Top Up screen
                      if (total > state.myDp.balance) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => LoadMyDpBloc(
                                      apiClient: TopUpClient(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => LoadDpPackageBloc(
                                      apiClient: TopUpClient(),
                                    ),
                                  ),
                                ],
                                child: TopupDp(
                                  args: inquiryDetail,
                                ),
                              );
                            },
                          ),
                          ModalRoute.withName('/'),
                        );
                      }
                      // Go to Payment screen
                      else {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushAndRemoveUntil(
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
                                  args: inquiryDetail,
                                ),
                              );
                            },
                          ),
                          ModalRoute.withName('/'),
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

          BlocProvider.of<LoadMyDpBloc>(context).add(
            LoadMyDp(),
          );
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
            text: '去支付',
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
    final total = widget.inquiryDetail.updateInquiryMessage.price +
        widget.inquiryDetail.updateInquiryMessage.matchingFee;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(239, 239, 244, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        child: Column(
          children: <Widget>[
            _buildEachText('pie.png', '小計',
                '${widget.inquiryDetail.updateInquiryMessage.price}DP'),
            SizedBox(height: 8),
            _buildEachText('heart.png', '服務費',
                '${widget.inquiryDetail.updateInquiryMessage.matchingFee}DP'),
            SizedBox(height: 8),
            _buildEachText(
              'coin.png',
              '合計',
              '${total}DP',
              fontWeight: FontWeight.bold,
            ),
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
  }) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            child: Image.asset(
              'lib/screens/service_list/assets/$iconName',
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
