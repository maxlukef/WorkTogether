import 'package:flutter/material.dart';


class AlertDetailsPage extends StatelessWidget {
  AlertDetailsPage({
    required this.id,
    Key? key
  }) : super(key: key);

  int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alert Details"),
      ),
      body: Center(
        child: Text("Coming Soon!"),
      ),
    );
  }
}