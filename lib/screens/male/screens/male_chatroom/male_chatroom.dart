import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chat_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chatroom_window.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/confirmed_service_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/update_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/current_chatroom_bloc.dart';
// import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/current_service_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/send_message_bar.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/update_inquitry_notifier_bloc.dart';
import 'components/exit_chatroom_confirmation_dialog.dart';
import 'components/inquiry_detail_dialog.dart';
import 'screen_arguments/service_chatroom_screen_arguments.dart';

class MaleChatroom extends StatefulWidget {
  MaleChatroom({this.args});

  final MaleChatroomScreenArguments args;

  @override
  _MaleChatroomState createState() => _MaleChatroomState();
}

class _MaleChatroomState extends State<MaleChatroom>
    with SingleTickerProviderStateMixin {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _message;
  AuthUser _sender;

  /// Lock the message bar functionalities if we are still initialzing chatroom.
  /// until chatroom is done initializing.
  bool _doneInitChatroom = false;

  /// Information of the inquirer that the current user is talking with.
  UserProfile _inquirerProfile = UserProfile();

  // bool _isUpdateInquiry = false;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(
          channelUUID: widget.args.channelUUID,
          inquirerUUID: widget.args.counterPartUUID),
    );

    _editMessageController.addListener(_handleEditMessage);
  }

  @override
  void dispose() {
    super.dispose();

    _editMessageController.dispose();
  }

  _handleEditMessage() {
    setState(() {
      _message = _editMessageController.value.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ExitChatroomConfirmationDialog();
          },
        ).then((value) {
          if (value) {
            BlocProvider.of<CancelInquiryBloc>(context).add(
              QuitChatroom(widget.args.channelUUID),
            );
          }
          return false;
        });
        return result;
      },
      child: BlocListener<CancelInquiryBloc, CancelInquiryState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.done) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: LoadMoreScrollable(
                    scrollController: _scrollController,
                    onLoadMore: () {
                      BlocProvider.of<CurrentChatroomBloc>(context).add(
                        FetchMoreHistoricalMessages(
                          channelUUID: widget.args.channelUUID,
                        ),
                      );
                    },
                    builder: (context, scrollController) {
                      return Stack(
                        children: <Widget>[
                          BlocListener<ServiceConfirmNotifierBloc,
                              ServiceConfirmNotifierState>(
                            listener: (context, state) {
                              setState(() {});
                            },
                            child: BlocConsumer<CurrentChatroomBloc,
                                CurrentChatroomState>(
                              listener: (context, state) {
                                if (state.status == AsyncLoadingStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.error.message),
                                    ),
                                  );
                                }

                                // Enable message bar once done initializing.
                                if (state.status == AsyncLoadingStatus.done) {
                                  setState(() {
                                    _doneInitChatroom = true;

                                    _inquirerProfile = state.userProfile;
                                  });
                                }
                              },
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    // Dismiss keyboard when user clicks on chat window.
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  child: ChatroomWindow(
                                    scrollController: scrollController,
                                    historicalMessages:
                                        state.historicalMessages,
                                    currentMessages: state.currentMessages,
                                    builder: (BuildContext context, message) {
                                      if (message is ServiceConfirmedMessage) {
                                        return ConfirmedServiceBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                        );
                                      } else if (message
                                          is UpdateInquiryMessage) {
                                        // _isUpdateInquiry = true;
                                        return UpdateInquiryBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                          onTapMessage: (message) {
                                            // Slideup inquiry pannel.
                                            // _animationController.forward();
                                          },
                                        );
                                      } else {
                                        print(message);
                                        return ChatBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          // When male receive inquiry from female, a
                          // inquiry detail dialog will pop up
                          BlocListener<UpdateInquiryNotifierBloc,
                              UpdateInquiryNotifierState>(
                            listener: (context, state) {
                              setState(() {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return InquiryDetailDialog(
                                        message: state.message);
                                  },
                                ).then((value) {
                                  // Go to payment
                                  if (value) {
                                  }
                                  // Reject
                                  else {
                                    BlocProvider.of<CancelInquiryBloc>(context)
                                        .add(
                                      DisagreeInquiry(widget.args.channelUUID),
                                    );
                                  }
                                });
                              });
                            },
                            child: SizedBox.shrink(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _doneInitChatroom
                    ? _buildMessageBar()
                    : Center(
                        child: Container(
                          height: 50,
                          child: LoadingIcon(),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ExitChatroomConfirmationDialog();
            },
          ).then((value) {
            if (value) {
              BlocProvider.of<CancelInquiryBloc>(context).add(
                QuitChatroom(widget.args.channelUUID),
              );
            }
          });
        },
      ),
      title: BlocBuilder<CurrentChatroomBloc, CurrentChatroomState>(
        builder: (context, state) {
          return Text(
            state.status == AsyncLoadingStatus.done
                ? state.userProfile.username
                : '',
            style: TextStyle(
              fontSize: 18,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBar() {
    return BlocListener<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          _editMessageController.clear();
        }
      },
      child: SendMessageBar(
        editMessageController: _editMessageController,
        onSend: () {
          if (_message.isEmpty) {
            return;
          }

          BlocProvider.of<SendMessageBloc>(context).add(
            SendTextMessage(
              content: _message,
              channelUUID: widget.args.channelUUID,
            ),
          );
        },
      ),
    );
  }
}
