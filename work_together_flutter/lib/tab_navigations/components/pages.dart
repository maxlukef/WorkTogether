import '../../main.dart';
import '../../pages/notifications/notifications_page.dart';
import '../../pages/chat/contacts_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/profile/profile_page.dart';

enum PageEnum { home, chat, notifications, profile }

class Pages {
  static final allPages = [
    HomePage(userId: loggedUserId, classId: 1),
    const ConversationPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];
}
