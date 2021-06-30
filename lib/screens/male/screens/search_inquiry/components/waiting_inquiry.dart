import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/edit_inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';

import 'cancel_inquiry_confirmation_dialog.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
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
                                    BlocProvider.of<LoadInquiryBloc>(context),
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
                child: SizedBox(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                    height: SizeConfig.screenHeight * 0.06,
                    width: SizeConfig.screenWidth / 2.5,
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(255, 255, 255, 0.18),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(top: 0, left: 20, right: 12),
                              child: Image.asset(
                                  "lib/screens/male/assets/editButton.png"),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(top: 0, left: 0, right: 20),
                              child: Text(
                                '编织',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return CancelInquiryConfirmationDialog();
                    },
                  ).then((value) {
                    if (value) {
                      BlocProvider.of<CancelInquiryBloc>(context).add(
                        CancelInquiry(widget.activeInquiry.uuid),
                      );
                    }
                  });
                },
                child: SizedBox(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    height: SizeConfig.screenHeight * 0.06,
                    width: SizeConfig.screenWidth / 2.5,
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(255, 255, 255, 0.18),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(top: 0, left: 20, right: 12),
                              child: Image.asset(
                                  "lib/screens/male/assets/deleteButton.png"),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(top: 0, left: 0, right: 20),
                              child: Text(
                                '删除',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
        child: Stack(
          children: <Widget>[
            Container(
              height: SizeConfig.screenHeight / 2.5,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/screens/male/assets/pending.png"),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(35, 40, 0, 40),
              margin:
                  EdgeInsets.fromLTRB(20, SizeConfig.screenHeight / 3, 20, 0),
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
                        'Dark Panda 正在幫您配對中',
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
      padding: EdgeInsets.only(
        top: 30,
        right: 16,
        left: 16,
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '等待女生上門',
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
