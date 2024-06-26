import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/block_user_bloc.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'history_card.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_payment_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_rate_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/services/service_chatroom_api.dart';
import '../models/historical_service.dart';
import '../screens/historical_service_detail/historical_service_detail.dart';

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
          child: Container(
            height: SizeConfig.screenHeight,
            child: ListView.separated(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: historicalService.length,
              itemBuilder: (BuildContext context, int idx) => Container(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
                child: HistoryCard(
                  historicalService: historicalService[idx],
                  press: () async {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => LoadPaymentDetailBloc(
                                apiClient: ServiceChatroomClient(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => LoadRateDetailBloc(
                                apiClient: ServiceChatroomClient(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => BlockUserBloc(
                                apiClient: ServiceChatroomClient(),
                              ),
                            ),
                          ],
                          child: HistoricalServiceDetail(
                              historicalService: historicalService[idx]),
                        );
                      },
                    ));
                  },
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
