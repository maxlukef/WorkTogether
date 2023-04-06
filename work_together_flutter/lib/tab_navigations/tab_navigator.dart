import 'package:flutter/material.dart';
import 'package:work_together_flutter/tab_navigations/components/pages.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.currentTab,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final PageEnum currentTab;

  Map<String, WidgetBuilder> buildRoute(BuildContext context) {
    switch (currentTab) {
      case PageEnum.home:
        {
          return {
            TabNavigatorRoutes.root: (context) =>
                Pages.allPages[currentTab.index],
            TabNavigatorRoutes.detail: (context) =>
                Pages.allPages[currentTab.index],
          };
        }

      case PageEnum.chat:
        {
          return {
            TabNavigatorRoutes.root: (context) =>
                Pages.allPages[currentTab.index],
            TabNavigatorRoutes.detail: (context) =>
                Pages.allPages[currentTab.index],
          };
        }

      case PageEnum.profile:
        {
          return {
            TabNavigatorRoutes.root: (context) =>
                Pages.allPages[currentTab.index],
            TabNavigatorRoutes.detail: (context) =>
                Pages.allPages[currentTab.index],
          };
        }

      case PageEnum.notifications:
        {
          return {
            TabNavigatorRoutes.root: (context) =>
                Pages.allPages[currentTab.index],
            TabNavigatorRoutes.detail: (context) =>
                Pages.allPages[currentTab.index],
          };
        }

      // I couldn't come up with a good default so it just shows profile.
      default:
        {
          return {
            TabNavigatorRoutes.root: (context) =>
                Pages.allPages[PageEnum.profile.index],
            TabNavigatorRoutes.detail: (context) =>
                Pages.allPages[PageEnum.profile.index],
          };
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = buildRoute(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }

  void pushRoute(BuildContext context) {
    var routeBuilders = buildRoute(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }
}
