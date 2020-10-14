part of 'inquirer_profile.dart';

class InquirerProfileServices extends StatelessWidget {
  const InquirerProfileServices({
    this.services,
  });

  final List<HistoricalService> services;

  @override
  Widget build(BuildContext context) {
    return services.length == 0
        ? _buildEmptyServicesList()
        : _buildServicesList(services);
  }

  Widget _buildEmptyServicesList() {
    return Container(
      child: Center(
        child: Text('not services'),
      ),
    );
  }

  Widget _buildServicesList(List<HistoricalService> services) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 4, 4, 4),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: services.length,
          itemBuilder: (BuildContext context, int idx) =>
              _buildServiceItem(services[idx]),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(HistoricalService service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 2.0,
            color: Colors.orange.shade400,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.favorite),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                          '${service.createdAt.year}-${service.createdAt.month}-${service.createdAt.day}',
                          style: TextStyle(
                            fontSize: 10.0,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
