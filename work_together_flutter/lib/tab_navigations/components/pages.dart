import '../../main.dart';
import '../../pages/notifications/notifications_page.dart';
import '../../pages/chat/chat_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/profile/profile_page.dart';
import 'package:work_together_flutter/pages/group_search/group_search_page.dart';

enum PageEnum { home, chat, notifications, profile }

class Pages {
  static final allPages = [
    const HomePage(),
    const ChatPage(),
    const NotificationsPage(),
    ProfilePage(userId: loggedUserId),
  ];
}
