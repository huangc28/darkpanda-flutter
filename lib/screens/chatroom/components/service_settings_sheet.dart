import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_duration_picker/flutter_duration_picker.dart';

import './slideup_controller.dart';
import './slideup_provider.dart';

import '../../../models/service_settings.dart';

part 'service_setting_field.dart';

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

  @override
  void initState() {
    super.initState();

    // Initialze service settings.
    _initDefaultServiceSettings();
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

  Widget _headingRow(BuildContext context) {
    return Row(
      children: [
        Text(
          'Service Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Spacer(),
        GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
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
              ? Container(
                  height: 571,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container();
        },
      ),
    );
  }

  Widget _buildSaveButton() => OutlineButton(
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();

          Navigator.of(context).pop(_serviceSetting);
        },
      );

  Widget _buildCancelButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[300],
        ),
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

  Widget _buildDurationPicker() {
    return ServiceSettingField(
      serviceLabel: Text('Select a service duration'),
      builder: (BuildContext context) => TextFormField(
        validator: (String v) {
          if (_serviceSetting.duration == null ||
              _serviceSetting.duration.inSeconds == 0) {
            return 'service duration can\'t be zero';
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        enabled: false,
        style: TextStyle(fontSize: 26),
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        controller: _durationController,
      ),
      onTap: () async {
        // Duration pickedDuration = await showDurationPicker(
        //   context: context,
        //   initialTime: _serviceSetting.duration,
        // );

        // if (pickedDuration != null) {
        //   _serviceSetting.duration = pickedDuration;
        //   _durationController.text = _formatDuration(_serviceSetting.duration);
        // }
      },
    );
  }

  Widget _buildServiceTimePicker() {
    return ServiceSettingField(
      serviceLabel: Text('Pick a time for this service'),
      onTap: () {
        _selectTime(context);
      },
      builder: (BuildContext context) => TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        enabled: false,
        style: TextStyle(fontSize: 26),
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        controller: _timeController,
      ),
    );
  }

  Widget _buildPriceField() {
    return ServiceSettingField(
      serviceLabel: Text('What is the price for this service'),
      builder: (BuildContext context) => TextFormField(
        controller: _priceController,
        onSaved: (String v) {
          _serviceSetting.price = double.tryParse(v);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          hintText: 'price',
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (String v) {
          if (v.isEmpty || v == '0') {
            return 'Price can not be empty';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildServiceDatePicker() {
    return ServiceSettingField(
      serviceLabel: Text('Pick a date for this service'),
      builder: (BuildContext context) => TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        controller: _dateController,
        validator: (String v) {
          if (v.isEmpty) {
            return 'Service date can not be empty';
          }

          return null;
        },
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _serviceSetting.serviceDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(now.day + 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _serviceSetting.serviceDate = picked;
        _dateController.text =
            DateFormat.yMd().format(_serviceSetting.serviceDate);
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _serviceSetting.serviceTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (picked != null) {
      _serviceSetting.serviceTime = picked;
      setState(() {
        _timeController.text = formatDate(
          DateTime(
            _serviceSetting.serviceDate.year,
            _serviceSetting.serviceDate.month,
            _serviceSetting.serviceDate.day,
            _serviceSetting.serviceTime.hour,
            _serviceSetting.serviceTime.minute,
          ),
          [hh, ':', nn, " ", am],
        ).toString();
      });
    }
  }
}
