import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:work_together_flutter/pages/chat/chat_page.dart';
import 'package:work_together_flutter/pages/home/home_page.dart';
import 'package:work_together_flutter/pages/notifications/notifications_page.dart';
import 'package:work_together_flutter/pages/profile/profile_page.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int currentIndex = 0;
  final pages = [
    HomePage(),
    ChatPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO: Complete Top App Bar'),
        centerTitle: true,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: GNav(
        backgroundColor: Color(0xFF1192DC),
        selectedIndex: currentIndex,
        onTabChange: (index) => setState(() {
          currentIndex = index;
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
}
