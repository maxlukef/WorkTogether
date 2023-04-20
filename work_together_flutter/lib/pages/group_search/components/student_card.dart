import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {

  StudentCard(
      {
        required this.profilePic,
        required this.fullName,
        required this.major,
        required this.availableMornings,
        required this.availableAfternoons,
        required this.availableEvenings,
        required this.skills,
        required this.expectedGrade,
        required this.weeklyHours,
        required this.interests,
      }
  );

  String text = "this is some cool text";
  final String fullName;
  String major;
  List<String> availableMornings;
  List<String> availableAfternoons;
  List<String> availableEvenings;
  List<String> skills;
  String expectedGrade;
  int weeklyHours;
  List<String> interests;
  Image profilePic;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        color: const Color(0xFFf2f2f2),
        margin: const EdgeInsets.all(0),
        //margin: const EdgeInsets.all(10),
        child: Align(
            child: GridView.count(crossAxisCount: 1, padding: EdgeInsets.only(left: 20), children: [
              Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: profilePic!.image
                            )
                        )
                    ),
                    Text(fullName)

                  ])
            ]
            ))
        );
  }
}
