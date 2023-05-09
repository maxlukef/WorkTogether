import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> notifications = [];

    // Hardcoded notifcations.
    notifications.add(
        createNotification("CS 4400", "Complete Weekly Survey", "03/24/2023"));
    notifications.add(
        createNotification("CS 5530", "Complete Peer Review", "07/23/1994"));
    notifications.add(
        createNotification("CS 4400", "Complete Weekly Survey", "03/24/2023"));
    notifications.add(
        createNotification("CS 5530", "Complete Peer Review", "07/23/1994"));
    notifications.add(
        createNotification("CS 4400", "Complete Weekly Survey", "03/24/2023"));
    notifications.add(
        createNotification("CS 5530", "Complete Peer Review", "07/23/1994"));
    notifications.add(
        createNotification("CS 4400", "Complete Weekly Survey", "03/24/2023"));
    notifications.add(
        createNotification("CS 5530", "Complete Peer Review", "07/23/1994"));
    notifications.add(
        createNotification("CS 4400", "Complete Weekly Survey", "03/24/2023"));
    notifications.add(
        createNotification("CS 5530", "Complete Peer Review", "07/23/1994"));

    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: const CustomAppBar(title: "Notifications"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: notifications.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: notifications[index],
                );
              }),
        ));
  }

  Widget createNotification(String className, String title, String dueDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          className,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 23),
        ),
        Row(
          children: [
            const Text(
              "Due: ",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
            Text(
              dueDate,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Color.fromARGB(255, 31, 152, 252)),
            ),
          ],
        ),
      ],
    );
  }
}
