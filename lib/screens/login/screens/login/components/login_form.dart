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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 105,
            child:
                BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
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
                hintText: AppLocalizations.of(context).insertUsername,
                theme: DPTextFieldThemes.white,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: DPTextButton(
              loading: widget.loading,
              text: AppLocalizations.of(context).login,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '你的用戶名',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  wordSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          _buildForm(),
        ],
      ),
    );
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
}
