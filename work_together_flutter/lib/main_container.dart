import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
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
    PageEnum.profile: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await navigatorKeys[currentIndex]!.currentState!.maybePop();
      },
      child: Scaffold(
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 700)
              SizedBox(
                width: 100,
                child: NavigationRail(
                    backgroundColor: ourPrimaryColor(),
                    indicatorColor: const Color.fromARGB(140, 82, 82, 82),
                    selectedIconTheme: const IconThemeData(color: Colors.white),
                    unselectedIconTheme:
                        const IconThemeData(color: Colors.black),
                    selectedLabelTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    unselectedLabelTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                    labelType: NavigationRailLabelType.selected,
                    onDestinationSelected: (index) => setState(() {
                          // If a user attempts to navigate to the same tab they are currently on.
                          // pop the additional screens on this navigation until root.
                          if (index == currentIndex.index) {
                            navigatorKeys[PageEnum.values[index]]!
                                .currentState!
                                .popUntil((route) => route.isFirst);
                          }
                          // Swap to a different tab.
                          else {
                            currentIndex = PageEnum.values[index];
                          }
                        }),
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.chat_bubble),
                        selectedIcon: Icon(Icons.chat_bubble),
                        label: Text('Chat'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.notifications),
                        selectedIcon: Icon(Icons.notifications),
                        label: Text('Notifications'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_2),
                        selectedIcon: Icon(Icons.person_2),
                        label: Text('Profile'),
                      ),
                    ],
                    selectedIndex: currentIndex.index),
              ),
            Expanded(
              child: Stack(children: [
                buildOffStageNavigator(PageEnum.home),
                buildOffStageNavigator(PageEnum.chat),
                buildOffStageNavigator(PageEnum.notifications),
                buildOffStageNavigator(PageEnum.profile),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: (MediaQuery.of(context).size.width <= 700)
            ? GNav(
                backgroundColor: ourPrimaryColor(),
                selectedIndex: currentIndex.index,
                activeColor: Colors.white,
                onTabChange: (index) => setState(() {
                  // If a user attempts to navigate to the same tab they are currently on.
                  // pop the additional screens on this navigation until root.
                  if (index == currentIndex.index) {
                    navigatorKeys[PageEnum.values[index]]!
                        .currentState!
                        .popUntil((route) => route.isFirst);
                  }
                  // Swap to a different tab.
                  else {
                    currentIndex = PageEnum.values[index];
                  }
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
              )
            : null,
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
