import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';

import 'package:darkpanda_flutter/screens/male/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/qr_scanner.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/payment_completed_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/models/service_detail.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/buy_service.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';

import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_qrcode_apis.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/bloc/buy_service_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';

import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/payment_completed_message.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';

import 'bloc/current_service_chatroom_bloc.dart';
import 'bloc/load_service_detail_bloc.dart';
import 'bloc/service_qrcode_bloc.dart';
import 'components/send_message_bar.dart';
import 'screen_arguments/qrscanner_screen_arguments.dart';
import '../../components/chat_bubble.dart';
import '../../components/confirmed_service_bubble.dart';
import '../../components/update_inquiry_bubble.dart';
import '../../components/chatroom_window.dart';

part 'screen_arguments/service_chatroom_screen_arguments.dart';
part 'components/notification_banner.dart';
part 'components/unpaid_info.dart';

class ServiceChatroom extends StatefulWidget {
  const ServiceChatroom({
    this.args,
  });

  final ServiceChatroomScreenArguments args;

  @override
  _ServiceChatroomState createState() => _ServiceChatroomState();
}

// @TODO:
//   - Init current chatroom - load history messages.
//   - Go to service qrcode scanner.
//   - If is male,
//      - Load dp balance.
//      - If service status is unpaid, show unpaid banner.

class _ServiceChatroomState extends State<ServiceChatroom>
    with SingleTickerProviderStateMixin {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SlideUpController _slideUpController = SlideUpController();

  String _message;
  AuthUser _sender;

  /// If male user confirmed the service, toggle this state to be true to prevent
  /// further editing of the service detail.
  bool _serviceConfirmed = false;

  /// Lock the message bar functionalities if we are still initialzing chatroom.
  /// until chatroom is done initializing.
  bool _doneInitChatroom = false;

  /// Information of the inquirer that the current user is talking with.
  UserProfile _inquirerProfile = UserProfile();

  /// If male user service is paid, the unpaid banner will be hide
  bool _servicePaid = true;

  int _balance = 0;
  InquiryDetail _inquiryDetail = InquiryDetail();
  ServiceDetail _serviceDetail = ServiceDetail();
  UpdateInquiryMessage _updateInquiryMessage = UpdateInquiryMessage();

  @override
  void initState() {
    super.initState();

    _inquiryDetail.channelUuid = widget.args.channelUUID;
    _inquiryDetail.counterPartUuid = widget.args.counterPartUUID;
    _inquiryDetail.inquiryUuid = widget.args.inquiryUUID;
    _inquiryDetail.serviceUuid = widget.args.serviceUUID;

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentServiceChatroomBloc>(context).add(
      InitCurrentServiceChatroom(
          channelUUID: widget.args.channelUUID,
          inquirerUUID: widget.args.counterPartUUID),
    );

    // Only male user to get dp balance
    if (_sender.gender == Gender.male) {
      BlocProvider.of<LoadMyDpBloc>(context).add(
        LoadMyDp(),
      );

      BlocProvider.of<LoadServiceDetailBloc>(context).add(
        LoadServiceDetail(serviceUuid: widget.args.serviceUUID),
      );
    }

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
  void deactivate() {
    BlocProvider.of<CurrentServiceChatroomBloc>(context).add(
      LeaveCurrentServiceChatroom(),
    );

    super.deactivate();
  }

  Widget _buildMessageBar() {
    return BlocListener<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          _editMessageController.clear();
        }
      },
      child: SendMessageBar(
        disable: _serviceConfirmed,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // If is female, use pop
            if (_sender.gender == Gender.female) {
              Navigator.of(context).pop();
            }
            // If is male, go to MaleApp()
            else {
              // To avoid Duplicate GlobalKey issue
              if (widget.args.routeTypes == RouteTypes.fromIncomingService) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  MainRoutes.male,
                  ModalRoute.withName('/'),
                  arguments: MaleAppTabItem.manage,
                );
              }
            }
          },
        ),
        title: BlocBuilder<CurrentServiceChatroomBloc,
            CurrentServiceChatroomState>(
          builder: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              _inquiryDetail.username = state.userProfile.username;
            }

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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => ServiceQrCodeBloc(
                          serviceQrCodeApis: ServiceQrCodeAPIs(),
                        ),
                      ),
                    ],
                    child: QrScanner(
                      args: QrscannerScreenArguments(
                        serviceUuid: widget.args.serviceUUID,
                      ),
                    ),
                  ),
                ));
              },
              child: Icon(Icons.qr_code_scanner),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: Column(
                children: [
                  if (_sender.gender == Gender.male)
                    MultiBlocListener(
                      listeners: [
                        BlocListener<LoadServiceDetailBloc,
                            LoadServiceDetailState>(
                          listener: (context, state) {
                            if (state.status == AsyncLoadingStatus.error) {
                              developer.log(
                                'failed to fetch service detail',
                                error: state.error,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error.message),
                                ),
                              );
                            }

                            if (state.status == AsyncLoadingStatus.done) {
                              setState(() {
                                _serviceDetail = state.serviceDetail;
                                _updateInquiryMessage.duration =
                                    _serviceDetail.duration;
                                _updateInquiryMessage.address =
                                    _serviceDetail.address;
                                _updateInquiryMessage.serviceTime =
                                    _serviceDetail.appointmentTime;
                                _updateInquiryMessage.matchingFee =
                                    _serviceDetail.matchingFee;

                                _inquiryDetail.updateInquiryMessage =
                                    _updateInquiryMessage;
                              });
                            }
                          },
                        ),
                        BlocListener<LoadMyDpBloc, LoadMyDpState>(
                          listener: (context, state) {
                            if (state.status == AsyncLoadingStatus.error) {
                              developer.log(
                                'failed to fetch dp balance',
                                error: state.error,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error.message),
                                ),
                              );
                            }

                            if (state.status == AsyncLoadingStatus.done) {
                              setState(() {
                                _balance = state.myDp.balance;
                                _inquiryDetail.balance = _balance;
                              });
                            }
                          },
                        ),
                      ],
                      child: _servicePaid
                          ? SizedBox.shrink()
                          : UnpaidInfo(
                              inquirerProfile: _inquirerProfile,
                              serviceDetail: _serviceDetail,
                              onGoToPayment: () {
                                if (_serviceDetail.matchingFee > _balance) {
                                  print("Go to Top up dp");
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
                                            args: _inquiryDetail,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  print("Go to Payment");
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
                                            args: _inquiryDetail,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                  Expanded(
                    child: LoadMoreScrollable(
                      scrollController: _scrollController,
                      onLoadMore: () {
                        BlocProvider.of<CurrentServiceChatroomBloc>(context)
                            .add(
                          FetchMoreHistoricalMessages(
                            channelUUID: widget.args.channelUUID,
                          ),
                        );
                      },
                      builder: (context, scrollController) {
                        return Stack(
                          children: [
                            BlocConsumer<CurrentServiceChatroomBloc,
                                CurrentServiceChatroomState>(
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

                                    if (state.service.serviceStatus ==
                                        ServiceStatus.unpaid.name) {
                                      _servicePaid = false;
                                    } else if (state.service.serviceStatus ==
                                        ServiceStatus.to_be_fulfilled.name) {
                                      _servicePaid = true;
                                    }
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
                                      // Render different chat bubble based on message type.
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
                                          is PaymentCompletedMessage) {
                                        return PaymentCompletedBubble(
                                          isMe: _sender.uuid == message.from,
                                          message: message,
                                          onTapMessage: (message) {},
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
      ),
    );
  }
}
