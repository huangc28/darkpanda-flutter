import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/send_rate_bloc.dart';
import './services/rating_api_client.dart';
import 'components/body.dart';

class Rate extends StatefulWidget {
  const Rate({
    Key key,
    this.chatPartnerAvatarURL,
    this.chatPartnerUsername,
    this.serviceUUID,
  }) : super(key: key);

  final String chatPartnerAvatarURL;
  final String chatPartnerUsername;
  final String serviceUUID;

  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> with SingleTickerProviderStateMixin {
  bool complete = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 16, 41, 1),
          title: Text('評價'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            complete == false
                ? new IconButton(
                    icon: new Icon(Icons.close),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => Navigator.of(context).pop(null),
                  )
                : Container(),
            SizedBox(width: 20),
          ],
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1), //change your color here
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (contxt) => SendRateBloc(
                apiClient: RatingAPIClient(),
              ),
            ),
          ],
          child: Body(
            formKey: _formKey,
            chatPartnerAvatarURL: widget.chatPartnerAvatarURL,
            chatPartnerUsername: widget.chatPartnerUsername,
            serviceUUID: widget.serviceUUID,
          ),
        ));
  }
}
