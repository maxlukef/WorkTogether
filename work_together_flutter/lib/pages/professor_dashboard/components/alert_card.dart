import 'package:flutter/material.dart';

import '../alert_details_page.dart';

class AlertCard extends StatelessWidget {
  AlertCard({
    required this.id,
    required this.text,
    Key? key
  }) : super(key: key);

  int id;
  String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AlertDetailsPage(id: id);
          }
        ))
      },
      child: Card(
        elevation: 10,
        color: const Color(0xFFf2f2f2),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(text, style: const TextStyle(fontSize: 16)),
                )
              )
            ]
          )
        )
      )

    );
  }
}