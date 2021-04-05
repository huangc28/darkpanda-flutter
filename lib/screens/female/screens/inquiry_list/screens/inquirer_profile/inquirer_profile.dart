import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/dialogs.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/image_gallery.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import './models/historical_service.dart';
import './bloc/load_user_images_bloc.dart';
import './bloc/load_historical_services_bloc.dart';
import './components/Tag.dart';
import '../../screen_arguments/args.dart';

part 'components/inquirer_profile_status_bar.dart';
part 'components/inquirer_profile_tabs.dart';
part 'components/inquirer_profile_images.dart';
part 'components/inquirer_profile_services.dart';
part 'components/inquirer_description.dart';
part 'components/inquirer_gallery_image.dart';
part 'components/inquirer_comment_card.dart';

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
    this.args,
    this.uuid,
    this.loadUserBloc,
  });

  final String uuid;
  final LoadUserBloc loadUserBloc;
  final InquirerProfileArguments args;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          95.0,
        ),
        child: AppBar(
          flexibleSpace: Image(
            image: NetworkImage(
                'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name bar with rating stars.
                Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Brat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      RatingBarIndicator(
                        unratedColor: Colors.grey,
                        rating: 3,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tags: age, height, weight.
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Tag(
                          text: '22歲',
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Tag(
                          text: '188cm',
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Tag(
                          text: '70kg',
                        ),
                      ),
                    ],
                  ),
                ),

                // Inquirer description.
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '女生們看的真的不只是長相，尤其是想要追求一段長期 關係的女生，只要順眼，大部分女生更在乎的是你到底是一個什麼樣的人。',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                // Inquirer image scroll view.
                Container(
                  padding: EdgeInsets.only(top: 17),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: InquirerGalleryImage(
                            src:
                                'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: InquirerGalleryImage(
                            src:
                                'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: InquirerGalleryImage(
                            src:
                                'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: InquirerGalleryImage(
                            src:
                                'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Comments list.
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  child: Text(
                    '評價(13)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 22),
                Column(
                  children: [
                    Container(
                        child: InquirerCommentCard(),
                        margin: EdgeInsets.only(bottom: 20)),
                    Container(
                        child: InquirerCommentCard(),
                        margin: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ],
            ),
          ),
        ),
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
