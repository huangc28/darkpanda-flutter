import 'dart:io';

import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'package:darkpanda_flutter/components/chat_bubble_renderer.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';

import 'package:darkpanda_flutter/components/camera_screen.dart';
import 'package:darkpanda_flutter/components/full_screen_image.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/models/chat_image.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/message.dart';

import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/inquirer_profile.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/send_message_bar.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/topup_dp_arguements.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';

import 'package:darkpanda_flutter/screens/chatroom/components/chatroom_window.dart';

import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/screens/male/models/negotiating_inquiry_detail.dart';

import 'package:darkpanda_flutter/contracts/male.dart' show MaleAppTabItem;
import 'package:darkpanda_flutter/routes.dart';

import './bloc/disagree_inquiry_bloc.dart';
import './screens/male_inquiry_detail.dart';
import './components/inquiry_detail_dialog.dart';
import '../../components/exit_chatroom_button.dart';
import '../../components/exit_chatroom_confirmation_dialog.dart';
import '../../screen_arguments/male_inquiry_chatroom_screen_arguments.dart';
import '../../bloc/exit_chatroom_bloc.dart';
import '../../bloc/update_inquitry_notifier_bloc.dart';
import '../../bloc/current_chatroom_bloc.dart';
// import '../../views/exit_chatroom_button_view.dart';

class MaleInquiryChatroom extends StatefulWidget {
  MaleInquiryChatroom({
    this.args,
    this.onPush,
  });

  final MaleInquiryChatroomScreenArguments args;
  final Function(String, TopUpDpArguments) onPush;

  @override
  _MaleInquiryChatroomState createState() => _MaleInquiryChatroomState();
}

class _MaleInquiryChatroomState extends State<MaleInquiryChatroom>
    with SingleTickerProviderStateMixin {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _message;
  AuthUser _sender;

  /// Information of the inquirer that the current user is talking with.
  UserProfile _inquirerProfile = UserProfile();

  bool _doneInitChatroom = false;

  UpdateInquiryMessage updatedInquiryMessage = UpdateInquiryMessage();
  InquirerProfileArguments _inquirerProfileArguments;

  File _image;
  final picker = ImagePicker();
  ChatImage chatImages;

  /// Show loading when user sending image
  bool _isSendingImage = false;

  NegotiatingServiceDetail _negotiatingServiceDetail =
      NegotiatingServiceDetail();

  /// Is true if user quit chatroom
  bool _isDisabledChat = false;

  @override
  void initState() {
    super.initState();

    _negotiatingServiceDetail.copy(
      serviceUUID: widget.args.serviceUUID,
      channelUUID: widget.args.channelUUID,
      counterPartUUID: widget.args.counterPartUUID,
      inquiryUUID: widget.args.inquiryUUID,
    );

    InquirerProfileArguments(uuid: widget.args.counterPartUUID);

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(
        channelUUID: widget.args.channelUUID,
        inquirerUUID: widget.args.counterPartUUID,
      ),
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
        if (_isDisabledChat) {
          Navigator.of(context).pop(true);
        } else {
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
            return false;
          });
        }
        return false;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
        child: Stack(alignment: Alignment.bottomCenter, children: [
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
                    children: [
                      BlocListener<ServiceConfirmNotifierBloc,
                          ServiceConfirmNotifierState>(
                        listener: (context, state) {
                          setState(() {});
                        },
                        child: Container(),
                      ),
                      BlocConsumer<CurrentChatroomBloc, CurrentChatroomState>(
                        listener: (context, state) {
                          // TODO text should be displayed in i18n
                          if (state.status == AsyncLoadingStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error.message),
                              ),
                            );
                          }

                          if (state.status == AsyncLoadingStatus.done) {
                            setState(() {
                              _doneInitChatroom = true;

                              _inquirerProfile = state.userProfile;
                            });
                          }

                          if (state.currentMessages.isNotEmpty &&
                              state.currentMessages.first
                                  is QuitChatroomMessage) {
                            setState(() {
                              _isDisabledChat = true;
                            });
                          }
                        },
                        builder: (context, state) {
                          if (state.status == AsyncLoadingStatus.done) {
                            return GestureDetector(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  // Dismiss keyboard when user clicks on chat window.
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                child: _buildChatWindow(
                                  scrollController,
                                  state.historicalMessages,
                                  state.currentMessages,
                                ));
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

                      // When male receive inquiry updated message from female, an inquiry detail dialog will pop up.
                      BlocListener<UpdateInquiryNotifierBloc,
                          UpdateInquiryNotifierState>(
                        listener: (context, state) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              _negotiatingServiceDetail
                                  .copyWithUpdateInquiryMessage(state.message);

                              return InquiryDetailDialog(
                                negotiatingInquiryDetail:
                                    _negotiatingServiceDetail,
                              );
                            },
                          ).then((value) {
                            // Reject inquiry
                            if (!value) {
                              BlocProvider.of<DisagreeInquiryBloc>(context).add(
                                DisagreeInquiry(widget.args.channelUUID),
                              );
                            }
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

                            BlocProvider.of<SendImageMessageBloc>(context).add(
                              SendImageMessage(
                                imageUrl: chatImages.thumbnails[0],
                                channelUUID: widget.args.channelUUID,
                              ),
                            );
                          }
                        },
                        child: SizedBox.shrink(),
                      ),

                      BlocListener<SendImageMessageBloc, SendImageMessageState>(
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
      )
    ]));
  }

  Widget _buildChatWindow(
    ScrollController scrollController,
    List<Message> historicalMessages,
    List<Message> currentMessages,
  ) {
    return ChatroomWindow(
      scrollController: scrollController,
      historicalMessages: historicalMessages,
      currentMessages: currentMessages,
      isSendingImage: _isSendingImage,
      builder: (BuildContext context, message) {
        return ChatBubbleRenderer(
          message: message,
          isMe: _sender.uuid == message.from,
          myGender: _sender.gender,
          avatarURL: _inquirerProfile.avatarUrl,
          onTabUpdateInquiryBubble: (updateInquiryMessage) {
            showDialog(
              context: context,
              builder: (_) {
                _negotiatingServiceDetail.copyWithUpdateInquiryMessage(
                  updateInquiryMessage,
                );

                return InquiryDetailDialog(
                  negotiatingInquiryDetail: _negotiatingServiceDetail,
                );
              },
            );
          },
          onTabImageBubble: (imageMessage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return FullScreenImage(
                    imageUrl: imageMessage.imageUrls[0],
                    tag: "chat_image",
                  );
                },
              ),
            );
          },
        );
      },
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
          Navigator.of(context).pushReplacementNamed(
            MainRoutes.male,
            arguments: MaleAppTabItem.chat,
          );
        },
      ),
      title: BlocBuilder<CurrentChatroomBloc, CurrentChatroomState>(
        builder: (context, state) {
          _negotiatingServiceDetail.username = state.userProfile.username ?? '';
          _negotiatingServiceDetail.avatarUrl =
              state.userProfile.avatarUrl ?? '';
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
        _isDisabledChat ? SizedBox.shrink() : _buildChatroomActionBar(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildChatroomActionBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildServiceDetailButton(),
        _buildExitChatroomButton(),
      ],
    );
  }

  Widget _buildServiceDetailButton() {
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

  Widget _buildExitChatroomButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: BlocListener<ExitChatroomBloc, ExitChatroomState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          }

          if (state.status == AsyncLoadingStatus.loading) {
            setState(() {
              _isDisabledChat = true;
            });
          }

          if (state.status == AsyncLoadingStatus.done) {
            Navigator.of(context).pushReplacementNamed(
              MainRoutes.male,
              arguments: MaleAppTabItem.waitingInquiry,
            );
          }
        },
        child: ExitChatroomButton(
          onExit: () async {
            final value = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => ExitChatroomConfirmationDialog(),
            );

            if (value) {
              BlocProvider.of<ExitChatroomBloc>(context).add(
                QuitChatroom(widget.args.channelUUID),
              );
            }
          },
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
