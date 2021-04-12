import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import './slideup_controller.dart';
import './slideup_provider.dart';

part 'price_field.dart';
part 'address_field.dart';
part 'appointment_time_field.dart';

// TODOs
//   - Add close button - [ok]
//   - Service type
//   - Add price field - [ok]
//   - Meet up date - [ok]
//   - Meet up time - [ok]
//   - Service duration - [ok]
//   - Location
//   - Time picker and Date picker fields have the same style - [ok]
//   - Save button - [ok]
//   - Cancel button - [ok]
//   - Replace the service settings with default values
//   - Add service type field
// @reference: https://medium.com/flutterdevs/date-and-time-picker-in-flutter-72141e7531c
// @reference: https://stackoverflow.com/questions/51908187/how-to-make-a-full-screen-dialog-in-flutter

class ServiceSettingsSheet extends StatefulWidget {
  const ServiceSettingsSheet({
    this.serviceSettings,
    this.controller,
    @required this.onTapClose,
  });

  final ServiceSettings serviceSettings;
  final SlideUpController controller;
  final VoidCallback onTapClose;

  @override
  _ServiceSettingsSheetState createState() => _ServiceSettingsSheetState();
}

class _ServiceSettingsSheetState extends State<ServiceSettingsSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ServiceSettings _serviceSetting = ServiceSettings(
    serviceDate: DateTime.now(),
    serviceTime: TimeOfDay(hour: 00, minute: 00),
    duration: Duration(hours: 0, minutes: 30),
  );

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  FocusNode _addressFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _addressFieldFocusNode.addListener(_navigateToAddressSelector);

    // Initialze service settings.
    _initDefaultServiceSettings();
  }

  @override
  void dispose() {
    super.dispose();

    _addressFieldFocusNode?.dispose();
  }

  _navigateToAddressSelector() async {
    if (_addressFieldFocusNode.hasPrimaryFocus) {
      // Push to address selector screen.
      final addr = await Navigator.push(
          context, MaterialPageRoute(builder: (context) {}));

      print('DEBUG addr object ${addr}');
    }
  }

  _initDefaultServiceSettings() {
    if (widget.serviceSettings == null) return;

    _serviceSetting = widget.serviceSettings;
    _dateController.text = DateFormat.yMd().format(_serviceSetting.serviceDate);
    _timeController.text = formatDate(
      DateTime(
        _serviceSetting.serviceDate.year,
        _serviceSetting.serviceDate.month,
        _serviceSetting.serviceDate.day,
        _serviceSetting.serviceDate.hour,
        _serviceSetting.serviceDate.minute,
        0,
      ),
      [hh, ':', nn, " ", am],
    ).toString();
    _durationController.text = _formatDuration(_serviceSetting.duration);

    _priceController.text =
        _serviceSetting.price != null ? '${_serviceSetting.price}' : null;

    _serviceSetting.serviceType = _serviceSetting.serviceType;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}";
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
                    child: Form(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          _serviceSetting.price =
                                              double.tryParse(v);
                                        },
                                      ),
                                      SizedBox(height: 25),
                                      // Focus address field would open a map route letting the user to select an address from google map.
                                      AddressField(
                                        focusNode: _addressFieldFocusNode,
                                      ),
                                      SizedBox(height: 25),
                                      AppointmentTimeField(),
                                      SizedBox(height: 25),
                                      Column(
                                        children: [
                                          Bullet(
                                            '服務期限',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  // Emit inquiry.
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        DPTextButton(
                                          onPressed: () {
                                            print('DEBUG trigger emit inquiry');
                                          },
                                          text: '發送邀請',
                                          theme: DPTextButtonThemes.purple,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
