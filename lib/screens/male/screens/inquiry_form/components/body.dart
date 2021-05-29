import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:flutter/material.dart';

part 'appointment_time_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> lst = ["性", "逛街", "看電影", "吃飯", "聊天"];
  int selectedIndex = 0;

  List<String> dateLst = ["12/28/20", "00:20 AM"];
  List<String> periodLst = ["一個小時", "一個半小時", "兩個小時", "兩個半小時"];

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  // ServiceSettings _serviceSetting = ServiceSettings(
  //   serviceDate: DateTime.now(),
  //   serviceTime: TimeOfDay(hour: 00, minute: 00),
  //   duration: Duration(hours: 0, minutes: 30),
  // );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: (20.0 / 375.0) * MediaQuery.of(context).size.width),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _searchInput(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _textLabel('服務類型'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _serviceTypeRadio(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _textLabel('見面時間'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _appointmentTime(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _textLabel('服務期限'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _servicePeriodRadio(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      height: 45,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        // shadowColor: Colors.greenAccent,
        color: Color.fromRGBO(119, 81, 255, 1),
        elevation: 7,
        child: GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, PendingRequestScreen.routeName);
            Navigator.pushNamed(context, "/waiting-inquiry");
          },
          child: Center(
            child: Text(
              '提交需求',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.33,
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
          // We need to update the appointment time of current service settings.
          setState(() {
            // _serviceSetting.serviceDate = dateTime;

            // Format the date text to be aligned with the newly selected date.
            // _dateController = TextEditingController()
            //   ..text = _formatDate(_serviceSetting.serviceDate);
          });
        },
        onSelectTime: (TimeOfDay time) {
          setState(() {
            // _serviceSetting.serviceTime = time;
            // _timeController = TextEditingController()..text = _formatTime(time);
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
              children: <Widget>[
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(periodLst[0], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(periodLst[1], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(periodLst[2], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(periodLst[3], 0),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceTypeRadio() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(lst[0], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(lst[1], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(lst[2], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(lst[3], 0),
                )),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: _customRadio(lst[4], 0),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customRadio(String txt, int index) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: Colors.white),
      ),
      child: Text(
        txt,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _searchInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "請輸入您的預算",
          hintStyle: TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
            fontSize: 18,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
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
          // padding: EdgeInsets.fromLTRB(0.0, 45, 0, 0),
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
