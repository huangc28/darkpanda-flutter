import 'package:flutter/material.dart';

enum TabItem {
  inquiries,
  inquiryChats,
  manage,
  settings,
  profile,
}

class TabItemAsset {
  const TabItemAsset({
    this.label,
    this.activeIcon,
    this.inactiveIcon,
  });

  final String label;
  final Image activeIcon;
  final Image inactiveIcon;
}

Map<TabItem, TabItemAsset> TabLabelMap = {
  TabItem.inquiries: TabItemAsset(
    label: '需求',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_inactive.png'),
    ),
  ),
  TabItem.inquiryChats: TabItemAsset(
    label: '聊天',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/chat_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/chat_inactive.png'),
    ),
  ),
  TabItem.manage: TabItemAsset(
    label: '管理',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_inactive.png'),
    ),
  ),
  TabItem.settings: TabItemAsset(
    label: '設定',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_inactive.png'),
    ),
  ),
  TabItem.profile: TabItemAsset(
    label: '我的',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/profile_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/profile_inactive.png'),
    ),
  )
};

// @TODOs
//   - Build bottom navigation bar - [ok]
//   - Build bottom navigation item - [ok]
//   - Each navigation item should be labeled
//   - Selected tab should be highlighted with different color
class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.currentTab,
    this.onSelectTab,
  });

  final TabItem currentTab;

  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color.fromRGBO(42, 41, 64, 1),
      ),
      child: BottomNavigationBar(
        unselectedItemColor: Color.fromRGBO(88, 91, 117, 1),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildBarItem(item: TabItem.inquiries),
          _buildBarItem(item: TabItem.inquiryChats),
          _buildBarItem(item: TabItem.manage),
          _buildBarItem(item: TabItem.settings),
          _buildBarItem(item: TabItem.profile),
        ],
        currentIndex: TabItem.values.indexOf(currentTab),
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem({TabItem item}) {
    final itemConf = TabLabelMap[item];
    final itemIcon =
        currentTab == item ? itemConf.activeIcon : itemConf.inactiveIcon;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          bottom: 5,
          top: 10,
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: itemIcon,
        ),
      ),
      label: itemConf.label,
    );
  }
}
