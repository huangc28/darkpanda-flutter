import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/add_user_service_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/load_user_service_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/user_service_api_client.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/models/service_details.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/address_selector/address_selector.dart';

import 'female_service_type_field.dart';
import 'slideup_controller.dart';
import 'slideup_provider.dart';
import 'user_service_selector/user_service_selector_list.dart';

import 'components/price_field.dart';
import 'components/address_field.dart';
import 'components/appointment_time_field.dart';
import 'components/service_duration_field.dart';

// @reference: https://stackoverflow.com/questions/51908187/how-to-make-a-full-screen-dialog-in-flutter
class ServiceSettingsSheet extends StatefulWidget {
  const ServiceSettingsSheet({
    this.serviceSettings,
    this.serviceDetails,
    this.controller,
    @required this.onTapClose,
    @required this.onUpdateInquiry,
    this.isLoading,
  });

  final ServiceSettings serviceSettings;
  final ServiceDetails serviceDetails;
  final SlideUpController controller;
  final VoidCallback onTapClose;
  final bool isLoading;

  /// Triggered when inquiry is updated.
  final Function(ServiceSettings) onUpdateInquiry;
  // final Function(ServiceDetails) onUpdateInquiry;

  @override
  _ServiceSettingsSheetState createState() => _ServiceSettingsSheetState();
}

class _ServiceSettingsSheetState extends State<ServiceSettingsSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Switch to determin whether to disable the update button or not.
  bool _disableUpdate = false;

  ServiceSettings _serviceSetting = ServiceSettings(
    serviceDate: DateTime.now(),
    serviceTime: TimeOfDay(hour: 00, minute: 00),
    duration: Duration(hours: 0, minutes: 30),
  );

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _serviceTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initDefaultServiceSettings(widget.serviceSettings);
  }

  @override
  void didUpdateWidget(ServiceSettingsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If previous [ServiceSettings] instance is different from
    // the current one , we replace the service setting sheet
    // with the newest one.
    if (widget.serviceSettings != oldWidget.serviceSettings) {
      _initDefaultServiceSettings(widget.serviceSettings);
    }
  }

  _navigateToAddressSelector() async {
    FocusScope.of(context).requestFocus(FocusNode());

    // Push to address selector screen.
    final addr = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddressSelector(
            initialAddress: _addressController.text,
          );
        },
      ),
    );

    setState(() {
      _addressController.text = addr;

      _serviceSetting = _serviceSetting.copyWith(address: addr);
    });
  }

  _navigateToServiceSelector() async {
    FocusScope.of(context).requestFocus(FocusNode());

    // Push to address selector screen.
    final serviceType = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadUserServiceBloc(
                  userServiceApiClient: UserServiceApiClient(),
                ),
              ),
              BlocProvider(
                create: (context) => AddUserServiceBloc(
                  userServiceApiClient: UserServiceApiClient(),
                ),
              ),
            ],
            child: UserServiceSelectorList(
              initialUserService: _serviceTypeController.text,
            ),
          );
        },
      ),
    );

    setState(() {
      _serviceTypeController.text = serviceType;

      _serviceSetting = _serviceSetting.copyWith(serviceType: serviceType);
    });
  }

  _initDefaultServiceSettings(ServiceSettings serviceSettings) {
    if (serviceSettings == null) return;

    _serviceSetting = serviceSettings;

    // Initialize service date.
    _dateController.text = _formatDate(_serviceSetting.serviceDate);

    // Initialize service time.
    _timeController.text = _formatTime(
      serviceSettings.serviceTime,
    );

    // Initialize service duration.
    _durationController.text = _serviceSetting.duration.inMinutes.toString();

    // Initialize price. If price is not yet set, use budget as the initial price.
    _priceController.text = _serviceSetting.price == null
        ? '${_serviceSetting.budget}'
        : '${_serviceSetting.price}';

    // Initialize service type.
    _serviceSetting = _serviceSetting.copyWith(
      serviceType: _serviceSetting.serviceType,
    );
    _serviceTypeController.text = _serviceSetting.serviceType;

    // Initialize service address
    _addressController.text = _serviceSetting.address;

    setState(() {});
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat.yMd().format(_serviceSetting.serviceDate);

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();

    return formatDate(
      DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
        0,
      ),
      [hh, ':', nn, " ", am],
    ).toString();
  }

  Widget _buildServiceSettingsForm() {
    return Form(
      onChanged: () {
        setState(() {
          _disableUpdate = !_formKey.currentState.validate();
        });
      },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Build inquiry pannel title.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '發送邀請',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 50, 53, 1),
                        ),
                      ),

                      // Close edit inquiry panel.
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
                              // PriceField(
                              //   controller: _priceController,
                              //   validator: (String v) {
                              //     return v.isEmpty || v == '0' ? '請輸入價格' : null;
                              //   },
                              //   onSaved: (String v) {
                              //     _serviceSetting = _serviceSetting.copyWith(
                              //       price: double.tryParse(v),
                              //     );
                              //   },
                              // ),

                              GestureDetector(
                                onTap: _navigateToServiceSelector,
                                child: Container(
                                  color: Colors.transparent,
                                  child: IgnorePointer(
                                    child: FemaleServiceTypeField(
                                      controller: _serviceTypeController,
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return '請選擇服務';
                                        }
                                      },
                                      onSaved: (String v) {
                                        _serviceSetting =
                                            _serviceSetting.copyWith(
                                          price: double.tryParse(v),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Focus address field would open a map route letting the user to select an address from google map.
                              GestureDetector(
                                onTap: _navigateToAddressSelector,
                                child: Container(
                                  color: Colors.transparent,
                                  child: IgnorePointer(
                                    child: AddressField(
                                      controller: _addressController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '請選擇地址';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: AppointmentTimeField(
                                  dateController: _dateController,
                                  timeController: _timeController,
                                  onSelectDate: (DateTime dateTime) {
                                    // We need to update the appointment time of current service settings.
                                    setState(() {
                                      _serviceSetting =
                                          _serviceSetting.copyWith(
                                        serviceDate: dateTime,
                                      );

                                      // Format the date text to be aligned with the newly selected date.
                                      _dateController = TextEditingController()
                                        ..text = _formatDate(
                                            _serviceSetting.serviceDate);
                                    });
                                  },
                                  onSelectTime: (TimeOfDay time) {
                                    setState(() {
                                      _serviceSetting =
                                          _serviceSetting.copyWith(
                                        serviceTime: time,
                                      );

                                      _timeController = TextEditingController()
                                        ..text = _formatTime(time);
                                    });
                                  },
                                ),
                              ),

                              SizedBox(height: 20),

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
                                  final fraction = doubleDuration -
                                      doubleDuration.truncate();

                                  if (fraction > 0) {
                                    return '服務時長必須為整數';
                                  }

                                  return null;
                                },
                                onSaved: (String v) {
                                  // Convert duration value to Duration instance.
                                  setState(
                                    () {
                                      _serviceSetting =
                                          _serviceSetting.copyWith(
                                        duration: Duration(
                                          minutes: int.tryParse(v),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Emit inquiry.
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DPTextButton(
                                onPressed: () {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  _formKey.currentState.save();

                                  widget.onUpdateInquiry(_serviceSetting);
                                },
                                text: '發送邀請',
                                theme: DPTextButtonThemes.purple,
                                disabled: _disableUpdate || widget.isLoading,
                                loading: widget.isLoading,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // ),
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SlideUpProvider(),
      child: Consumer<SlideUpProvider>(
        builder: (context, provider, child) {
          widget.controller?.providerContext = context;
          return provider.isShow
              ? UnfocusPrimary(
                  child: SingleChildScrollView(
                    child: Container(
                      height: SizeConfig.screenHeight * 0.9, //571,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: _buildServiceSettingsForm(),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
