import 'dart:async';
import 'dart:io';
import 'package:darkpanda_flutter/screens/chatroom/bloc/update_is_read_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/components/camera_screen.dart';
import 'package:darkpanda_flutter/screens/rate/rate.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:image/image.dart' as img;

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/models/chat_image.dart';
import 'package:darkpanda_flutter/models/service_details.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/inquirer_profile.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/components/full_screen_image.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/screens/service_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/models/historical_service.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_payment_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_rate_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/services/service_chatroom_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';

import 'package:darkpanda_flutter/contracts/female.dart' show FemaleTabItem;
import 'package:darkpanda_flutter/contracts/male.dart' show MaleAppTabItem;

import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/qr_scanner.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_qrcode_apis.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';

import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/cancel_service_bloc.dart';
import 'bloc/current_service_chatroom_bloc.dart';
import 'bloc/load_cancel_service_bloc.dart';
import 'bloc/scan_service_qrcode_bloc.dart';
import 'bloc/service_qrcode_bloc.dart';
import 'bloc/service_start_notifier_bloc.dart';
import 'components/send_message_bar.dart';
import 'components/service_start_banner.dart';
import 'screen_arguments/qrscanner_screen_arguments.dart';
import '../../components/chatroom_window.dart';
import 'services/service_apis.dart';
import 'components/service_alert_dialog.dart';

import '../../screen_arguments/service_chatroom_screen_arguments.dart';
import 'components/notification_banner.dart';

import '../../bloc/load_service_detail_bloc.dart';
import '../../models/inquiry_detail.dart';
import 'package:darkpanda_flutter/components/chat_bubble_renderer.dart';
import 'package:darkpanda_flutter/models/cancel_service_message.dart';

class ServiceChatroom extends StatefulWidget {
  const ServiceChatroom({
    this.args,
  });

  final ServiceChatroomScreenArguments args;

  @override
  _ServiceChatroomState createState() => _ServiceChatroomState();
}

// TODO:
//   - Cancel service should lock all functionalities in the chatroom
//   - Hit cancel service should show proper dialog to warning user before canceling.
class _ServiceChatroomState extends State<ServiceChatroom>
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

  /// If male user service is paid, the unpaid banner will be hide
  bool _servicePaid = true;

  InquiryDetail _inquiryDetail = InquiryDetail();
  ServiceDetails _serviceDetails = ServiceDetails();
  UpdateInquiryMessage _updateInquiryMessage = UpdateInquiryMessage();
  InquirerProfileArguments _inquirerProfileArguments;

  File _image;
  final picker = ImagePicker();
  ChatImage chatImages;

  /// Show loading when user sending image
  bool _isSendingImage = false;

  bool _showServiceConfirmedNotifier = false;

  /// Is true if service is cancelled
  bool _isDisabledChat = false;

  @override
  void initState() {
    super.initState();

    // Clear state before enter chatroom
    BlocProvider.of<CurrentServiceChatroomBloc>(context).add(
      LeaveCurrentServiceChatroom(),
    );

    _inquiryDetail.channelUuid = widget.args.channelUUID;
    _inquiryDetail.counterPartUuid = widget.args.counterPartUUID;
    _inquiryDetail.inquiryUuid = widget.args.inquiryUUID;
    _inquiryDetail.serviceUuid = widget.args.serviceUUID;
    _inquiryDetail.routeTypes = RouteTypes.fromServiceChatroom;

    _inquirerProfileArguments =
        InquirerProfileArguments(uuid: widget.args.counterPartUUID);

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    _inquiryDetail.avatarUrl = _sender.avatarUrl;

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
    }

    BlocProvider.of<LoadServiceDetailBloc>(context).add(
      LoadServiceDetail(serviceUuid: widget.args.serviceUUID),
    );

    BlocProvider.of<UpdateIsReadBloc>(context).add(
      UpdateIsRead(
        channelUUID: widget.args.channelUUID,
      ),
    );

    _editMessageController.addListener(_handleEditMessage);

    if (widget.args.routeTypes == RouteTypes.fromInquiry) {
      _showServiceConfirmedNotifier = true;

      Timer(Duration(seconds: 8), () {
        setState(() {
          _showServiceConfirmedNotifier = false;
        });
      });
    }
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

  Future _getCameraImage(XFile pickedFile) async {
    final img.Image capturedImage =
        img.decodeImage(await File(pickedFile.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage);

    await File(pickedFile.path).writeAsBytes(img.encodeJpg(orientedImage));

    setState(() {
      if (pickedFile != null) {
        _isSendingImage = true;
        _image = File(pickedFile.path);

        BlocProvider.of<UploadImageMessageBloc>(context).add(
          UploadImageMessage(
            imageFile: _image,
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    setState(() {
      if (pickedFile != null) {
        _isSendingImage = true;
        _image = File(pickedFile.path);

        BlocProvider.of<UploadImageMessageBloc>(context).add(
          UploadImageMessage(
            imageFile: _image,
          ),
        );
      } else {
        print('No image selected.');
      }
    });
  }

  _navigateToRating() {
    HistoricalService historicalService = HistoricalService(
      serviceUuid: _inquiryDetail.serviceUuid,
      chatPartnerUsername: _inquiryDetail.username,
      chatPartnerAvatarUrl: _inquirerProfile.avatarUrl,
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute(
      builder: (context) {
        return Rate(
          chatPartnerAvatarURL: historicalService.chatPartnerAvatarUrl,
          chatPartnerUsername: historicalService.chatPartnerUsername,
          serviceUUID: historicalService.serviceUuid,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If is female, use pop
        if (_sender.gender == Gender.female) {
          // If user is from inquiry chatroom
          if (widget.args.routeTypes == RouteTypes.fromInquiry) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(
              MainRoutes.female,
              ModalRoute.withName('/'),
              arguments: FemaleTabItem.manage,
            );
          } else {
            Navigator.of(context).pop();
          }
        }
        // If is male, go to MaleApp()
        else {
          // To avoid Duplicate GlobalKey issue
          print("service_chatroom: " + widget.args.routeTypes.toString());
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

        return false;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    MultiBlocListener(
                      listeners: [
                        BlocListener<UploadImageMessageBloc,
                            UploadImageMessageState>(
                          listener: (context, state) {
                            if (state.status == AsyncLoadingStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error.message),
                                ),
                              );
                            }

                            if (state.status == AsyncLoadingStatus.done) {
                              chatImages = state.chatImages;

                              BlocProvider.of<SendImageMessageBloc>(context)
                                  .add(
                                SendImageMessage(
                                  imageUrl: chatImages.thumbnails[0],
                                  channelUUID: widget.args.channelUUID,
                                ),
                              );
                            }
                          },
                        ),
                        BlocListener<SendImageMessageBloc,
                            SendImageMessageState>(
                          listener: (context, state) {
                            if (state.status == AsyncLoadingStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error.message),
                                ),
                              );
                            }

                            if (state.status == AsyncLoadingStatus.done) {
                              setState(() {
                                _isSendingImage = false;
                              });
                            }
                          },
                        ),
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
                                _serviceDetails = state.serviceDetails;
                                _updateInquiryMessage.duration =
                                    _serviceDetails.duration;
                                _updateInquiryMessage.address =
                                    _serviceDetails.address;
                                _updateInquiryMessage.serviceTime =
                                    _serviceDetails.appointmentTime;
                                _updateInquiryMessage.matchingFee =
                                    _serviceDetails.matchingFee;
                                _updateInquiryMessage.price =
                                    _serviceDetails.price;

                                _inquiryDetail.updateInquiryMessage =
                                    _updateInquiryMessage;
                              });
                            }
                          },
                        ),
                      ],
                      child: _showServiceConfirmedNotifier
                          ? NotificationBanner(
                              avatarUrl: _inquirerProfile.avatarUrl,
                            )
                          : Container(),
                    ),

                    // Service started banner
                    BlocListener<ServiceStartNotifierBloc,
                        ServiceStartNotifierState>(
                      listener: (context, state) {
                        print('[Debug] Service start notifier');

                        setState(() {
                          _serviceDetails.copyWith(
                            serviceStatus: ServiceStatus.fulfilling.name,
                          );
                        });
                      },
                      child: _serviceDetails.serviceStatus ==
                              ServiceStatus.fulfilling.name
                          ? ServiceStartBanner(
                              inquirerProfile: _inquirerProfile,
                              serviceDetails: _serviceDetails,
                            )
                          : SizedBox.shrink(),
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
                            children: <Widget>[
                              BlocConsumer<CurrentServiceChatroomBloc,
                                  CurrentServiceChatroomState>(
                                listener: (context, state) {
                                  if (state.status ==
                                      AsyncLoadingStatus.error) {
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

                                      _serviceDetails =
                                          _serviceDetails.copyWith(
                                        serviceStatus: state.service.status,
                                      );

                                      if (state.service.status ==
                                          ServiceStatus.unpaid.name) {
                                        _servicePaid = false;
                                      } else if (state.service.status ==
                                          ServiceStatus.to_be_fulfilled.name) {
                                        _servicePaid = true;
                                      } else if (state.service.status ==
                                          ServiceStatus.completed.name) {
                                        _navigateToRating();
                                      } else if (state.service.status ==
                                          ServiceStatus.expired.name) {
                                        _isDisabledChat = true;
                                      }
                                    });
                                  }

                                  // Display cancel dialog when received CancelServiceMessage.
                                  if (state.currentMessages.isNotEmpty &&
                                      state.currentMessages.first
                                          is CancelServiceMessage) {
                                    // - Display popup saying the counter part has cancel the service. Showing buttons to comment or leave the chatroom
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: ServiceAlertDialog(
                                                confirmText:
                                                    AppLocalizations.of(context)
                                                        .proceedRating,
                                                cancelText:
                                                    AppLocalizations.of(context)
                                                        .cancelRating,
                                                content: AppLocalizations.of(
                                                        context)
                                                    .serviceCanceledByOtherDialogText(
                                                        _inquiryDetail
                                                            .username),
                                                onConfirm: () async {
                                                  // Redirect to commenting page.
                                                  Navigator.of(context).pop();
                                                  _navigateToRating();
                                                },
                                                onDismiss: () async {
                                                  // Back until is the first page of MaleAppTabItem.manage NavigatorState.
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                }),
                                          );
                                        });
                                  }
                                },
                                builder: (context, state) {
                                  if (_doneInitChatroom) {
                                    return UnfocusPrimary(
                                      child: ChatroomWindow(
                                        scrollController: scrollController,
                                        historicalMessages:
                                            state.historicalMessages,
                                        currentMessages: state.currentMessages,
                                        isSendingImage: _isSendingImage,
                                        onUpdateIsRead: (message) async {
                                          if (message.from != _sender.uuid) {
                                            BlocProvider.of<UpdateIsReadBloc>(
                                                    context)
                                                .add(
                                              UpdateIsRead(
                                                channelUUID:
                                                    widget.args.channelUUID,
                                              ),
                                            );
                                          }
                                        },
                                        builder:
                                            (BuildContext context, message) {
                                          // Render different chat bubble based on message type.
                                          return ChatBubbleRenderer(
                                            message: message,
                                            isMe: _sender.uuid == message.from,
                                            myGender: _sender.gender,
                                            avatarURL:
                                                _inquirerProfile.avatarUrl,
                                            onTabImageBubble: (imageMessage) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) {
                                                    return FullScreenImage(
                                                      imageUrl: imageMessage
                                                          .imageUrls[0],
                                                      tag: "chat_image",
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        height: 50,
                                        child: LoadingIcon(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    _doneInitChatroom ? _buildMessageBar() : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceDetailButton() {
    return Align(
      child: GestureDetector(
        onTap: () {
          HistoricalService historicalService = HistoricalService(
            serviceUuid: widget.args.serviceUUID,
            chatPartnerUsername: _inquiryDetail.username,
            appointmentTime: _inquiryDetail.updateInquiryMessage.serviceTime,
            status: _serviceDetails.serviceStatus,
          );

          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LoadPaymentDetailBloc(
                      apiClient: ServiceChatroomClient(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => LoadRateDetailBloc(
                      apiClient: ServiceChatroomClient(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => CancelServiceBloc(
                      serviceAPIs: ServiceAPIs(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => LoadCancelServiceBloc(
                      serviceAPIs: ServiceAPIs(),
                    ),
                  ),
                ],
                child: ServiceDetail(
                  historicalService: historicalService,
                  serviceDetails: _serviceDetails,
                ),
              );
            },
          )).then((value) {
            // Update state for cancel service status
            setState(() {});
          });
        },
        child: Text(
          '服務內容',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _qrcodeScannerButton() {
    return Padding(
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
                BlocProvider(
                  create: (context) => ScanServiceQrCodeBloc(
                    serviceQrCodeApis: ServiceQrCodeAPIs(),
                  ),
                ),
              ],
              child: QrScanner(
                args: QrscannerScreenArguments(
                  serviceUuid: widget.args.serviceUUID,
                ),
                onScanDoneBack: () {
                  Navigator.pop(context);

                  BlocProvider.of<LoadServiceDetailBloc>(context).add(
                    LoadServiceDetail(serviceUuid: widget.args.serviceUUID),
                  );
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.qr_code_scanner),
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
        isDisabledChat: _isDisabledChat,
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
        onImageGallery: () {
          _getGalleryImage();
        },
        onCamera: () {
          // _getCameraImage();
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(
            MaterialPageRoute(
              builder: (context) => CameraScreen(
                onTakePhoto: (xFile) {
                  _getCameraImage(xFile);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      leading: IconButton(
        alignment: Alignment.centerRight,
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () {
          // If is female, use pop
          if (_sender.gender == Gender.female) {
            // If user is from inquiry chatroom
            if (widget.args.routeTypes == RouteTypes.fromInquiry) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(
                MainRoutes.female,
                ModalRoute.withName('/'),
                arguments: FemaleTabItem.manage,
              );
            } else {
              Navigator.of(context).pop();
            }
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
      title:
          BlocBuilder<CurrentServiceChatroomBloc, CurrentServiceChatroomState>(
        builder: (context, state) {
          if (state.status == AsyncLoadingStatus.done) {
            _inquiryDetail.username = state.userProfile.username;
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => LoadUserImagesBloc(
                            userApi: UserApis(),
                          ),
                        ),
                        BlocProvider(
                          create: (context) => LoadHistoricalServicesBloc(
                            userApi: UserApis(),
                          ),
                        ),
                        BlocProvider(
                          create: (context) => LoadRateBloc(
                            rateApiClient: RateApiClient(),
                          ),
                        ),
                      ],
                      child: InquirerProfile(
                        loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
                        args: _inquirerProfileArguments,
                      ),
                    );
                  },
                ),
              );
            },
            child: Text(
              state.status == AsyncLoadingStatus.done
                  ? state.userProfile.username
                  : '',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        _isDisabledChat ? SizedBox.shrink() : _serviceDetailButton(),
        SizedBox(width: 20),
        if (_serviceDetails.serviceStatus ==
            ServiceStatus.to_be_fulfilled.name) ...[
          if (_isDisabledChat) ...[
            SizedBox.shrink(),
          ] else ...[
            _qrcodeScannerButton(),
          ]
        ] else ...[
          SizedBox.shrink(),
        ]
      ],
    );
  }
}
