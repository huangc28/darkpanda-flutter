import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import './bloc/load_incoming_service_bloc.dart';
import './models/incoming_service.dart';
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
  List<IncomingService> _historicalServices = [];

  AsyncLoadingStatus _status = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

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
          onTap: (index) {
            if (_tabs[index] == ServiceListTabs.incoming) {
              BlocProvider.of<LoadIncomingServiceBloc>(context)
                  .add(LoadIncomingService());
            }

            if (_tabs[index] == ServiceListTabs.historical) {
              print('DEBUG load historical services');
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              setState(() {
                _incomingServices = state.services;
              });
            }

            setState(() {
              _status = state.status;
            });
          }),

          // BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
          //     listener: (context, state) {
          //   if (state.status == AsyncLoadingStatus.done) {
          //     setState(() {
          //       _incomingService = state.services;
          //     });
          //   }
          // }),
        ],
        child: Body(
          incomingServices: _incomingServices,
          historicalServices: _historicalServices,
          loadingStatus: _status,
          tabController: _tabController,
        ),
      ),
    );
  }
}
