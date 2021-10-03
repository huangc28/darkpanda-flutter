import 'package:flutter/material.dart';

enum MaleAppTabItem {
  waitingInquiry,
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

Map<MaleAppTabItem, TabItemAsset> TabLabelMap = {
  MaleAppTabItem.waitingInquiry: TabItemAsset(
    label: '需求',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/inquiries_inactive.png'),
    ),
  ),
  MaleAppTabItem.manage: TabItemAsset(
    label: '服務',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/manage_inactive.png'),
    ),
  ),
  MaleAppTabItem.settings: TabItemAsset(
    label: '設定',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/settings_inactive.png'),
    ),
  ),
  MaleAppTabItem.profile: TabItemAsset(
    label: '我的',
    activeIcon: Image(
      image: AssetImage('assets/bottombar_items/profile_active.png'),
    ),
    inactiveIcon: Image(
      image: AssetImage('assets/bottombar_items/profile_inactive.png'),
    ),
  )
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.currentTab,
    this.onSelectTab,
  });

  final MaleAppTabItem currentTab;

  final ValueChanged<MaleAppTabItem> onSelectTab;

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
          _buildBarItem(item: MaleAppTabItem.waitingInquiry),
          _buildBarItem(item: MaleAppTabItem.manage),
          _buildBarItem(item: MaleAppTabItem.settings),
          _buildBarItem(item: MaleAppTabItem.profile),
        ],
        currentIndex: MaleAppTabItem.values.indexOf(currentTab),
        onTap: (index) => onSelectTab(MaleAppTabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem({MaleAppTabItem item}) {
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
