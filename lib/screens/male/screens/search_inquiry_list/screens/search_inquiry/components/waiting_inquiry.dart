import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/edit_inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';

import 'cancel_inquiry_confirmation_dialog.dart';
import 'color_loader.dart';

class WaitingInquiry extends StatefulWidget {
  const WaitingInquiry({
    this.activeInquiry,
  });

  final ActiveInquiry activeInquiry;

  @override
  _WaitingInquiryState createState() => _WaitingInquiryState();
}

class _WaitingInquiryState extends State<WaitingInquiry> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _buildHeader(),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _countdown(),
                  SizedBox(height: 10),
                  _actionButton(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return Column(
      children: <Widget>[
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  height: SizeConfig.screenHeight * 0.06,
                  width: SizeConfig.screenWidth / 2.7,
                  child: DPTextButton(
                    theme: DPTextButtonThemes.deepGrey,
                    assetImage: "lib/screens/male/assets/editButton.png",
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => LoadInquiryBloc(
                                    searchInquiryAPIs: SearchInquiryAPIs(),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => SearchInquiryFormBloc(
                                    searchInquiryAPIs: SearchInquiryAPIs(),
                                    loadInquiryBloc:
                                        BlocProvider.of<LoadInquiryBloc>(
                                            context),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => LoadServiceListBloc(
                                    searchInquiryAPIs: SearchInquiryAPIs(),
                                  ),
                                ),
                              ],
                              child: EditInquiryForm(
                                activeInquiry: widget.activeInquiry,
                              ),
                            );
                          },
                        ),
                      ).then((value) {
                        setState(() {
                          BlocProvider.of<LoadInquiryBloc>(context)
                              .add(LoadInquiry());
                        });
                      });
                    },
                    text: '編輯',
                  ),
                ),
              ),
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  height: SizeConfig.screenHeight * 0.06,
                  width: SizeConfig.screenWidth / 2.7,
                  child: BlocConsumer<CancelInquiryBloc, CancelInquiryState>(
                    listener: (context, state) {
                      if (state.status == AsyncLoadingStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error.message),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return DPTextButton(
                        loading: state.status == AsyncLoadingStatus.loading,
                        disabled: state.status == AsyncLoadingStatus.loading,
                        theme: DPTextButtonThemes.deepGrey,
                        assetImage: "lib/screens/male/assets/deleteButton.png",
                        onPressed: () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CancelInquiryConfirmationDialog(
                                title: '您確定要刪除需求嗎？',
                                onCancel: '取消',
                                onConfirm: '確定刪除',
                              );
                            },
                          ).then((value) {
                            if (value) {
                              BlocProvider.of<CancelInquiryBloc>(context).add(
                                CancelInquiry(
                                  inquiryUuid: widget.activeInquiry.uuid,
                                  fcmTopic: widget.activeInquiry.fcmTopic,
                                ),
                              );
                            }
                          });
                        },
                        text: '删除',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _countdown() {
    return Center(
      child: Material(
        color: Color.fromRGBO(31, 30, 56, 1),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.05),
                child: ColorLoader(
                  color1: Colors.deepPurple,
                  color2: Colors.deepPurpleAccent,
                  color3: Color.fromRGBO(168, 106, 221, 1),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(35, 40, 0, 40),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "lib/screens/male/assets/pendingBackground.png"),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth / 2.3,
                      child: Text(
                        'Darkpanda 正在幫您配對中',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.3,
                      child: Image.asset("lib/screens/male/assets/16.png"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        top: 20,
        right: 16,
        left: 16,
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '等待女生回覆',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
