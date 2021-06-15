import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chat_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chatroom_window.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/confirmed_service_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/disagree_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/update_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/send_message_bar.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/topup_dp_arguements.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';

import 'bloc/disagree_inquiry_bloc.dart';
import 'bloc/exit_chatroom_bloc.dart';
import 'bloc/update_inquitry_notifier_bloc.dart';
import 'bloc/send_emit_service_confirm_message_bloc.dart';
import 'components/exit_chatroom_confirmation_dialog.dart';
import 'components/inquiry_detail_dialog.dart';
import 'screen_arguments/service_chatroom_screen_arguments.dart';

class MaleChatroom extends StatefulWidget {
  MaleChatroom({
    this.args,
    this.onPush,
  });

  final MaleChatroomScreenArguments args;
  final Function(String, TopUpDpArguments) onPush;

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

  UpdateInquiryMessage message = UpdateInquiryMessage();

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
            BlocProvider.of<ExitChatroomBloc>(context).add(
              QuitChatroom(widget.args.channelUUID),
            );
          }
          return false;
        });
        return result;
      },
      child: BlocListener<ExitChatroomBloc, ExitChatroomState>(
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
                                        return UpdateInquiryBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                          onTapMessage: (message) {
                                            // Slideup inquiry pannel.
                                            // _animationController.forward();
                                          },
                                        );
                                      } else if (message
                                          is DisagreeInquiryMessage) {
                                        return DisagreeInquiryBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                        );
                                      } else {
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
                                message = state.message;
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
                                    BlocProvider.of<
                                                SendEmitServiceConfirmMessageBloc>(
                                            context)
                                        .add(
                                      EmitServiceConfirmMessage(
                                          widget.args.inquiryUUID),
                                    );
                                  }
                                  // Reject inquiry
                                  else {
                                    BlocProvider.of<DisagreeInquiryBloc>(
                                            context)
                                        .add(
                                      DisagreeInquiry(widget.args.channelUUID),
                                    );
                                  }
                                });
                              });
                            },
                            child: SizedBox.shrink(),
                          ),

                          // Load my darkpanda coin balance
                          // If enough balance will go to service payment screen
                          // else go to topup dp screen
                          BlocListener<LoadMyDpBloc, LoadMyDpState>(
                            listener: (context, state) {
                              if (state.status == AsyncLoadingStatus.done) {
                                if (message.price > state.myDp.balance) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) => LoadMyDpBloc(
                                                apiClient: TopUpClient(),
                                              ),
                                            ),
                                            BlocProvider(
                                              create: (context) =>
                                                  LoadDpPackageBloc(
                                                apiClient: TopUpClient(),
                                              ),
                                            ),
                                          ],
                                          child: TopupDp(
                                            args: message,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  print('go to payment screen');
                                }
                              }
                            },
                            child: SizedBox.shrink(),
                          ),

                          // Send emit service confirm message
                          BlocListener<SendEmitServiceConfirmMessageBloc,
                              SendEmitServiceConfirmMessageState>(
                            listener: (context, state) {
                              if (state.status == AsyncLoadingStatus.done) {
                                BlocProvider.of<LoadMyDpBloc>(context).add(
                                  LoadMyDp(),
                                );
                              }
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
              BlocProvider.of<ExitChatroomBloc>(context).add(
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
