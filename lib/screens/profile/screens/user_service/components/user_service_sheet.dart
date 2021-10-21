import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_provider.dart';

part 'price_field.dart';
part 'service_name_field.dart';

class UserSericeSheet extends StatefulWidget {
  const UserSericeSheet({
    Key key,
    this.controller,
    this.onTapClose,
    this.isLoading = false,
  }) : super(key: key);

  final SlideUpController controller;
  final VoidCallback onTapClose;
  final bool isLoading;

  @override
  _UserSericeSheetState createState() => _UserSericeSheetState();
}

class _UserSericeSheetState extends State<UserSericeSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SlideUpProvider(),
      child: Consumer<SlideUpProvider>(
        builder: (context, provider, child) {
          widget.controller?.providerContext = context;
          return provider.isShow
              ? SingleChildScrollView(
                  child: Container(
                    height: SizeConfig.screenHeight * 0.5,
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
                        '新增服務',
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
                  Column(
                    children: <Widget>[
                      ServiceNameField(
                        controller: _nameController,
                        validator: (String v) {
                          return v.isEmpty ? 'Service can not be empty' : null;
                        },
                        onSaved: (String v) {
                          //   _serviceSetting = _serviceSetting.copyWith(
                          //     price: double.tryParse(v),
                          //   );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      PriceField(
                        controller: _priceController,
                        validator: (String v) {
                          return v.isEmpty || v == '0'
                              ? 'Price can not be empty'
                              : null;
                        },
                        onSaved: (String v) {
                          //   _serviceSetting = _serviceSetting.copyWith(
                          //     price: double.tryParse(v),
                          //   );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DPTextButton(
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            // widget.onUpdateInquiry(_serviceSetting);
                          },
                          text: '新增服務',
                          theme: DPTextButtonThemes.purple,
                          disabled: widget.isLoading,
                          loading: widget.isLoading,
                        ),
                      ],
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
