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
    return const Scaffold(
      appBar: CustomAppBar(title: "Notifications"),
      body: Text("THIS IS THE NOTIFICATIONS PAGE"),
    );
  }
}
