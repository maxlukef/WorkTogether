import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/notification_models/notification_dto.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpService.getCurrentUserNotifications(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("An error has occurred while loading page."),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            List<NotificationDTO> currentUserNotifications = snapshot.data!;

            List<Widget> notificationsWidgets = [];

            for (NotificationDTO currentUserNotification
                in currentUserNotifications) {
              notificationsWidgets.add(
                createNotification(
                    currentUserNotification.className,
                    currentUserNotification.title,
                    "${currentUserNotification.sentAt.year}/${currentUserNotification.sentAt.month}/${currentUserNotification.sentAt.day}",
                    currentUserNotification.fromName),
              );
            }

            return buildPage(context, notificationsWidgets);
          }
          return const CircularProgressIndicator();
        });
  }

  Widget buildPage(BuildContext context, List<Widget> notificationsWidgets) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: const CustomAppBar(title: "Notifications"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notificationsWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200),
                      // Bring user to relavant page regarding the notification.
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: notificationsWidgets[index],
                      )),
                );
              }),
        ));
  }

  Widget createNotification(
      String className, String title, String dueDate, String fromUserName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          className,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 23),
        ),
        Row(
          children: [
            const Text(
              "Recieved: ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
            ),
            Text(
              dueDate,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Color.fromARGB(255, 31, 152, 252)),
            ),
            const Spacer(),
            const Text(
              "From: ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
            ),
            Text(
              fromUserName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
