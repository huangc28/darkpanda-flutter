import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/historical_service.dart';
import '../screens/historical_service_detail/historical_service_detail.dart';
import 'history_card.dart';

class ServiceHistoricalList extends StatelessWidget {
  const ServiceHistoricalList({
    this.historicalService,
    this.onRefresh,
    this.onLoadMore,
  });

  final List<HistoricalService> historicalService;
  final Function onRefresh;
  final Function onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 26,
      ),
      child: LoadMoreScrollable(
        onLoadMore: onLoadMore,
        builder: (context, scrollController) => RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: historicalService.length,
            itemBuilder: (BuildContext context, int idx) => HistoryCard(
                historicalService: historicalService[idx],
                press: () async {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => HistoricalOrderDetail(
                            historicalService: historicalService[idx])),
                  );
                }),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
