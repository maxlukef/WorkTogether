import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/pages/professor_dashboard/project_edit_page.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/milestone_models/completion_info.dart';
import '../../models/milestone_models/milestone.dart';
import '../../models/milestone_models/milestone_dto.dart';
import 'components/alert_card.dart';
import 'components/donut_chart.dart';
import 'components/stat_card.dart';

class Dashboard extends StatefulWidget {
  Dashboard(
      {required this.projectId,
      required this.projectName,
      required this.classId,
      Key? key})
      : super(key: key);

  int projectId;
  String projectName;
  int classId;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double adjustableWidth = screenWidth - (screenWidth / 4);
    double maxAlertsWidth = 600;
    double spaceBetween = 0;

    if (adjustableWidth < maxAlertsWidth) {
      spaceBetween = 10;
    } else {
      spaceBetween = adjustableWidth - (maxAlertsWidth * 2) - 10;
    }

    spaceBetween = max(min(adjustableWidth - (maxAlertsWidth * 2), 100), 10);

    return Scaffold(
        appBar: CustomAppBar(title: widget.projectName),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
                    width: adjustableWidth,
                    child: Column(children: [
                      _milestoneSection(),
                      const SizedBox(height: 30),
                      Wrap(
                          direction: Axis.horizontal,
                          spacing: spaceBetween,
                          runSpacing: 20,
                          children: [
                            _alertSection(maxAlertsWidth, adjustableWidth),
                            _projectInfoSection(
                                maxAlertsWidth, adjustableWidth),
                          ]),
                      const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Divider(color: Colors.black)),
                      _projectStatsSection(maxAlertsWidth, adjustableWidth),
                      const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Divider(color: Colors.black)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ourLightColor(),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProjectEditPage(
                                  projectId: widget.projectId,
                                  classId: widget.classId);
                            }));
                          },
                          child: const Text("Manage Project"),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ])))));
  }

  Future<Map<String, String>> getMilestoneCompletionRate() async {
    List<Milestone> milestones = [];
    Map<String, String> milestoneCompletionRate = {};
    await httpService
        .getMilestonesForProject(widget.projectId)
        .then((value) => milestones = value!);
    for (Milestone m in milestones) {
      CompletionInfo? completionRate =
          await httpService.getMilestoneCompletionRate(m.id);

      if (completionRate != null) {
        milestoneCompletionRate[m.title] =
            (completionRate.completed / completionRate.numTeams).toString() +
                "%";
      }
    }
    return milestoneCompletionRate;
  }

  Future<String> getNextMilestoneDue() async {
    MilestoneDTO? m = await httpService.getNextMilestoneDue(widget.projectId);

    if (m == null) {
      return "";
    }
    return DateFormat.yMMMd().format(m.deadline);
  }

  _milestoneSection() {
    return Column(children: [
      const SizedBox(height: 20),
      const Center(
          child: Text("Next Milestone Due", style: TextStyle(fontSize: 16))),
      Center(
          child: FutureBuilder(
              future: getNextMilestoneDue(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString(),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700));
                } else {
                  return const Text("Loading...");
                }
              })),
      const SizedBox(height: 20),
      Center(
          child: Column(
        children: [
          FutureBuilder(
              future: getMilestoneCompletionRate(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, String>> snapshot) {
                if (snapshot.hasData) {
                  List<DonutChart> donutCharts = [];

                  for (var milestone in snapshot.data!.entries) {
                    try {
                      donutCharts.add(DonutChart(
                          title: milestone.key,
                          size: 100,
                          percentComplete:
                              int.parse(milestone.value.replaceAll("%", ""))));
                    } on Exception catch (_) {
                      donutCharts.add(DonutChart(
                          title: milestone.key, size: 100, percentComplete: 0));
                    }
                  }
                  return Wrap(
                      direction: Axis.horizontal,
                      spacing: 15,
                      children: donutCharts);
                } else {
                  return const Text("Loading...");
                }
              }),
          const SizedBox(height: 10),
          const Text("Class Milestone Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ],
      ))
    ]);
  }

  _alertSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
        width: min(maxAlertsWidth, adjustableWidth),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Alerts",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w700))),
            const SizedBox(height: 20),
            AlertCard(id: 1, text: "3 students have completed 0 tasks"),
            AlertCard(id: 2, text: "2 groups with overdue milestones"),
          ],
        ));
  }

  _projectInfoSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
        width: min(maxAlertsWidth, adjustableWidth),
        child: Column(children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("Project Info",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700))),
          const SizedBox(height: 20),
          AlertCard(id: 1, text: "10 Total Groups in the project"),
          AlertCard(id: 1, text: "Average 4 Students Per Group"),
          AlertCard(id: 1, text: "December 5, 2023 Project Deadline"),
        ]));
  }

  _projectStatsSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
        width: adjustableWidth,
        child: Column(children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("Project Stats",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700))),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Wrap(direction: Axis.horizontal, spacing: 20, children: [
                StatCard(
                    statTitle: "",
                    stat: "10",
                    description: "Average Tasks Completed Per Student"),
                StatCard(
                    statTitle: "",
                    stat: "7/10",
                    description: "Average Teammate Rating"),
              ])),
        ]));
  }
}
