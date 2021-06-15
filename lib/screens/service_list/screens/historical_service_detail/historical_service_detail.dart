import 'package:flutter/material.dart';

import '../../models/historical_service.dart';

import 'components/body.dart';

class HistoricalOrderDetail extends StatefulWidget {
  final HistoricalService historicalService;
  const HistoricalOrderDetail({
    Key key,
    @required this.historicalService,
  }) : super(key: key);

  @override
  _HistoricalOrderDetailState createState() => _HistoricalOrderDetailState();
}

class _HistoricalOrderDetailState extends State<HistoricalOrderDetail>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('交易'),
        centerTitle: true,
        actions: [
          Align(
            child: GestureDetector(
              onTap: () {
                print('幫助');
              },
              child: Text(
                '幫助',
                style: TextStyle(
                  color: Color.fromRGBO(106, 109, 137, 1),
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(historicalService: widget.historicalService),
    );
  }
}
