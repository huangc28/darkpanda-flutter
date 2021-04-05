part of '../inquirer_profile.dart';

class InquirerProfileTabs extends StatefulWidget {
  InquirerProfileTabs({
    this.onTab,
    this.tabKeys,
    this.tabController,
  });

  final ValueChanged<ValueKey> onTab;
  final List<ValueKey> tabKeys;
  final TabController tabController;

  @override
  InquirerProfileTabsState createState() => InquirerProfileTabsState();
}

class InquirerProfileTabsState extends State<InquirerProfileTabs>
    with SingleTickerProviderStateMixin {
  List<Tab> profileTabs = [
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
    widget.onTab(widget.tabKeys[0]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Material(
            color: Colors.black,
            child: TabBar(
              onTap: (int value) {
                // load tab data
                widget.onTab(widget.tabKeys[value]);
              },
              controller: widget.tabController,
              tabs: profileTabs,
            ),
          ),
        ],
      ),
    );
  }
}
