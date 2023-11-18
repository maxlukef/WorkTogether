import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/models/notification_models/notification_dto.dart';
import 'package:work_together_flutter/pages/group_search_swipe/components/student_card_swipe.dart';

import '../../http_request.dart';
import '../../models/card_info_models/card_info.dart';

class GroupSearchSwipePage extends ConsumerStatefulWidget {
  const GroupSearchSwipePage(
      {Key? key,
      required this.users,
      required this.userId,
      required this.classId,
      required this.className,
      required this.projectId,
      required this.projectName})
      : super(key: key);

  final List<CardInfo> users;
  final int userId;
  final int classId;
  final String className;
  final int projectId;
  final String projectName;

  @override
  ConsumerState<GroupSearchSwipePage> createState() =>
      _GroupSearchSwipePageState();
}

class _GroupSearchSwipePageState extends ConsumerState<GroupSearchSwipePage> {
  final HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() => {});
    }

    final swipeController = SwipableStackController();

    List<StudentCardSwipable> studentSwipable = widget.users
        .map((e) => StudentCardSwipable(
              id: e.id,
              fullName: e.name,
              major: e.major,
              availableMornings: e.availableMornings,
              availableAfternoons: e.availableAfternoons,
              availableEvenings: e.availableEvenings,
              skills: e.skills,
              expectedGrade: e.expectedGrade,
              weeklyHours: e.weeklyHours,
              interests: e.interests,
              notifyParent: refresh,
              classId: widget.classId,
              className: widget.className,
              projectId: widget.projectId,
              projectName: widget.projectName,
              onLoggedUserTeam: false,
            ))
        .toList();

    print(studentSwipable.length);

    return Scaffold(
      appBar: const CustomAppBar(title: "Group Search"),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 550,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(75),
                child: SwipableStack(
                  controller: swipeController,
                  onSwipeCompleted: (index, direction) {
                    if (direction.toString() == "SwipeDirection.right") {
                      // Invite to team
                      NotificationDTO teamInviteNotificationDTO = NotificationDTO(
                          id: -1,
                          title: "$loggedUserName Invited You To a Team",
                          description:
                              "$loggedUserName Invited You To a Team. Would you like to join?",
                          isInvite: true,
                          projectID: widget.projectId,
                          projectName: widget.projectName,
                          classID: widget.classId,
                          className: widget.className,
                          fromID: loggedUserId,
                          fromName: loggedUserName,
                          toID: studentSwipable.elementAt(index).id,
                          toName: studentSwipable.elementAt(index).fullName,
                          sentAt: DateTime.now(),
                          read: false);

                      HttpService().sendInviteNotificationToUser(
                          teamInviteNotificationDTO);
                    }
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  detectableSwipeDirections: const {
                    SwipeDirection.left,
                    SwipeDirection.right
                  },
                  stackClipBehaviour: Clip.none,
                  builder: (context, properties) {
                    final itemIndex = properties.index % studentSwipable.length;

                    return Stack(
                      children: <Widget>[studentSwipable.elementAt(itemIndex)],
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Icon(Icons.arrow_circle_left_outlined),
                    ),
                    Text("Swipe Left To Ignore"),
                    Spacer(),
                    Text("Swipe Right To Invite"),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
