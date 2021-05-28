import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/load_incoming_service_bloc.dart';
import 'components/body.dart';

class ServiceChatroom extends StatefulWidget {
  @override
  _ServiceChatroomState createState() => _ServiceChatroomState();
}

class _ServiceChatroomState extends State<ServiceChatroom>
    with SingleTickerProviderStateMixin {
  LoadIncomingServiceBloc loadIncomingServiceBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    loadIncomingServiceBloc = BlocProvider.of<LoadIncomingServiceBloc>(context);

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 0.53,
          ),
          tabs: [
            Tab(text: '即將到來'),
            Tab(text: '歷史記錄'),
          ],
        ),
      ),
      body: Body(),
    );
  }
}
