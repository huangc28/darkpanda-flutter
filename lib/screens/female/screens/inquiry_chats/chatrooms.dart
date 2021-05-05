import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/layouts/system_ui_overlay_layout.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/chatroom.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/models/chatroom.dart' as chatroomModel;
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'components/chatrooms_list.dart';
import 'components/chatroom_grid.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({
    this.onPush,
  });

  final OnPush onPush;

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  InquiryChatroomsBloc _inquiryChatroomsBloc;

  bool _hasDoneLoadingUserAndNavigate = false;

  /// Emit flutter bloc event in lifecycle `Dispose` https://github.com/felangel/bloc/issues/588.
  @override
  void initState() {
    _inquiryChatroomsBloc = BlocProvider.of<InquiryChatroomsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _inquiryChatroomsBloc.add(ClearInquiryChatList());
    print('DEBUG trigger dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SystemUiOverlayLayout(
        child: SafeArea(
          child: Column(
            children: [
              // Inquiry chatrooms title
              Text(
                '聊天詢問',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.53,
                ),
              ),
              BlocConsumer<InquiryChatroomsBloc, InquiryChatroomsState>(
                listener: (context, state) {
                  // Display error in snack bar.
                  if (state.status == AsyncLoadingStatus.error) {
                    developer.log(
                      'failed to fetch inquiry chatroom',
                      error: state.error,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == AsyncLoadingStatus.loading ||
                      state.status == AsyncLoadingStatus.initial) {
                    return LoadingScreen();
                  }

                  return ChatroomList(
                    chatrooms: state.chatrooms,
                    onRefresh: () {
                      print('DEBUG trigger onRefresh');
                    },
                    onLoadMore: () {
                      print('DEBUG trigger onLoadMore');
                    },
                    chatroomBuilder: (context, chatroom, ___) {
                      final lastMsg =
                          state.chatroomLastMessage[chatroom.channelUUID];

                      // Loading inquirier info before proceeding to chatroom.
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
                                  channelUUID: chatroom.channelUUID,
                                  inquiryUUID: chatroom.inquiryUUID,
                                  serviceType: chatroom.serviceType,
                                  inquirerProfile: state.userProfile,
                                ),
                              )
                                  .then((dynamic value) {
                                setState(() {
                                  _hasDoneLoadingUserAndNavigate = false;
                                });
                              });
                            }
                          }

                          if (state.status == AsyncLoadingStatus.error) {
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
                          child: ChatroomGrid(
                            onEnterChat: (chatroomModel.Chatroom chatroom) {
                              return _onEnterChat(
                                context,
                                chatroom.inquirerUUID,
                              );
                            },
                            chatroom: chatroom,
                            lastMessage: lastMsg.content,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
}
