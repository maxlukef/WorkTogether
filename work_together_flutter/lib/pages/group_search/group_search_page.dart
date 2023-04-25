import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/card_info.dart';

class GroupSearchPage extends ConsumerStatefulWidget {
  const GroupSearchPage({
    Key? key,
    required this.userId,
    required this.classId,
  }) : super(key: key);

  final int userId;
  final int classId;

  @override
  ConsumerState<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends ConsumerState<GroupSearchPage> {
  @override
  Widget build(BuildContext context) {
    refresh() {
      print("refreshing");
      setState(() => {});
    }

    final HttpService httpService = HttpService();

    List<CardInfo>? teamMates = [];
    List<CardInfo>? users = [];

    return Scaffold(
        appBar: const CustomAppBar(title: "Group Search"),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
            child: Column(children: [
          const Padding(
              padding: EdgeInsets.only(left: 30, top: 15, bottom: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("CS4480",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)))),
          FutureBuilder(
              future: httpService.getTeam(widget.classId, widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CardInfo>> snapshot) {
                if (snapshot.hasData) {
                  teamMates = snapshot.data;
                }

                if (teamMates!.isNotEmpty) {
                  return Column(children: [
                    MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                        itemCount: teamMates?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return StudentCard(
                            id: teamMates![index].id,
                            fullName: teamMates![index].name,
                            major: teamMates![index].major,
                            availableMornings:
                                teamMates![index].availableMornings,
                            availableAfternoons:
                                teamMates![index].availableAfternoons,
                            availableEvenings:
                                teamMates![index].availableEvenings,
                            skills: teamMates![index].skills,
                            expectedGrade: teamMates![index].expectedGrade,
                            weeklyHours: teamMates![index].weeklyHours,
                            interests: teamMates![index].interests,
                            notifyParent: refresh,
                          );
                        }),
                    const Divider(color: Colors.black),
                  ]);
                }

                return const SizedBox.shrink();
              }),
          FutureBuilder(
              future: httpService.getUsers(widget.classId, widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CardInfo>> snapshot) {
                if (snapshot.hasData) {
                  users = snapshot.data;
                }

                return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    itemCount: users?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return StudentCard(
                        id: users![index].id,
                        fullName: users![index].name,
                        major: users![index].major,
                        availableMornings: users![index].availableMornings,
                        availableAfternoons: users![index].availableAfternoons,
                        availableEvenings: users![index].availableEvenings,
                        skills: users![index].skills,
                        expectedGrade: users![index].expectedGrade,
                        weeklyHours: users![index].weeklyHours,
                        interests: users![index].interests,
                        notifyParent: refresh,
                      );
                    });
              })
        ])));
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.blue,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
