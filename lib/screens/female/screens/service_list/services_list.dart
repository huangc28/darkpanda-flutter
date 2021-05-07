import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/layouts/system_ui_overlay_layout.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  TabController _tapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SystemUiOverlayLayout(
        child: SafeArea(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
