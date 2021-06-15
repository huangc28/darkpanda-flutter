import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TypeSelection {
  String name;
  bool select;

  TypeSelection({
    this.name,
    this.select,
  });
}

class Body extends StatefulWidget {
  final Function onPressComplete;
  final GlobalKey<FormState> formKey;
  const Body({this.formKey, this.onPressComplete});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _disableSend = true;
  double _rateInput = 0;
  String _commentInput;
  List<TypeSelection> _typeSelection = [];

  @override
  void initState() {
    if (widget.formKey != null) {
      _formKey = widget.formKey;
    }
    _typeSelection.add(new TypeSelection(name: '又正又辣', select: false));
    _typeSelection.add(new TypeSelection(name: '技術高超', select: false));
    _typeSelection.add(new TypeSelection(name: '交易愉快', select: false));
    _typeSelection.add(new TypeSelection(name: '好相處', select: false));
    _typeSelection.add(new TypeSelection(name: '很準時', select: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(31, 30, 56, 1),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserAvatar(
                          'https://www.w3schools.com/howto/img_avatar.png'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: Text(
                        'Jenny',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            _buildRateDetail(),
            SizedBox(height: 20),
            _buildRateForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildRateDetail() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '你覺得Fei的服務怎麼樣？',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '他們會收到您的反饋，以及您的姓名和照片',
            style: TextStyle(
              color: Color.fromRGBO(106, 109, 137, 1),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateForm() {
    return Form(
      onChanged: () {
        setState(() {
          _disableSend = !_formKey.currentState.validate();
        });
      },
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bulidRateInput(),
          if (_rateInput > 0)
            Column(
              children: [
                SizedBox(height: 20),
                _buildSelectionInput(),
                SizedBox(height: 20),
                _buildCommentTextField(),
                SizedBox(height: 20),
              ],
            ),
          _buildSendButton(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 4,
            left: 20,
            right: 20,
          ),
          child: DPTextButton(
            disabled: _disableSend,
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();
              print('送出評價');
              widget.onPressComplete();
            },
            text: '送出評價',
            theme: DPTextButtonThemes.purple,
          ),
        ),
      ],
    );
  }

  Widget _bulidRateInput() {
    return RatingBar(
      initialRating: _rateInput,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 38,
      ratingWidget: RatingWidget(
        full: Image.asset(
          'lib/screens/service_list/assets/rateBig.png',
        ),
        half: Image.asset(
          'lib/screens/service_list/assets/rateBig.png',
        ),
        empty: Image.asset(
          'lib/screens/service_list/assets/unrateBig.png',
        ),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 7),
      onRatingUpdate: (rating) {
        print(rating);
        setState(() {
          _rateInput = rating;
          if (_rateInput <= 0) {
            _disableSend = true;
          } else if (_rateInput > 0 && _rateInput <= 5) {
            _disableSend = false;
          }
        });
      },
    );
  }

  Widget _buildSelectionInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                ..._typeSelection.map((element) {
                  int index = _typeSelection.indexOf(element);
                  return Container(
                    padding: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: element.select == true
                            ? Colors.white
                            : Colors.transparent, // background
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Color.fromRGBO(106, 109, 137, 1),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _typeSelection[index].select =
                              _typeSelection[index].select == true
                                  ? false
                                  : true;
                        });
                      },
                      child: Text(
                        element.name,
                        style: TextStyle(
                          color: element.select == true
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTextField() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextFormField(
            validator: (String v) {
              return null;
            },
            onSaved: (String v) {
              _commentInput = v;
            },
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "請輸入你的評語 (非必填)",
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(106, 109, 137, 1), width: 0.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(106, 109, 137, 1), width: 0.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 12.0),
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 0.1),
            ),
          ),
        ),
      ],
    );
  }
}
