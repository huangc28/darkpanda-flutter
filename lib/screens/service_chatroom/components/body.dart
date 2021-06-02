import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/chatroom.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/models/incoming_service.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/service_chatroom/bloc/load_incoming_service_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  LoadIncomingServiceBloc loadIncomingServiceBloc =
      new LoadIncomingServiceBloc();
  TabController _tabController;
  bool _hasDoneLoadingUserAndNavigate = false;
  List<IncomingService> incomingService;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    BlocProvider.of<LoadIncomingServiceBloc>(context)
        .add(LoadIncomingService());
  }

  @override
  void dispose() {
    loadIncomingServiceBloc.add(ClearIncomingServiceState());

    super.dispose();
  }

  void _onEnterChat(
    BuildContext context,
    String inquirerUUID,
  ) {
    // Retrieve inquirer information here.
    BlocProvider.of<LoadUserBloc>(context).add(
      LoadUser(uuid: inquirerUUID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                comingTab(),
                Text("456"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget comingTab() {
    return BlocConsumer<LoadIncomingServiceBloc, LoadIncomingServiceState>(
      listener: (BuildContext context, LoadIncomingServiceState state) {},
      builder: (BuildContext context, LoadIncomingServiceState state) {
        if (state.status == AsyncLoadingStatus.initial ||
            state.status == AsyncLoadingStatus.loading) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        } else if (state.status == AsyncLoadingStatus.done) {
          incomingService = state.services;
          return ServiceChatroomList(
            chatrooms: state.services,
            onRefresh: () {
              print('DEBUG trigger onRefresh');
            },
            onLoadMore: () {
              print('DEBUG trigger onLoadMore');
            },
            chatroomBuilder: (context, chatroom, ___) {
              final lastMsg = state.chatroomLastMessage[chatroom.channelUuid];

              return BlocListener<LoadUserBloc, LoadUserState>(
                listener: (context, state) {
                  if (state.status == AsyncLoadingStatus.done) {
                    if (!_hasDoneLoadingUserAndNavigate) {
                      setState(() {
                        _hasDoneLoadingUserAndNavigate = true;
                      });

                      Navigator.of(
                        context,
                        rootNavigator: true,
                      )
                          .pushNamed(
                        MainRoutes.chatroom,
                        arguments: ChatroomScreenArguments(
                          channelUUID: chatroom.channelUuid,
                          inquiryUUID: chatroom.inquiryUuid,
                          serviceType: 'sex',
                          // inquirerProfile: state.userProfile,
                          isInquiry: false,
                        ),
                      )
                          .then((dynamic value) {
                        setState(() {
                          _hasDoneLoadingUserAndNavigate = false;
                        });
                      });
                    }
                  } else if (state.status == AsyncLoadingStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.error.message,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: ServiceChatroomGrid(
                    onEnterChat: (chatroom) {
                      return _onEnterChat(
                        context,
                        chatroom.userUuid,
                      );
                    },
                    chatroom: chatroom,
                    lastMessage: lastMsg == null ? "" : lastMsg.content,
                  ),
                ),
              );
            },
          );
          // SizedBox(
          //   child: ListView.builder(
          //     itemCount: incomingService.length,
          //     itemBuilder: (context, index) => ChatCard(
          //       chat: incomingService[index],
          //       press: () {},
          //     ),
          //   ),
          // );
        } else {
          return Container();
        }
      },
    );
  }
}
