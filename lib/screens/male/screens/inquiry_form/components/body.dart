import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/service_list.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'appointment_time_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List<String> lst = ["性", "逛街", "看電影", "吃飯", "聊天"];
  int selectedIndexServiceType = 0;
  int selectedIndexPeriod = 0;

  List<String> periodLst = ["一個小時", "一個半小時", "兩個小時", "兩個半小時"];

  TextEditingController _budgetController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _serviceTypeController = TextEditingController();
  TextEditingController _periodController = TextEditingController();

  List serviceTypeRadioWidget = <Widget>[];
  List periodRadioWidget = <Widget>[];

  LoadServiceListBloc loadServiceListBloc = new LoadServiceListBloc();
  ServiceList serviceList = new ServiceList();

  InquiryForms _inquiryForms = InquiryForms(
    inquiryDate: DateTime.now(),
    inquiryTime: TimeOfDay(hour: 00, minute: 00),
    duration: Duration(hours: 1, minutes: 0),
  );

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoadServiceListBloc>(context).add(LoadServiceList());

    _dateController.text = _formatDate(_inquiryForms.inquiryDate);
    _timeController.text = _formatTime(
      _inquiryForms.inquiryTime,
    );

    _periodController.text = '1';
    serviceList.serviceNames = [];
  }

  @override
  void dispose() {
    loadServiceListBloc.add(ClearServiceListState());

    super.dispose();
  }

  void initServiceTypeRadio(list) {
    serviceTypeRadioWidget.clear();
    for (int i = 0; i < list.length; i++) {
      serviceTypeRadioWidget.add(
        SizedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: _customServiceTypeRadio(list[i].name, i),
          ),
        ),
      );
    }
  }

  void initPeriodRadio() {
    periodRadioWidget.clear();
    for (int i = 0; i < periodLst.length; i++) {
      periodRadioWidget.add(
        SizedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: _customPeriodRadio(periodLst[i], i),
          ),
        ),
      );
    }
  }

  void changeIndexServiceType(int index) {
    setState(() {
      selectedIndexServiceType = index;
    });
  }

  void changeIndexPeriod(int index) {
    setState(() {
      selectedIndexPeriod = index;
    });
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat.yMd().format(_inquiryForms.inquiryDate);

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

  @override
  Widget build(BuildContext context) {
    final viewPortWidth = MediaQuery.of(context).size.width;
    final viewPortHeight = MediaQuery.of(context).size.height;
    initPeriodRadio();
    initServiceTypeRadio(serviceList.serviceNames);

    return SingleChildScrollView(
      child: BlocConsumer<SearchInquiryFormBloc, SearchInquiryFormState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          } else if (state.status == AsyncLoadingStatus.done) {
            Navigator.pushNamed(context, "/waiting-inquiry");
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (20.0 / 375.0) * viewPortWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: viewPortHeight * 0.05),
                    _budgetInput(),
                    SizedBox(height: viewPortHeight * 0.05),
                    _textLabel('服務類型'),
                    SizedBox(height: viewPortHeight * 0.02),
                    _serviceTypeRadio(),
                    SizedBox(height: viewPortHeight * 0.05),
                    _textLabel('見面時間'),
                    SizedBox(height: viewPortHeight * 0.02),
                    _appointmentTime(),
                    SizedBox(height: viewPortHeight * 0.05),
                    _textLabel('服務期限'),
                    SizedBox(height: viewPortHeight * 0.02),
                    _servicePeriodRadio(),
                    SizedBox(height: viewPortHeight * 0.015),
                    _confirmButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      height: 45,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(119, 81, 255, 1),
        elevation: 7,
        child: GestureDetector(
          onTap: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();
            BlocProvider.of<SearchInquiryFormBloc>(context).add(
              SubmitSearchInquiryForm(_inquiryForms),
            );
          },
          child: Center(
            child: Text(
              '提交需求',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appointmentTime() {
    return Container(
      child: AppointmentTimeField(
        dateController: _dateController,
        timeController: _timeController,
        onSelectDate: (DateTime dateTime) {
          setState(() {
            _inquiryForms.inquiryDate = dateTime;
            _dateController = TextEditingController()
              ..text = _formatDate(_inquiryForms.inquiryDate);
          });
        },
        onSelectTime: (TimeOfDay time) {
          setState(() {
            _inquiryForms.inquiryTime = time;
            _timeController = TextEditingController()..text = _formatTime(time);
          });
        },
      ),
    );
  }

  Widget _servicePeriodRadio() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: periodRadioWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceTypeRadio() {
    return BlocConsumer<LoadServiceListBloc, LoadServiceListState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            serviceList = state.serviceList;
            _serviceTypeController.text = serviceList.serviceNames[0].name;
            _inquiryForms.serviceType = _serviceTypeController.text;
          });
        }
      },
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          return Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: serviceTypeRadioWidget,
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _customServiceTypeRadio(String txt, int index) {
    return OutlinedButton(
      onPressed: () {
        changeIndexServiceType(index);
        _serviceTypeController.text = serviceList.serviceNames[index].name;
        _inquiryForms.serviceType = _serviceTypeController.text;
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
            selectedIndexServiceType == index ? Colors.white : Colors.black,
        side: BorderSide(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: Text(
        txt,
        style: TextStyle(
            color: selectedIndexServiceType == index
                ? Colors.black
                : Colors.white),
      ),
    );
  }

  Widget _customPeriodRadio(String txt, int index) {
    return OutlinedButton(
      onPressed: () {
        changeIndexPeriod(index);
        if (index == 0) {
          _periodController.text = "60";
        } else if (index == 1) {
          _periodController.text = "90";
        } else if (index == 2) {
          _periodController.text = "120";
        } else if (index == 3) {
          _periodController.text = "150";
        }
        _inquiryForms.duration =
            Duration(minutes: int.tryParse(_periodController.text));
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
            selectedIndexPeriod == index ? Colors.white : Colors.black,
        side: BorderSide(color: Color.fromRGBO(106, 109, 137, 1)),
      ),
      child: Text(
        txt,
        style: TextStyle(
            color: selectedIndexPeriod == index ? Colors.black : Colors.white),
      ),
    );
  }

  Widget _budgetInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        controller: _budgetController,
        validator: (String v) {
          return v.isEmpty || v == '0' ? 'Budget can not be empty' : null;
        },
        onSaved: (value) {
          _inquiryForms.budget = double.tryParse(value);
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          hintText: "請輸入您的預算",
          hintStyle: TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            borderSide: BorderSide.none,
          ),
          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
          filled: true,
        ),
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _textLabel(String value) {
    return Row(
      children: [
        Container(
          height: 7.0,
          width: 7.0,
          transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 5),
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
