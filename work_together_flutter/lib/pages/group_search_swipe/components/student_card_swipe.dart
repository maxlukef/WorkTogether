import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/tag_small.dart';

import '../../profile/group_search_profile_page.dart';

class StudentCardSwipable extends StatelessWidget {
  StudentCardSwipable(
      {required this.id,
      required this.fullName,
      required this.major,
      required this.availableMornings,
      required this.availableAfternoons,
      required this.availableEvenings,
      required this.skills,
      required this.expectedGrade,
      required this.weeklyHours,
      required this.interests,
      required this.notifyParent,
      required this.classId,
      required this.className,
      required this.projectId,
      required this.projectName,
      required this.onLoggedUserTeam});

  int id;
  final String fullName;
  String major;
  List<String> availableMornings;
  List<String> availableAfternoons;
  List<String> availableEvenings;
  List<String> skills;
  String expectedGrade;
  String weeklyHours;
  List<String> interests;
  final Function() notifyParent;
  int classId;
  String className;
  int projectId;
  String projectName;
  bool onLoggedUserTeam;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color(0xFFf2f2f2),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(children: [
              const Icon(
                Icons.account_circle,
                color: Colors.black26,
                size: 40.0,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(fullName,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700))),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(major,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700))),
                      ]))
            ]),
            const Divider(color: Colors.black),
            const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Availability",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700)))),
            ..._availabilityCards(),
            const Divider(color: Colors.black),
            const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Skills",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700)))),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(children: [..._skillsList()]),
            ),
            const Divider(color: Colors.black),
            const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Project Expectations",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700)))),
            IntrinsicHeight(
                child: Flex(direction: Axis.horizontal, children: [
              Expanded(
                flex: 10,
                child: Column(children: [
                  const Text("Grade", style: TextStyle(fontSize: 8)),
                  Text(expectedGrade,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900)),
                ]),
              ),
              const Expanded(
                flex: 1,
                child: VerticalDivider(thickness: 1, color: Colors.black),
              ),
              Expanded(
                flex: 10,
                child: Column(children: [
                  const Text("Weekly Hours", style: TextStyle(fontSize: 8)),
                  Text(weeklyHours,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900)),
                ]),
              )
            ])),
            const Divider(color: Colors.black),
            const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Interests",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700)))),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(children: [..._interestsList()]),
            ),
            const Divider(color: Colors.black),
          ])),
    );
  }

  _availabilityCards() {
    List<List<String>> availabilityList = [
      availableMornings,
      availableAfternoons,
      availableEvenings
    ];
    List<IconData> timeIcons = [Icons.alarm, Icons.sunny, Icons.mode_night];
    List<Widget> availabilityCards = [];
    for (var i = 0; i < availabilityList.length; i++) {
      List<Widget> availableDays = [];
      for (var j = 0; j < availabilityList[i].length; j++) {
        availableDays.add(Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                  height: 13,
                  width: 13,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                    color: const Color(0xFF11dc5c),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      availabilityList[i][j],
                      style: const TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w800),
                    ),
                  ))),
        ));
      }
      if (availableDays.isNotEmpty) {
        availabilityCards.add(Card(
            elevation: 5,
            color: const Color(0xFFf2f2f2),
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(timeIcons[i], size: 18, fill: 0),
                  ),
                  const Spacer(),
                  ...availableDays
                ]))));
      }
    }
    return availabilityCards;
  }

  _skillsList() {
    List<Widget> skillsList = [];

    for (var i = 0; i < skills.length; i++) {
      skillsList.add(Padding(
        padding: const EdgeInsets.only(top: 3, right: 6, bottom: 3),
        child: Tag(text: skills[i]),
      ));
    }
    return skillsList;
  }

  _interestsList() {
    List<Widget> interestsList = [];

    for (var i = 0; i < interests.length; i++) {
      interestsList.add(Padding(
        padding: const EdgeInsets.only(top: 3, right: 6, bottom: 3),
        child: Tag(text: interests[i]),
      ));
    }

    return interestsList;
  }
}
