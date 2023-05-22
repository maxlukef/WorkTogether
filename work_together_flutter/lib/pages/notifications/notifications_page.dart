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
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notifications.length,
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
                        child: notifications[index],
                      )),
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
              "Due: ",
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
          ],
        ),
      ],
    );
  }
}
