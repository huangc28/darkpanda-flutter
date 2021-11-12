import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_model.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_provider.dart';

import 'service_duration_field.dart';

part 'price_field.dart';
part 'service_name_field.dart';

class UserServiceSheet extends StatefulWidget {
  const UserServiceSheet({
    Key key,
    this.controller,
    this.onTapClose,
    this.isLoading = AsyncLoadingStatus.initial,
    this.onCreateUserService,
    this.userServiceList,
  }) : super(key: key);

  final SlideUpController controller;
  final VoidCallback onTapClose;
  final AsyncLoadingStatus isLoading;
  final List<UserServiceResponse> userServiceList;

  /// Triggered when user service is created.
  final Function(UserServiceModel) onCreateUserService;

  @override
  _UserServiceSheetState createState() => _UserServiceSheetState();
}

class _UserServiceSheetState extends State<UserServiceSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  UserServiceModel _userServiceModel = UserServiceModel();

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _priceController.dispose();
    _nameController.dispose();
    _durationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading == AsyncLoadingStatus.done) {
      _priceController.clear();
      _nameController.clear();
      _durationController.clear();
    }

    return ChangeNotifierProvider(
      create: (_) => SlideUpProvider(),
      child: Consumer<SlideUpProvider>(
        builder: (context, provider, child) {
          widget.controller?.providerContext = context;
          return provider.isShow
              ? SingleChildScrollView(
                  child: Container(
                    height: SizeConfig.screenHeight * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: _userServiceForm(),
                  ),
                )
              : Container();
        },
      ),
    );
  }

  Widget _userServiceForm() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 12,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '編輯服務',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 50, 53, 1),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onTapClose();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.cancel_outlined),
                        iconSize: 22,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ServiceNameField(
                                controller: _nameController,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return '請輸入服務名稱';
                                  }

                                  bool isDuplicateService = false;

                                  // Check is duplicate service exist
                                  widget.userServiceList.forEach((u) {
                                    if (value.trim() == u.serviceName) {
                                      print("duplicate ${u.serviceName}");
                                      isDuplicateService = true;
                                    }
                                  });

                                  if (isDuplicateService) {
                                    return '服務名稱已存在';
                                  }

                                  return null;
                                },
                                onSaved: (String value) {
                                  _userServiceModel =
                                      _userServiceModel.copyWith(
                                    serviceName: value,
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              PriceField(
                                controller: _priceController,
                                validator: (String v) {
                                  return v.isEmpty || v == '0' ? '請輸入價格' : null;
                                },
                                onSaved: (String value) {
                                  _userServiceModel =
                                      _userServiceModel.copyWith(
                                    price: double.tryParse(value),
                                  );
                                },
                              ),
                            ],
                          ),
                          ServiceDurationField(
                            controller: _durationController,
                            validator: (String v) {
                              if (v == null || v.isEmpty) {
                                return '請輸入服務時長';
                              }

                              final doubleDuration = double.tryParse(v);

                              if (doubleDuration < 30.0) {
                                return '服務時長最少 30 分鐘';
                              }

                              // Check if user input contains decimal fraction.
                              final fraction =
                                  doubleDuration - doubleDuration.truncate();

                              if (fraction > 0) {
                                return '服務時長必須為整數';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              // Convert duration value to Duration instance.
                              setState(
                                () {
                                  _userServiceModel =
                                      _userServiceModel.copyWith(
                                    duration: int.tryParse(value),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DPTextButton(
                                onPressed: () {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  _formKey.currentState.save();

                                  widget.onCreateUserService(_userServiceModel);
                                },
                                text: '新增服務',
                                theme: DPTextButtonThemes.purple,
                                disabled: widget.isLoading ==
                                    AsyncLoadingStatus.loading,
                                loading: widget.isLoading ==
                                    AsyncLoadingStatus.loading,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
