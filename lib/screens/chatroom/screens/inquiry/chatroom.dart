import 'dart:io';

import 'package:darkpanda_flutter/components/full_screen_image.dart';
import 'package:darkpanda_flutter/models/chat_image.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/models/image_message.dart';
import 'package:darkpanda_flutter/models/payment_completed_message.dart';
import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/disagree_inquiry_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/image_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/payment_completed_bubble.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/quit_chatroom_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';

import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/current_chatroom_bloc.dart';
import 'bloc/get_inquiry_bloc.dart';
import 'bloc/update_inquiry_bloc.dart';
import 'components/send_message_bar.dart';
import 'components/service_settings/service_settings.dart';

import '../../components/chat_bubble.dart';
import '../../components/confirmed_service_bubble.dart';
import '../../components/update_inquiry_bubble.dart';
import '../../components/chatroom_window.dart';
import '../../../../models/service_settings.dart';

part 'screen_arguments/chatroom_screen_arguments.dart';
part 'components/notification_banner.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    this.args,
  });

  final ChatroomScreenArguments args;

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom>
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

  /// Animations controllers.
  /// TODO: slide animation should be extract to a mixin or parent widget.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  /// [ServiceSettings] model to be passed down to service settings sheet.
  ServiceSettings _serviceSettings;

  File _image;
  final picker = ImagePicker();
  List<ChatImage> chatImages = [];

  /// Show loading when user sending image
  bool _isSendingImage = false;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(
          channelUUID: widget.args.channelUUID,
          inquirerUUID: widget.args.counterPartUUID),
    );

    // Fetch inquiry related inquiry if exists.
    BlocProvider.of<GetInquiryBloc>(context).add(
      GetInquiry(inquiryUuid: widget.args.inquiryUUID),
    );

    _editMessageController.addListener(_handleEditMessage);

    // Initialize slideup panel animation.
    _initSlideUpAnimation();
  }

  _initSlideUpAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          // Start animation at begin
          _slideUpController.toggle();
        } else if (status == AnimationStatus.dismissed) {
          // To hide widget, we need complete animation first
          _slideUpController.toggle();
        }
      });

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));
  }

  @override
  void dispose() {
    super.dispose();

    _editMessageController.dispose();
    _animationController.dispose();
  }

  _handleEditMessage() {
    setState(() {
      _message = _editMessageController.value.text;
    });
  }

  @override
  void deactivate() {
    BlocProvider.of<CurrentChatroomBloc>(context).add(
      LeaveCurrentChatroom(),
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
        onEditInquiry: _handleTapEditInquiry,
        onImageGallery: () {
          _getGalleryImage();
        },
        onCamera: () {
          _getCameraImage();
        },
      ),
    );
  }

  Future _getCameraImage() async {
    await Future.delayed(Duration(milliseconds: 500)); // To avoid app crash
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
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

  Future _getGalleryImage() async {
    final pickedFile = await picker.getImage(
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
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                child: Column(
                  children: [
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
                                  setState(() {
                                    // If male user confirmed the service, toggle the _serviceConfirmed to be true.
                                    // so that the female user can not edit the service anymore.
                                    _serviceConfirmed = true;
                                  });
                                },
                                child: BlocConsumer<CurrentChatroomBloc,
                                    CurrentChatroomState>(
                                  listener: (context, state) {
                                    if (state.status ==
                                        AsyncLoadingStatus.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(state.error.message),
                                        ),
                                      );
                                    }

                                    // Enable message bar once done initializing.
                                    if (state.status ==
                                        AsyncLoadingStatus.done) {
                                      setState(() {
                                        _doneInitChatroom = true;

                                        _inquirerProfile = state.userProfile;
                                      });
                                    }
                                  },
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Dismiss inquiry detail pannel.
                                        if (!_animationController.isDismissed) {
                                          _animationController.reverse();
                                        }

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
                                        builder:
                                            (BuildContext context, message) {
                                          // Render different chat bubble based on message type.
                                          if (message
                                              is ServiceConfirmedMessage) {
                                            return ConfirmedServiceBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          } else if (message
                                              is UpdateInquiryMessage) {
                                            return UpdateInquiryBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                              onTapMessage: (message) {
                                                // Slideup inquiry pannel.
                                                _animationController.forward();
                                              },
                                            );
                                          } else if (message
                                              is DisagreeInquiryMessage) {
                                            return DisagreeInquiryBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          } else if (message
                                              is QuitChatroomMessage) {
                                            return QuitChatroomBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          } else if (message
                                              is PaymentCompletedMessage) {
                                            return PaymentCompletedBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          } else if (message is ImageMessage) {
                                            return ImageBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                              onEnlarge: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) {
                                                      return FullScreenImage(
                                                        imageUrl: message
                                                            .imageUrls[0],
                                                        tag: "chat_image",
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            return ChatBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // When we receive service confirmed message, we will
                              // display this top notification banner.
                              _serviceConfirmed
                                  ? NotificationBanner(
                                      avatarUrl: _inquirerProfile.avatarUrl,
                                    )
                                  : Container(),
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
            ),

            // Listen the loading status of `GetInquiryBloc`. If status is loading,
            // display spinner on service settings sheet.
            SlideTransition(
              position: _offsetAnimation,
              child: MultiBlocListener(
                listeners: [
                  BlocListener<GetInquiryBloc, GetInquiryState>(
                    listener: (_, state) {
                      if (state.status == AsyncLoadingStatus.done) {
                        setState(() {
                          _serviceSettings = state.serviceSettings;
                        });
                      }
                    },
                  ),
                  BlocListener<UpdateInquiryBloc, UpdateInquiryState>(
                      listener: (_, state) {
                    if (state.status == AsyncLoadingStatus.done) {
                      _animationController.reverse();
                    }
                  }),
                ],
                child: ServiceSettingsSheet(
                  serviceSettings: _serviceSettings,
                  controller: _slideUpController,
                  onTapClose: () {
                    _animationController.reverse();
                  },
                  onUpdateInquiry: (ServiceSettings data) {
                    setState(() {
                      _serviceSettings = data;
                    });

                    /// Send inquiry settings message when done editing inquiry.
                    BlocProvider.of<SendMessageBloc>(context).add(
                      SendUpdateInquiryMessage(
                        channelUUID: widget.args.channelUUID,
                        serviceSettings: data,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Upload image bloc
            BlocListener<UploadImageMessageBloc, UploadImageMessageState>(
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
                      imageUrl: chatImages[0].imageUrl,
                      channelUUID: widget.args.channelUUID,
                    ),
                  );
                }
              },
              child: SizedBox.shrink(),
            ),

            // Send image bloc
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
        ),
      ),
    );
  }

  _handleTapEditInquiry() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
