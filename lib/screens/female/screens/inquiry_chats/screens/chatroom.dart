import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    this.channelUUID,
  });

  final String channelUUID;

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  @override
  void initState() {
    BlocProvider.of<CurrentChatroomBloc>(context).add(
      FetchHistoricalMessages(channelUUID: widget.channelUUID),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentChatroomBloc, CurrentChatroomState>(
        builder: (context, state) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.grey,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Text('hello world'),
              ),
            ),
          ],
        ),
      ));
    });
  }
}
