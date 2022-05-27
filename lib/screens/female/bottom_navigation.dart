import 'package:flutter/material.dart';

enum FemaleTabItem {
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

Map<FemaleTabItem, TabItemAsset> TabLabelMap = {
  FemaleTabItem.inquiries: TabItemAsset(
    label: '需求',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_inactive.png'),
    ),
  ),
  FemaleTabItem.inquiryChats: TabItemAsset(
    label: '聊天',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/chat_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/chat_inactive.png'),
    ),
  ),
  FemaleTabItem.manage: TabItemAsset(
    label: '服務',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_inactive.png'),
    ),
  ),
  FemaleTabItem.settings: TabItemAsset(
    label: '設定',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_inactive.png'),
    ),
  ),
  FemaleTabItem.profile: TabItemAsset(
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

  final FemaleTabItem currentTab;

  final ValueChanged<FemaleTabItem> onSelectTab;

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
          _buildBarItem(item: FemaleTabItem.inquiries),
          _buildBarItem(item: FemaleTabItem.inquiryChats),
          _buildBarItem(item: FemaleTabItem.manage),
          _buildBarItem(item: FemaleTabItem.settings),
          _buildBarItem(item: FemaleTabItem.profile),
        ],
        currentIndex: FemaleTabItem.values.indexOf(currentTab),
        onTap: (index) => onSelectTab(FemaleTabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem({FemaleTabItem item}) {
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
