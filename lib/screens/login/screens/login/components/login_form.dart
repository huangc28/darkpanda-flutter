part of '../login.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key key,
    this.formKey,
    this.loading = false,
    @required this.onLogin,
  }) : super(key: key);

  final ValueChanged<String> onLogin;

  final GlobalKey<FormState> formKey;

  final bool loading;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  String _asyncUsernameErrStr = '';

  @override
  void initState() {
    if (widget.formKey != null) {
      _formKey = widget.formKey;
    }

    super.initState();
  }

  void _submit() {
    setState(() {
      _asyncUsernameErrStr = '';
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    widget.onLogin(_username);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _textLabel('你的電郵'),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          _emailTextFormField(),
          _textLabel('你的密碼'),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          _passwordTextFormField(),
          _buttonLogin()
        ],
      ),
    );
  }

  Widget _passwordTextFormField() {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.13,
      child: BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            setState(() {
              _asyncUsernameErrStr = state.error.message;
            });

            _formKey.currentState.validate();
          }
        },
        child: DPTextFormField(
          validator: (String v) {
            // Username can not be empty
            if (v.trim().isEmpty) {
              return 'username is required';
            }

            if (_asyncUsernameErrStr != null &&
                _asyncUsernameErrStr.isNotEmpty) {
              return _asyncUsernameErrStr;
            }

            return null;
          },
          onSaved: (String v) {
            _username = v;
          },
          hintText: '請輸入密碼',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(203, 205, 214, 1),
          ),
          theme: DPTextFieldThemes.white,
          contentPadding: EdgeInsets.only(
            left: SizeConfig.screenHeight * 0.03, //14.0,
            bottom: SizeConfig.screenHeight * 0.01,
            top: SizeConfig.screenHeight * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _emailTextFormField() {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.13,
      child: BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            setState(() {
              _asyncUsernameErrStr = state.error.message;
            });

            _formKey.currentState.validate();
          }
        },
        child: DPTextFormField(
          validator: (String v) {
            // Username can not be empty
            if (v.trim().isEmpty) {
              return 'username is required';
            }

            if (_asyncUsernameErrStr != null &&
                _asyncUsernameErrStr.isNotEmpty) {
              return _asyncUsernameErrStr;
            }

            return null;
          },
          onSaved: (String v) {
            _username = v;
          },
          hintText: '請輸入電郵',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(203, 205, 214, 1),
          ),
          theme: DPTextFieldThemes.white,
          contentPadding: EdgeInsets.only(
            left: SizeConfig.screenHeight * 0.03, //14.0,
            bottom: SizeConfig.screenHeight * 0.01,
            top: SizeConfig.screenHeight * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.065,
      child: DPTextButton(
        loading: widget.loading,
        text: AppLocalizations.of(context).login,
        onPressed: _submit,
      ),
    );
  }

  Widget _textLabel(String value) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        wordSpacing: 0.5,
      ),
    );
  }
}
