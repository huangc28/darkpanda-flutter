part of './inquirer_profile.dart';

class InquirerProfileTabs extends StatefulWidget {
  InquirerProfileTabs();

  @override
  InquirerProfileTabsState createState() => InquirerProfileTabsState();
}

class InquirerProfileTabsState extends State<InquirerProfileTabs>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> profileTabs = [
    Tab(
      icon: Icon(
        Icons.image,
        color: Colors.white,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.payment,
        color: Colors.white,
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: profileTabs.length,
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG parent size ${MediaQuery.of(context).size.height}');

    var sampleList = new List<int>.generate(100, (i) => i + 1);

    return SizedBox(
      child: Column(
        children: [
          Material(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              tabs: profileTabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: ListView.builder(
                    itemCount: sampleList.length,
                    itemBuilder: (BuildContext context, idx) {
                      return Text('${sampleList[idx]} item');
                    },
                  ),
                ),
                Container(
                  child: Text('spot 2'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
