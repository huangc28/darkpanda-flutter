import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/body.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key key,
    this.onPush,
    this.args,
    this.imageList,
  }) : super(key: key);

  final ValueChanged<String> onPush;
  final UserProfile args;
  final List<UserImage> imageList;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('編輯個人檔案'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: BlocListener<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.initial ||
              state.status == AsyncLoadingStatus.loading) {
            setState(() {
              isLoading = true;
            });
            return Row(
              children: [
                LoadingScreen(),
              ],
            );
          }
          if (state.status == AsyncLoadingStatus.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "更新成功!",
                ),
              ),
            );
            Navigator.pop(context);
          }
        },
        child: Body(
          args: widget.args,
          imageList: widget.imageList,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
