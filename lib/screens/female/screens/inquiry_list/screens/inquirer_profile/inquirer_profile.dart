import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/dialogs.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/image_gallery.dart';

import './models/historical_service.dart';
import './bloc/load_user_images_bloc.dart';
import './bloc/load_historical_services_bloc.dart';

part 'inquirer_profile_status_bar.dart';
part 'inquirer_profile_tabs.dart';
part 'inquirer_profile_images.dart';
part 'inquirer_profile_services.dart';

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
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BlocBuilder<LoadUserImagesBloc, LoadUserImagesState>(
                      builder: (context, state) => InquirerProfileImages(
                        images: state.userImages,
                        onLoadMoreImages: _handleOnLoadMoreImages,
                        onTapImage: (int index) =>
                            _handleTapImage(index, state.userImages),
                      ),
                    ),
                    BlocBuilder<LoadHistoricalServicesBloc,
                        LoadHistoricalServicesState>(
                      builder: (context, state) => InquirerProfileServices(
                        services: state.historicalServices,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _handleTapImage(int index, List<UserImage> userImages) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return ImageGallery(
            userImages: userImages,
            initialPage: index,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  _handleOnLoadMoreImages() {
    // get current profile image page number
    final bloc = BlocProvider.of<LoadUserImagesBloc>(context);
    final currentPage = bloc.state.currentPage;
    bloc.add(
      LoadUserImages(
        uuid: widget.uuid,
        pageNum: currentPage + 1,
      ),
    );
  }

  _handleOnTab(ValueKey tab) {
    if (tab == ProfileTabKey[ProfileTabs.images]) {
      // load user images bloc
      BlocProvider.of<LoadUserImagesBloc>(context).add(
        LoadUserImages(
          uuid: widget.uuid,
        ),
      );
    }

    if (tab == ProfileTabKey[ProfileTabs.transactions]) {
      BlocProvider.of<LoadHistoricalServicesBloc>(context).add(
        LoadHistoricalServices(
          uuid: widget.uuid,
        ),
      );
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
                backgroundColor: Colors.black,
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
              description,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ));
  }

  Widget _buildSendMessageRow() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 10,
      ),
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
