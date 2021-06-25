import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import './bloc/load_incoming_service_bloc.dart';
import 'bloc/load_historical_service_bloc.dart';
import './models/incoming_service.dart';
import 'models/historical_service.dart';
import 'components/body.dart';

enum ServiceListTabs {
  incoming,
  historical,
}

class ServiceList extends StatefulWidget {
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

  List<IncomingService> _incomingServices = [];

  AsyncLoadingStatus _incomingServicesStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
    );

    BlocProvider.of<LoadIncomingServiceBloc>(context)
        .add(LoadIncomingService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.done) {
            setState(() {
              _incomingServices = state.services;
            });
          }

          setState(() {
            _incomingServicesStatus = state.status;
          });
        },
        child: Body(
          incomingServices: _incomingServices,
          incomingServicesStatus: _incomingServicesStatus,
          tabController: _tabController,
        ),
      ),
    );
  }
}
