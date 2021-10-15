import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/bloc/direct_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/bloc/update_female_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/models/female_list.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';

import 'components/body.dart';
import 'components/direct_inquiry_form.dart';

class FemaleProfile extends StatefulWidget {
  const FemaleProfile({
    Key key,
    this.femaleUser,
    this.onInquiryStatusChanged,
  }) : super(key: key);

  final FemaleUser femaleUser;
  final ValueChanged<FemaleUser> onInquiryStatusChanged;

  @override
  _FemaleProfileState createState() => _FemaleProfileState();
}

class _FemaleProfileState extends State<FemaleProfile> {
  UserRatings userRatings = UserRatings();
  UserProfile userProfile = UserProfile();
  List<UserImage> userImages;

  AsyncLoadingStatus _userProfileStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _userRatingsStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _userImagesStatus = AsyncLoadingStatus.initial;

  String _chatNowButton = '馬上聊聊';

  FemaleUser _femaleUser;

  InquiryStatus _inquiryStatus;

  @override
  void initState() {
    super.initState();

    _femaleUser = widget.femaleUser;
    _inquiryStatus = _femaleUser.inquiryStatus;

    BlocProvider.of<LoadUserBloc>(context)
        .add(LoadUser(uuid: widget.femaleUser.uuid));

    BlocProvider.of<LoadUserImagesBloc>(context)
        .add(LoadUserImages(uuid: widget.femaleUser.uuid));

    BlocProvider.of<LoadRateBloc>(context)
        .add(LoadRate(uuid: widget.femaleUser.uuid));

    if (widget.femaleUser.hasInquiry) {
      BlocProvider.of<UpdateFemaleInquiryBloc>(context)
          .add(UpdateFemaleInquiry(femaleUser: widget.femaleUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_inquiryStatus == InquiryStatus.asking) {
      _chatNowButton = '等待回應';
    } else if (_inquiryStatus == InquiryStatus.chatting) {
      _chatNowButton = '正在聊天';
    } else {
      _chatNowButton = '馬上聊聊';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('檔案'),
        centerTitle: true,
        leading: IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                if (_chatNowButton == '馬上聊聊') {
                  print('[Debug] 馬上聊聊');
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
                              create: (context) => DirectInquiryFormBloc(
                                searchInquiryAPIs: SearchInquiryAPIs(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => LoadServiceListBloc(
                                searchInquiryAPIs: SearchInquiryAPIs(),
                              ),
                            ),
                          ],
                          child: DirectInquiryForm(
                            uuid: userProfile.uuid,
                          ),
                        );
                      },
                    ),
                  ).then(
                    (value) {
                      // Return new created inquiry data
                      if (value != null) {
                        setState(() {
                          _inquiryStatus = value.inquiryStatus;

                          final updatedinquiry = _femaleUser.copyWith(
                            inquiryUuid: value.inquiryUuid,
                            inquiryStatus: value.inquiryStatus,
                          );

                          _femaleUser = updatedinquiry;

                          // Return updated value to female list
                          widget.onInquiryStatusChanged(_femaleUser);
                        });
                      }
                    },
                  );
                }
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Align(
                child: Text(
                  _chatNowButton,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<LoadUserBloc, LoadUserState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userProfile = state.userProfile;
                }

                setState(() {
                  _userProfileStatus = state.status;
                });
              },
            ),
            BlocListener<LoadUserImagesBloc, LoadUserImagesState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userImages = state.userImages;
                }

                setState(() {
                  _userImagesStatus = state.status;
                });
              },
            ),
            BlocListener<LoadRateBloc, LoadRateState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  userRatings = state.userRatings;
                }

                setState(() {
                  _userRatingsStatus = state.status;
                });
              },
            ),
            BlocListener<UpdateFemaleInquiryBloc, UpdateFemaleInquiryState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  setState(() {
                    print('[Debug] female profile inquiry status ' +
                        state.femaleUser.inquiryStatus.name);
                    _inquiryStatus = state.femaleUser.inquiryStatus;
                  });
                }
              },
            ),
          ],
          child: Body(
            userProfile: userProfile,
            userRatings: userRatings,
            userImages: userImages,
            userProfileStatus: _userProfileStatus,
            userRatingsStatus: _userRatingsStatus,
            userImagesStatus: _userImagesStatus,
          ),
        ),
      ),
    );
  }
}
