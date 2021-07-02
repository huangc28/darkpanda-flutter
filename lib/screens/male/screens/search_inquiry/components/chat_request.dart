import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/male/bloc/agree_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/agree_inquiry_response.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/screen_arguments/service_chatroom_screen_arguments.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';

import 'cancel_inquiry_confirmation_dialog.dart';

typedef OnPushInquiryDetail = void Function(
    String routeName, InquirerProfileArguments args);

class ChatRequest extends StatefulWidget {
  const ChatRequest({
    this.onPush,
    this.activeInquiry,
  });

  final OnPushInquiryDetail onPush;
  final ActiveInquiry activeInquiry;

  @override
  _ChatRequestState createState() => _ChatRequestState();
}

class _ChatRequestState extends State<ChatRequest> {
  AgreeInquiryResponse agreeInquiryResponse = new AgreeInquiryResponse();
  UserProfile userProfile = new UserProfile();

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
                  _femaleProfile(),
                  SizedBox(height: 30),
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
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _onTapViewProfile(),
              _onTapChat(),
              _onTapCancel(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _onTapCancel() {
    return SizedBox(
      child: InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: Image.asset("lib/screens/male/assets/cancelButton.png"),
        ),
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
                SkipInquiry(widget.activeInquiry.uuid),
              );
            }
          });
        },
      ),
    );
  }

  Widget _onTapViewProfile() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onPush(
            '/inquirer-profile',
            InquirerProfileArguments(
              uuid: userProfile.uuid,
            ),
          );
        },
        child: SizedBox(
          child: Container(
            padding: EdgeInsets.only(right: 15),
            height: MediaQuery.of(context).size.height * 0.06,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(255, 255, 255, 0.18),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0, left: 20, right: 10),
                      child:
                          Image.asset("lib/screens/male/assets/editButton.png"),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 0,
                        left: 0,
                        right: SizeConfig.screenWidth * 0.04, //20,
                      ),
                      child: Text(
                        '查看檔案',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.blockSizeVertical * 2, //16,
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
    );
  }

  Widget _onTapChat() {
    return BlocConsumer<AgreeInquiryBloc, AgreeInquiryState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        } else if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            agreeInquiryResponse = state.agreeInquiry;
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(
              MainRoutes.maleChatroom,
              arguments: MaleChatroomScreenArguments(
                channelUUID: agreeInquiryResponse.channelUuid,
                inquiryUUID: widget.activeInquiry.uuid,
                counterPartUUID: agreeInquiryResponse.picker.uuid,
              ),
            );
          });
        }
      },
      builder: (context, state) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<AgreeInquiryBloc>(context)
                  .add(AgreeInquiry(widget.activeInquiry.uuid));
            },
            child: SizedBox(
              child: Container(
                padding: EdgeInsets.only(right: 15),
                height: MediaQuery.of(context).size.height * 0.06,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(255, 255, 255, 0.18),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 0, left: 20, right: 10),
                          child: Image.asset(
                              "lib/screens/male/assets/deleteButton.png"),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: SizeConfig.screenWidth * 0.04, //20,
                          ),
                          child: Text(
                            '馬上聊聊',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeVertical * 2, //16,
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
        );
      },
    );
  }

  Widget _femaleProfile() {
    return BlocConsumer<LoadUserBloc, LoadUserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.loading ||
            state.status == AsyncLoadingStatus.initial) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        }

        if (state.status == AsyncLoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );

          return Container();
        }

        if (state.status == AsyncLoadingStatus.done) {
          userProfile = state.userProfile;
          return Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: Color.fromRGBO(31, 30, 56, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    userProfile.username,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  IconTheme(
                                    data: IconThemeData(
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    child: ReviewStar(value: 3),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '3/5',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    userProfile.description == null ||
                                            userProfile.description.isEmpty
                                        ? '沒有內容'
                                        : userProfile.description,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
        return SizedBox.fromSize();
      },
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
