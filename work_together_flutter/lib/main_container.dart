import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:work_together_flutter/tab_navigations/components/pages.dart';
import 'package:work_together_flutter/tab_navigations/tab_navigator.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  PageEnum currentIndex = PageEnum.home;

  // Used to create multiple navigation stacks for each tab in the nav bar.
  final navigatorKeys = {
    PageEnum.home: GlobalKey<NavigatorState>(),
    PageEnum.chat: GlobalKey<NavigatorState>(),
    PageEnum.notifications: GlobalKey<NavigatorState>(),
    PageEnum.profile: GlobalKey<NavigatorState>()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO: Complete Top App Bar'),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        buildOffStageNavigator(PageEnum.home),
        buildOffStageNavigator(PageEnum.chat),
        buildOffStageNavigator(PageEnum.notifications),
        buildOffStageNavigator(PageEnum.profile),
      ]),
      bottomNavigationBar: GNav(
        backgroundColor: const Color(0xFF1192DC),
        selectedIndex: currentIndex.index,
        onTabChange: (index) => setState(() {
          currentIndex = PageEnum.values[index];
        }),
        gap: 10,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.chat_bubble,
            text: 'Chat',
          ),
          GButton(
            icon: Icons.notifications,
            text: 'Notifications',
          ),
          GButton(
            icon: Icons.person_2,
            text: 'Profile',
          )
        ],
      ),
    );
  }

  Widget buildOffStageNavigator(PageEnum currentTab) {
    return Offstage(
      offstage: currentIndex != currentTab,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentTab]!,
        currentTab: currentTab,
      ),
    );
  }
}
