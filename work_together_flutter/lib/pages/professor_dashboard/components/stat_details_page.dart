import 'package:flutter/material.dart';


class StatDetailsPage extends StatelessWidget {
  StatDetailsPage({
    required this.id,
    Key? key
  }) : super(key: key);

  int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stat Details"),
      ),
      body: Center(
        child: Text("Coming Soon!"),
      ),
    );
  }
}