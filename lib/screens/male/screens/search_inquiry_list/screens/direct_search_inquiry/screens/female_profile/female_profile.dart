import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/bloc/direct_inquiry_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';

import 'components/body.dart';

class FemaleProfile extends StatefulWidget {
  const FemaleProfile({
    Key key,
    this.uuid,
  }) : super(key: key);

  final String uuid;

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

  InquiryForms _inquiryForms = InquiryForms(
    inquiryDate: DateTime.now(),
    inquiryTime:
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    duration: Duration(hours: 1, minutes: 0),
    budget: 100,
    serviceType: ServiceTypes.chat.name,
    address: 'taiwan',
  );

  String _chatNowButton = '馬上聊聊';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoadUserBloc>(context).add(LoadUser(uuid: widget.uuid));

    BlocProvider.of<LoadUserImagesBloc>(context)
        .add(LoadUserImages(uuid: widget.uuid));

    BlocProvider.of<LoadRateBloc>(context).add(LoadRate(uuid: widget.uuid));
  }

  @override
  Widget build(BuildContext context) {
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
                  BlocProvider.of<DirectInquiryFormBloc>(context).add(
                    SubmitDirectInquiryForm(_inquiryForms),
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
                  _inquiryForms.uuid = userProfile.uuid;
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
            BlocListener<DirectInquiryFormBloc, DirectInquiryFormState>(
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
                    _chatNowButton = '等待回應';
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
