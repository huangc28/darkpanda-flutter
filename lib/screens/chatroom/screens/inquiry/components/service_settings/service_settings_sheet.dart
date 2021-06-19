import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/update_inquiry_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/address_selector/address_selector.dart';
// import 'package:darkpanda_flutter/bloc/update_inquiry_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'slideup_controller.dart';
import 'slideup_provider.dart';

part 'price_field.dart';
part 'address_field.dart';
part 'appointment_time_field.dart';
part 'service_duration_field.dart';

// @reference: https://stackoverflow.com/questions/51908187/how-to-make-a-full-screen-dialog-in-flutter
class ServiceSettingsSheet extends StatefulWidget {
  const ServiceSettingsSheet({
    this.serviceSettings,
    this.controller,
    @required this.onTapClose,
    @required this.onUpdateInquiry,
  });

  final ServiceSettings serviceSettings;
  final SlideUpController controller;
  final VoidCallback onTapClose;

  /// Triggered when inquiry is updated.
  final Function(ServiceSettings) onUpdateInquiry;

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
      _serviceSetting.address = addr;

      // _serviceSetting = _serviceSetting.copyWith(address: addr);
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
    _serviceSetting.serviceType = _serviceSetting.serviceType;

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
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Build inquiry pannel title.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                        icon: Icon(Icons.cancel_outlined),
                        iconSize: 22,
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      PriceField(
                        controller: _priceController,
                        validator: (String v) {
                          return v.isEmpty || v == '0'
                              ? 'Price can not be empty'
                              : null;
                        },
                        onSaved: (String v) {
                          _serviceSetting.price = double.tryParse(v);
                        },
                      ),
                      SizedBox(height: 10),
                      // Focus address field would open a map route letting the user to select an address from google map.
                      GestureDetector(
                        onTap: _navigateToAddressSelector,
                        child: Container(
                          color: Colors.transparent,
                          child: IgnorePointer(
                            child: AddressField(
                              controller: _addressController,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        child: AppointmentTimeField(
                          dateController: _dateController,
                          timeController: _timeController,
                          onSelectDate: (DateTime dateTime) {
                            // We need to update the appointment time of current service settings.
                            setState(() {
                              _serviceSetting.serviceDate = dateTime;

                              // Format the date text to be aligned with the newly selected date.
                              _dateController = TextEditingController()
                                ..text =
                                    _formatDate(_serviceSetting.serviceDate);
                            });
                          },
                          onSelectTime: (TimeOfDay time) {
                            setState(() {
                              _serviceSetting.serviceTime = time;
                              _timeController = TextEditingController()
                                ..text = _formatTime(time);
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 25),

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
                        onSaved: (String v) {
                          // Convert duration value to Duration instance.
                          setState(() {
                            _serviceSetting.duration =
                                Duration(minutes: int.tryParse(v));
                          });
                        },
                      ),
                    ],
                  ),

                  // Emit inquiry.
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocConsumer<UpdateInquiryBloc, UpdateInquiryState>(
                            listener: (context, state) {
                          if (state.status == AsyncLoadingStatus.done) {
                            setState(() {
                              _serviceSetting = state.serviceSettings;
                            });

                            widget.onUpdateInquiry(state.serviceSettings);
                          }
                        }, builder: (context, state) {
                          return DPTextButton(
                            loading: state.status == AsyncLoadingStatus.loading,
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }

                              _formKey.currentState.save();

                              BlocProvider.of<UpdateInquiryBloc>(context).add(
                                UpdateInquiry(
                                  serviceSettings: _serviceSetting,
                                ),
                              );
                            },
                            text: '發送邀請',
                            theme: DPTextButtonThemes.purple,
                            disabled: _disableUpdate,
                          );
                        }),
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
                    height: 571,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: _buildServiceSettingsForm(),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
