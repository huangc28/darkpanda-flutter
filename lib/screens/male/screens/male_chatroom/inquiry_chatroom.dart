import 'package:darkpanda_flutter/enums/route_types.dart';
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
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/buy_service.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/bloc/buy_service_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';

import 'bloc/disagree_inquiry_bloc.dart';
import 'bloc/exit_chatroom_bloc.dart';
import 'bloc/update_inquitry_notifier_bloc.dart';
import 'bloc/send_emit_service_confirm_message_bloc.dart';
import 'components/exit_chatroom_confirmation_dialog.dart';
import 'components/inquiry_detail_dialog.dart';
import 'models/inquiry_detail.dart';
import 'screen_arguments/service_chatroom_screen_arguments.dart';

class InquiryChatroom extends StatefulWidget {
  InquiryChatroom({
    this.args,
    this.onPush,
  });

  final MaleChatroomScreenArguments args;
  final Function(String, TopUpDpArguments) onPush;

  @override
  _InquiryChatroomState createState() => _InquiryChatroomState();
}

class _InquiryChatroomState extends State<InquiryChatroom>
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

  UpdateInquiryMessage messages = UpdateInquiryMessage();
  InquiryDetail inquiryDetail = InquiryDetail();

  @override
  void initState() {
    super.initState();

    inquiryDetail.channelUuid = widget.args.channelUUID;
    inquiryDetail.counterPartUuid = widget.args.counterPartUUID;
    inquiryDetail.inquiryUuid = widget.args.inquiryUUID;
    inquiryDetail.routeTypes = RouteTypes.fromInquiry;

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

  @override
  void deactivate() {
    BlocProvider.of<CurrentChatroomBloc>(context).add(
      LeaveCurrentChatroom(),
    );

    super.deactivate();
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
          builder: (_) {
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
                                          onTapMessage: (message) {},
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

                          // 1. When male receive inquiry from female, a
                          // inquiry detail dialog will pop up
                          BlocListener<UpdateInquiryNotifierBloc,
                              UpdateInquiryNotifierState>(
                            listener: (context, state) {
                              setState(() {
                                messages = state.message;
                                inquiryDetail.updateInquiryMessage = messages;
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return InquiryDetailDialog(
                                      inquiryDetail: inquiryDetail,
                                    );
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

                          // 2. Load my darkpanda coin balance
                          // If enough balance will go to service payment screen
                          // else go to topup dp screen
                          BlocListener<LoadMyDpBloc, LoadMyDpState>(
                            listener: (context, state) {
                              if (state.status == AsyncLoadingStatus.initial ||
                                  state.status == AsyncLoadingStatus.loading) {
                                return Row(
                                  children: [
                                    LoadingScreen(),
                                  ],
                                );
                              }
                              if (state.status == AsyncLoadingStatus.done) {
                                inquiryDetail.balance = state.myDp.balance;

                                // Go to Top Up screen
                                if (messages.matchingFee > state.myDp.balance) {
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
                                            args: inquiryDetail,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                // Go to Payment screen
                                else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) =>
                                                  BuyServiceBloc(
                                                searchInquiryAPIs:
                                                    SearchInquiryAPIs(),
                                              ),
                                            ),
                                          ],
                                          child: BuyService(
                                            args: inquiryDetail,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            child: SizedBox.shrink(),
                          ),

                          // 3. Send emit service confirm message
                          BlocListener<SendEmitServiceConfirmMessageBloc,
                              SendEmitServiceConfirmMessageState>(
                            listener: (context, state) {
                              if (state.status == AsyncLoadingStatus.initial ||
                                  state.status == AsyncLoadingStatus.loading) {
                                return Row(
                                  children: [
                                    LoadingScreen(),
                                  ],
                                );
                              }
                              if (state.status == AsyncLoadingStatus.done) {
                                inquiryDetail.serviceUuid = state
                                    .emitServiceConfirmMessageResponse
                                    .serviceChannelUuid;
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
        onPressed: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
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
          inquiryDetail.username = state.userProfile.username ?? '';
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
