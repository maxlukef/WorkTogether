import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import 'package:work_together_flutter/pages/profile/edit_profile_page.dart';

import '../../http_request.dart';
import '../../main.dart';
import '../../models/user.dart';

class GroupSearchProfilePage extends ConsumerStatefulWidget {
  GroupSearchProfilePage({
    Key? key,
    required this.id,
    required this.availableMornings,
    required this.availableAfternoons,
    required this.availableEvenings,
    required this.skills,
    required this.expectedGrade,
    required this.weeklyHours,
  }) : super(key: key);

  final int id;
  List<String> availableMornings;
  List<String> availableAfternoons;
  List<String> availableEvenings;
  List<String> skills;
  String expectedGrade;
  String weeklyHours;

  @override
  ConsumerState<GroupSearchProfilePage> createState() => _GroupProfileProfilePageState();
}
class _GroupProfileProfilePageState extends ConsumerState<GroupSearchProfilePage> {

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService.getUser(widget.id),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("An error has occurred while loading page."),
              ],
            );
          } else if (snapshot.hasData) {
            User u = snapshot.data!;

            return buildPage(context, u);
          }
          return const CircularProgressIndicator();
        });
  }

  Widget buildPage(BuildContext context, User userdata) {
    List<Widget> interestTags = [];

    for (String interest in userdata.interests) {
      interestTags.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 4.0, 0),
        child: Tag(
          text: interest,
        ),
      ));
    }

    return Scaffold(
        appBar: const CustomAppBar(title: "User Profile"),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Text(
                  userdata.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(
                Icons.account_circle,
                color: Colors.blue,
                size: 110.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Bio:",
                      style:
                          TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    child: Text(
                      userdata.bio,
                      style: const TextStyle(
                          fontSize: 14),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Major:",
                      style:
                          TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    child: Text(
                      userdata.major,
                      style: const TextStyle(
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Column(children: [..._availabilityCards()])
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Student Status:",
                      style:
                          TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    child: Row(
                      children: [
                        Tag(
                          text: userdata.studentStatus,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Employment Status:",
                      style:
                          TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    child: Row(
                      children: [
                        Tag(
                          text: userdata.employmentStatus,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Interests:",
                      style:
                          TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Row(
                        children: interestTags,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 4),
                    child: Text("Project Expectations", style:
                    TextStyle(fontSize: 24))
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
                    child: IntrinsicHeight(child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Column(children: [
                              const Text("Grade", style: TextStyle(fontSize: 16)),
                              Text(widget.expectedGrade,
                                  style:
                                  const TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                            ]),
                          ),
                          const Expanded(
                            flex: 1,
                            child: VerticalDivider(thickness: 1, color: Colors.black),
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(children: [
                              const Text("Weekly Hours", style: TextStyle(fontSize: 16)),
                              Text(widget.weeklyHours,
                                  style:
                                  const TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                            ]),
                          )
                        ])),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Skills:",
                      style:
                      TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Row(
                        children: _skillsList(),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32, 20, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:ElevatedButton(
                    onPressed: () {
                      HttpService().inviteToTeam(1, loggedUserId, widget.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: const Color(0xFF1192dc)),
                    child: const Text(
                      "Invite to Group",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ));
  }

  _availabilityCards() {
    List<List<String>> availabilityList = [widget.availableMornings, widget.availableAfternoons, widget.availableEvenings];
    List<IconData> timeIcons = [Icons.alarm, Icons.sunny, Icons.mode_night];
    List<String> timeStrings = ["Morning", "Afternoon", "Evening"];
    List<Widget> availabilityCards = [];
    for(var i = 0; i < availabilityList.length; i++) {
      List<Widget> availableDays = [];
      for(var j = 0; j < availabilityList[i].length; j++) {
        availableDays.add(Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                  height: 25,
                  width: 25,
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
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ))),
        ));
      }
      if(availableDays.isNotEmpty) {
        availabilityCards.add(Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child:Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF88ccf2), width: 2)
              ),
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(timeIcons[i], size: 25, fill: 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(timeStrings[i], style: TextStyle(fontSize: 14))
                      ),
                    ),
                    const Spacer(),
                    ...availableDays
                  ]))))
        );
      }
    }
    return availabilityCards;
  }

  _skillsList() {
    List<Widget> skillsList = [];

    for(var i = 0; i < widget.skills.length; i++) {
      skillsList.add(Padding(
        padding: const EdgeInsets.only(top: 3, right: 6, bottom: 3),
        child: Tag(text: widget.skills[i]),
      ));
    }
    return skillsList;
  }
}

