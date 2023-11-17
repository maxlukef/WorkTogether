import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipable_stack/swipable_stack.dart';
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

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SwipableStack(
                  detectableSwipeDirections: const {
                    SwipeDirection.left,
                    SwipeDirection.right
                  },
                  stackClipBehaviour: Clip.none,
                  builder: (context, properties) {
                    final itemIndex = properties.index % studentSwipable.length;

                    return Stack(
                      children: <Widget>[
                        studentSwipable.elementAt(itemIndex)
                        // ...widget.users.map((e) => StudentCardSwipable(
                        //       id: e.id,
                        //       fullName: e.name,
                        //       major: e.major,
                        //       availableMornings: e.availableMornings,
                        //       availableAfternoons: e.availableAfternoons,
                        //       availableEvenings: e.availableEvenings,
                        //       skills: e.skills,
                        //       expectedGrade: e.expectedGrade,
                        //       weeklyHours: e.weeklyHours,
                        //       interests: e.interests,
                        //       notifyParent: refresh,
                        //       classId: widget.classId,
                        //       className: widget.className,
                        //       projectId: widget.projectId,
                        //       projectName: widget.projectName,
                        //       onLoggedUserTeam: false,
                        //     ))
                      ],
                    );
                  },
                ))
          ],
          // clipBehavior: Clip.none,
          // children: <Widget>[
          //   ...widget.users.map((e) => StudentCardSwipable(
          //         id: e.id,
          //         fullName: e.name,
          //         major: e.major,
          //         availableMornings: e.availableMornings,
          //         availableAfternoons: e.availableAfternoons,
          //         availableEvenings: e.availableEvenings,
          //         skills: e.skills,
          //         expectedGrade: e.expectedGrade,
          //         weeklyHours: e.weeklyHours,
          //         interests: e.interests,
          //         notifyParent: refresh,
          //         classId: widget.classId,
          //         className: widget.className,
          //         projectId: widget.projectId,
          //         projectName: widget.projectName,
          //         onLoggedUserTeam: false,
          //       ))
          // ],
        ),
      ),
    );
  }
}
