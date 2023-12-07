import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import 'package:work_together_flutter/pages/questionnaire/questionnaire.dart';

import '../../http_request.dart';
import '../../main.dart';
import '../../models/notification_models/notification_dto.dart';
import '../../models/user_models/user.dart';

class GroupSearchProfilePage extends ConsumerStatefulWidget {
  const GroupSearchProfilePage(
      {Key? key,
      required this.id,
      required this.availableMornings,
      required this.availableAfternoons,
      required this.availableEvenings,
      required this.skills,
      required this.expectedGrade,
      required this.weeklyHours,
      required this.classId,
      required this.className,
      required this.projectId,
      required this.projectName,
      required this.onLoggedUserTeam})
      : super(key: key);

  final int id;
  final List<String> availableMornings;
  final List<String> availableAfternoons;
  final List<String> availableEvenings;
  final List<String> skills;
  final String expectedGrade;
  final String weeklyHours;
  final int classId;
  final String className;
  final int projectId;
  final String projectName;
  final bool onLoggedUserTeam;

  @override
  ConsumerState<GroupSearchProfilePage> createState() =>
      _GroupProfileProfilePageState();
}

class _GroupProfileProfilePageState
    extends ConsumerState<GroupSearchProfilePage> {
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
          return const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          );
        });
  }

  Widget buildPage(BuildContext context, User userdata) {
    List<Widget> interestTags = [];
    String inviteToGroupOrEdit;

    if (userdata.id == loggedUserId) {
      inviteToGroupOrEdit = "Edit My Questionnaire";
    } else {
      inviteToGroupOrEdit = "Invite to Group";
    }

    if (userdata.interests.contains("")) {
      userdata.interests.remove("");
    }

    if (userdata.interests.isEmpty) {
      interestTags.add(const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "No Interests",
          style: TextStyle(fontSize: 14),
        ),
      ));
    } else {
      for (String interest in userdata.interests) {
        interestTags.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0, 4.0, 0),
          child: Tag(
            text: interest,
          ),
        ));
      }
    }

    return Scaffold(
        appBar: const CustomAppBar(title: "User Profile"),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                  size: 110.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    userdata.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Visibility(
                  visible:
                      !widget.onLoggedUserTeam || userdata.id == loggedUserId,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (userdata.id == loggedUserId) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation1,
                                    Animation<double> animation2) {
                                  return QuestionnairePage(
                                      loggedUserId: loggedUserId,
                                      classId: widget.classId,
                                      className: widget.className,
                                      projectId: widget.projectId,
                                      projectName: widget.projectName);
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          } else {
                            NotificationDTO teamInviteNotificationDTO =
                                NotificationDTO(
                                    id: -1,
                                    title:
                                        "$loggedUserName Invited You To a Team",
                                    description:
                                        "$loggedUserName Invited You To a Team. Would you like to join?",
                                    isInvite: true,
                                    projectID: widget.projectId,
                                    projectName: widget.projectName,
                                    classID: widget.classId,
                                    className: widget.className,
                                    fromID: loggedUserId,
                                    fromName: loggedUserName,
                                    toID: userdata.id,
                                    toName: userdata.name,
                                    sentAt: DateTime.now(),
                                    read: false);

                            HttpService().sendInviteNotificationToUser(
                                teamInviteNotificationDTO);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(125, 35),
                            backgroundColor: ourLightColor()),
                        child: Text(
                          inviteToGroupOrEdit,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Bio:",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Text(
                        userdata.bio,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Major:",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Text(
                        userdata.major,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Column(children: [..._availabilityCards()])),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Student Status:",
                        style: TextStyle(fontSize: 24),
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
                        style: TextStyle(fontSize: 24),
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
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                        child: Wrap(
                          children: interestTags,
                        )),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Skills:",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                        child: Wrap(
                          children: _skillsList(),
                        )),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 4),
                        child: Text("Project Expectations",
                            style: TextStyle(fontSize: 24))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
                      child: IntrinsicHeight(
                          child: Flex(direction: Axis.horizontal, children: [
                        Expanded(
                          flex: 10,
                          child: Column(children: [
                            const Text("Grade", style: TextStyle(fontSize: 16)),
                            Text(widget.expectedGrade,
                                style: const TextStyle(
                                    fontSize: 48, fontWeight: FontWeight.w900)),
                          ]),
                        ),
                        const Expanded(
                          flex: 1,
                          child: VerticalDivider(
                              thickness: 1, color: Colors.black),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(children: [
                            const Text("Weekly Hours",
                                style: TextStyle(fontSize: 16)),
                            Text(widget.weeklyHours,
                                style: const TextStyle(
                                    fontSize: 48, fontWeight: FontWeight.w900)),
                          ]),
                        )
                      ])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _availabilityCards() {
    List<List<String>> availabilityList = [
      widget.availableMornings,
      widget.availableAfternoons,
      widget.availableEvenings
    ];
    List<IconData> timeIcons = [Icons.alarm, Icons.sunny, Icons.mode_night];
    List<String> timeStrings = ["Morning", "Afternoon", "Evening"];
    List<Widget> availabilityCards = [];
    for (var i = 0; i < availabilityList.length; i++) {
      List<Widget> availableDays = [];
      for (var j = 0; j < availabilityList[i].length; j++) {
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
      if (availableDays.isNotEmpty) {
        availabilityCards.add(Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF88ccf2), width: 2)),
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
                            child: Text(timeStrings[i],
                                style: const TextStyle(fontSize: 14))),
                      ),
                      const Spacer(),
                      ...availableDays
                    ])))));
      }
    }
    return availabilityCards;
  }

  _skillsList() {
    List<Widget> skillsList = [];

    for (var i = 0; i < widget.skills.length; i++) {
      skillsList.add(Padding(
        padding: const EdgeInsets.only(top: 3, right: 6, bottom: 3),
        child: Tag(text: widget.skills[i]),
      ));
    }
    return skillsList;
  }
}
