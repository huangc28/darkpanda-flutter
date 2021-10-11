import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/bloc/load_female_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/models/female_list.dart';

import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/search_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/direct_search_inquiry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Completer<void> _refreshCompleter;

  List<FemaleUser> _femaleUserList = [];

  LoadFemaleListBloc _loadFemaleListBloc;

  @override
  initState() {
    super.initState();

    _loadFemaleListBloc = BlocProvider.of<LoadFemaleListBloc>(context);

    _refreshCompleter = Completer();
  }

  @override
  void dispose() {
    super.dispose();

    _loadFemaleListBloc.add(ClearFemaleListState());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.tabController,
              children: <Widget>[
                SearchInquiry(),
                _directSearchInquiry(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _directSearchInquiry() {
    return BlocConsumer<LoadFemaleListBloc, LoadFemaleListState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          _refreshCompleter.completeError(state.error);
          _refreshCompleter = Completer();
          developer.log(
            'failed to fetch load imcoming service',
            error: state.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();

          _femaleUserList = state.femaleUsers;
        }
      },
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.initial ||
            state.status == AsyncLoadingStatus.loading) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          return DirectSearchInquiry(
            femaleUserList: _femaleUserList,
            onRefresh: () {
              BlocProvider.of<LoadFemaleListBloc>(context)
                  .add(LoadFemaleList());

              return _refreshCompleter.future;
            },
            onLoadMore: () {
              BlocProvider.of<LoadFemaleListBloc>(context)
                  .add(LoadMoreFemaleList());
            },
          );
        }

        return Container();
      },
    );
  }
}
