import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/current_chatroom_bloc.dart';

import 'package:darkpanda_flutter/components/camera_screen.dart';
import 'package:darkpanda_flutter/components/full_screen_image.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';

import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/models/chat_image.dart';
import 'package:darkpanda_flutter/models/image_message.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'package:darkpanda_flutter/screens/chatroom/components/image_bubble.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/inquirer_profile.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chat_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/chatroom_window.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/confirmed_service_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/disagree_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/update_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/send_message_bar.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/topup_dp_arguements.dart';

import 'package:darkpanda_flutter/services/user_apis.dart';

import 'bloc/disagree_inquiry_bloc.dart';
import 'bloc/exit_chatroom_bloc.dart';
import 'bloc/update_inquitry_notifier_bloc.dart';
import 'bloc/send_emit_service_confirm_message_bloc.dart';
import 'components/exit_chatroom_confirmation_dialog.dart';
import 'components/inquiry_detail_dialog.dart';
import 'models/inquiry_detail.dart';
import 'screen_arguments/service_chatroom_screen_arguments.dart';
import 'screens/male_inquiry_detail.dart';

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
  InquirerProfileArguments _inquirerProfileArguments;

  File _image;
  final picker = ImagePicker();
  ChatImage chatImages;

  /// Show loading when user sending image
  bool _isSendingImage = false;

  @override
  void initState() {
    super.initState();

    inquiryDetail.channelUuid = widget.args.channelUUID;
    inquiryDetail.counterPartUuid = widget.args.counterPartUUID;
    inquiryDetail.inquiryUuid = widget.args.inquiryUUID;
    inquiryDetail.routeTypes = RouteTypes.fromInquiry;

    _inquirerProfileArguments =
        InquirerProfileArguments(uuid: widget.args.counterPartUUID);

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
                                if (_doneInitChatroom) {
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
                                      isSendingImage: _isSendingImage,
                                      builder: (BuildContext context, message) {
                                        if (message
                                            is ServiceConfirmedMessage) {
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
                                        } else if (message is ImageMessage) {
                                          return ImageBubble(
                                            isMe: _sender.uuid == message.from,
                                            message: message,
                                            onEnlarge: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) {
                                                    return FullScreenImage(
                                                      imageUrl:
                                                          message.imageUrls[0],
                                                      tag: "chat_image",
                                                    );
                                                  },
                                                ),
                                              );
                                            },
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
                                      serviceUuid: widget.args.serviceUUID,
                                      messages: messages,
                                    );
                                  },
                                ).then((value) {
                                  // Reject inquiry
                                  if (!value) {
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

                          // Upload image bloc
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
                            child: SizedBox.shrink(),
                          ),

                          // Send image bloc
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
                            child: SizedBox.shrink(),
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
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color.fromRGBO(106, 109, 137, 1),
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
          return GestureDetector(
            onTap: () {
              print('Inquirer profile');
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
        _serviceDetailButton(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _serviceDetailButton() {
    return Align(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => MaleInquiryDetail(
                inquiryUuid: widget.args.inquiryUUID,
                authUser: _sender,
              ),
            ),
          );
        },
        child: Text(
          '交易明細',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
          ),
        ),
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
}
