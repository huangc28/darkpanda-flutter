import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
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
          _countdown(),
          SizedBox(height: 10),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(255, 255, 255, 0.18),
                    child: GestureDetector(
                      onTap: () {},
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
              SizedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(255, 255, 255, 0.18),
                    child: GestureDetector(
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
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/screens/male/assets/pending.png"),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(
                    '26',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(35, 40, 20, 40),
              margin: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height / 3, 20, 0),
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
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Text(
                        'Dark Panda 正在帮你配对中 你有27分钟配对的时间',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
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
