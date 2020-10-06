import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/components/dialogs.dart';

part 'inquirer_profile_status_bar.dart';
part 'inquirer_profile_tabs.dart';

class InquirerProfile extends StatefulWidget {
  const InquirerProfile({
    this.uuid,
    this.loadUserBloc,
  });

  final String uuid;

  final LoadUserBloc loadUserBloc;

  @override
  _InquirerProfileState createState() => _InquirerProfileState();
}

class _InquirerProfileState extends State<InquirerProfile> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String appBarUserame = '';

  @override
  void initState() {
    widget.loadUserBloc.add(
      LoadUser(
        uuid: widget.uuid,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarUserame),
      ),
      body: BlocConsumer<LoadUserBloc, LoadUserState>(
        listener: (context, state) {
          if (state.status == LoadUserStatus.initial ||
              state.status == LoadUserStatus.loading) {
            // Dialogs.showLoadingDialog(context, _keyLoader);
          }

          if (state.status == LoadUserStatus.loadFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );

            // Dialogs.closeLoadingDialog(_keyLoader.currentContext);
          }

          if (state.status == LoadUserStatus.loaded) {
            setState(() {
              appBarUserame = state.userProfile.username;
            });
            // Dialogs.closeLoadingDialog(_keyLoader.currentContext);
          }
        },
        builder: (context, state) {
          if (state.status == LoadUserStatus.loading ||
              state.status == LoadUserStatus.initial) {
            return Container(
              width: 0,
              height: 0,
            );
          }

          if (state.status == LoadUserStatus.loadFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          }

          return Column(
            children: [
              _buildUserStatusRow(state.userProfile),
              _buildDescriptionRow(state.userProfile.description),
              _buildSendMessageRow(),
              Expanded(
                child: InquirerProfileTabs(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserStatusRow(UserProfile userProfile) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Container(
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xffFDCF09),
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(userProfile.avatarUrl),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: InquirerProfileStatusBar(
                  ageLabel: AgeLabel<int>(
                    label: 'Age',
                    val: userProfile.age,
                  ),
                  heightLabel: HeightLabel<double>(
                    label: 'Height',
                    val: userProfile.height,
                  ),
                  weightLabel: WeightLabel<double>(
                    label: 'Weight',
                    val: userProfile.weight,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDescriptionRow(String description) {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'some description',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ));
  }

  Widget _buildSendMessageRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlineButton(
              child: Text('Start Chat To Book'),
              onPressed: () {
                print('DEBUG trigger send message');
              },
            ),
          )
        ],
      ),
    );
  }
}
