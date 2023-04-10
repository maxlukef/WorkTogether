import 'package:flutter/material.dart';
import 'package:work_together_flutter/tab_navigations/components/pages.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.currentTab,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final PageEnum currentTab;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (currentTab) {
      case PageEnum.home:
        child = Pages.allPages[PageEnum.home.index];
        break;
      case PageEnum.chat:
        child = Pages.allPages[PageEnum.chat.index];
        break;
      case PageEnum.notifications:
        child = Pages.allPages[PageEnum.notifications.index];
        break;
      case PageEnum.profile:
        child = Pages.allPages[PageEnum.profile.index];
        break;
      default:
        // Defaults to home.
        child = Pages.allPages[PageEnum.home.index];
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
