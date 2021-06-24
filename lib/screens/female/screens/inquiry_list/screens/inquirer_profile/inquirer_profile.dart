import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/components/review.dart';
import 'package:darkpanda_flutter/screens/profile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_rating.dart';

import './models/historical_service.dart';
import '../../screen_arguments/args.dart';

part 'components/inquirer_profile_status_bar.dart';
part 'components/inquirer_profile_tabs.dart';
part 'components/inquirer_profile_images.dart';
part 'components/inquirer_profile_services.dart';
part 'components/inquirer_description.dart';
part 'components/inquirer_gallery_image.dart';
part 'components/inquirer_comment_card.dart';
part 'components/inquirer_profile_page.dart';

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
    this.loadUserBloc,
  });

  final LoadUserBloc loadUserBloc;
  final InquirerProfileArguments args;

  @override
  _InquirerProfileState createState() => _InquirerProfileState();
}

class _InquirerProfileState extends State<InquirerProfile>
    with SingleTickerProviderStateMixin {
  String appBarUserame = '';

  UserRatings userRatings = UserRatings();

  @override
  void initState() {
    widget.loadUserBloc.add(
      LoadUser(uuid: widget.args.uuid),
    );

    BlocProvider.of<LoadRateBloc>(context)
        .add(LoadRate(uuid: widget.args.uuid));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          95.0,
        ),
        child: BlocBuilder<LoadUserBloc, LoadUserState>(
          builder: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              return AppBar(
                flexibleSpace: Image(
                  image: state.userProfile.avatarUrl == null
                      ? NetworkImage(
                          state.userProfile.avatarUrl,
                        )
                      : NetworkImage(
                          'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg'),
                  fit: BoxFit.fill,
                ),
              );
            }

            return AppBar(
              flexibleSpace: Image(
                image: NetworkImage(
                    'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg'),
                fit: BoxFit.fill,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LoadUserBloc, LoadUserState>(
          builder: (context, state) {
            // If is loading user profile, display loading page.
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

            return BlocBuilder<LoadRateBloc, LoadRateState>(
              builder: (context, rateState) {
                if (rateState.status == AsyncLoadingStatus.loading ||
                    rateState.status == AsyncLoadingStatus.initial) {
                  return Row(
                    children: [
                      LoadingScreen(),
                    ],
                  );
                }
                if (rateState.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(rateState.error.message),
                    ),
                  );

                  return Container();
                }

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: InquirerProfilePage(
                    userProfile: state.userProfile,
                    userRatings: rateState.userRatings,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
