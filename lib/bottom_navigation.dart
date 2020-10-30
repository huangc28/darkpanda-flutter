import 'package:flutter/material.dart';

enum TabItem {
  inquiries,
  inquiryChat,
  services,
  profile,
}

Map<TabItem, String> TabLabelMap = {
  TabItem.inquiries: 'inquiries',
  TabItem.services: 'services',
  TabItem.profile: 'profile',
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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        _buildBarItem(item: TabItem.inquiries),
        _buildBarItem(item: TabItem.services),
        _buildBarItem(item: TabItem.profile),
      ],
      currentIndex: TabItem.values.indexOf(currentTab),
      onTap: (index) => onSelectTab(TabItem.values[index]),
    );
  }

  BottomNavigationBarItem _buildBarItem({TabItem item}) {
    final label = TabLabelMap[item];

    return BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
      ),
      label: label,
    );
  }
}
