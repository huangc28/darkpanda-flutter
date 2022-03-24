import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/load_incoming_service_bloc.dart';
import 'bloc/load_historical_service_bloc.dart';
import 'components/service_list_window.dart';

enum ServiceListTabs {
  incoming,
  historical,
}

class ServiceList extends StatefulWidget {
  // Provide a route name to onPush to redirects user to other routes of [ServiceChatroomRoutes] screen.
  final Function(String) onPush;

  const ServiceList({this.onPush});

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static const _tabs = [
    ServiceListTabs.incoming,
    ServiceListTabs.historical,
  ];

  LoadIncomingServiceBloc _loadIncomingServiceBloc;

  @override
  void initState() {
    super.initState();

    _loadIncomingServiceBloc =
        BlocProvider.of<LoadIncomingServiceBloc>(context);

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _loadIncomingServiceBloc.add(ClearIncomingServiceState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: TabBar(
          onTap: (index) {
            if (_tabs[index] == ServiceListTabs.incoming) {
              BlocProvider.of<LoadIncomingServiceBloc>(context)
                  .add(LoadIncomingService());
            }

            if (_tabs[index] == ServiceListTabs.historical) {
              BlocProvider.of<LoadHistoricalServiceBloc>(context)
                  .add(LoadHistoricalService());
            }
          },
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
      body: ServiceListWindow(
        tabController: _tabController,
      ),
    );
  }
}
