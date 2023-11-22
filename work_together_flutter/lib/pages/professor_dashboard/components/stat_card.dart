


import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/professor_dashboard/components/stat_details_page.dart';

class StatCard extends StatelessWidget {
  StatCard({
    required this.statTitle,
    required this.stat,
    required this.description,
    Key? key
  }) : super(key: key);

  String statTitle;
  String stat;
  String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return StatDetailsPage(id: 1);
          }
        ))
      },
      child: SizedBox(
        height: 175,
        width: 175,
        child: Card(
          elevation: 10,
          color: const Color(0xFFf2f2f2),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(stat,
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(description, style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center),
                )
              ]
            )
          )
        )
    )
    );
  }
}