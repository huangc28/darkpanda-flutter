import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/dialogs.dart';

import './bloc/load_user_images_bloc.dart';

part 'inquirer_profile_status_bar.dart';
part 'inquirer_profile_tabs.dart';
part 'inquirer_profile_tab_bar_view.dart';

enum ProfileTabs {
  images,
  transactions,
}

Map<ProfileTabs, ValueKey> ProfileTabKey = {
  ProfileTabs.images: ValueKey('images'),
  ProfileTabs.transactions: ValueKey('transactions'),
};

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

class _InquirerProfileState extends State<InquirerProfile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TabController _tabController;
  String appBarUserame = '';

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: ProfileTabs.values.length,
    );

    widget.loadUserBloc.add(
      LoadUser(
        uuid: widget.uuid,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Dialogs.showLoadingDialog(context, _keyLoader);
          }

          if (state.status == LoadUserStatus.loadFailed) {
            Navigator.of(context, rootNavigator: true).pop();

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          }

          if (state.status == LoadUserStatus.loaded) {
            setState(() {
              appBarUserame = state.userProfile.username;
            });

            Navigator.of(context, rootNavigator: true).pop();
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
              InquirerProfileTabs(
                tabController: _tabController,
                tabKeys: [
                  ProfileTabKey[ProfileTabs.images],
                  ProfileTabKey[ProfileTabs.transactions],
                ],
                onTab: _handleOnTab,
              ),
              Expanded(
                child: BlocBuilder<LoadUserImagesBloc, LoadUserImagesState>(
                  builder: (context, state) {
                    if (state.status == LoadUserImagesStatus.loaded) {
                      // print('DEBUG images ${state.userImages}');
                      return InquirerProfileTabBarView(
                        tabController: _tabController,
                        userImages: state.userImages,
                      );
                    }

                    return Container(width: 0, height: 0);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _handleOnTab(ValueKey tab) {
    if (tab == ProfileTabKey[ProfileTabs.images]) {
      // load user images bloc
      final imgBloc = BlocProvider.of<LoadUserImagesBloc>(context);
      imgBloc.add(LoadUserImages(
        uuid: widget.uuid,
      ));
    }

    if (tab == ProfileTabKey[ProfileTabs.transactions]) {
      print('DEBUG trigger load transaction tab');
    }
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
