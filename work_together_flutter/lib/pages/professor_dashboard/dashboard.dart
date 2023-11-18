import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/professor_dashboard/project_edit_page.dart';

import '../../global_components/custom_app_bar.dart';
import 'components/alert_card.dart';
import 'components/donut_chart.dart';
import 'components/stat_card.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    required this.projectId,
    required this.projectName,
    required this.classId,
    Key? key}) : super(key: key);

  int projectId;
  String projectName;
  int classId;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                  direction: Axis.horizontal, spacing: spaceBetween, runSpacing: 20,
                  children: [
                  _alertSection(maxAlertsWidth, adjustableWidth),
                  _projectInfoSection(maxAlertsWidth, adjustableWidth),
                ]
              ),
                    const Padding(padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Divider(color: Colors.black)),
              _projectStatsSection(maxAlertsWidth, adjustableWidth),
              const Padding(padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Divider(color: Colors.black)),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProjectEditPage(id: widget.projectId);
                        }));
                  },
                  child: const Text("Manage Project"),
                ),
              ),
              const SizedBox(height: 50),
            ])))));
  }

  Map<String, String> getMilestoneCompletionRate() {

    return {
      "Milestone 1": "50%",
      "Milestone 2": "74%",
      "Milestone 3": "100%",
    };
  }

  String getNextMilestoneDue() {
    return "November 20 2023";
  }

  _milestoneSection() {
    var milestones = getMilestoneCompletionRate();
    List<DonutChart> donutCharts = [];

    for (var milestone in milestones.entries) {
      donutCharts.add(DonutChart(
          title: milestone.key, size: 100, percentComplete: int.parse(milestone.value.replaceAll("%", ""))));
    }
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
            child: Text("Next Milestone Due", style: TextStyle(fontSize: 16))
        ),
        Center(
            child: Text(getNextMilestoneDue(), style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w700))
        ),
        const SizedBox(height: 20),
        Center(
            child: Column(
              children: [
                Wrap(direction: Axis.horizontal, spacing: 2, children: donutCharts),
                const SizedBox(height: 10),
                const Text("Class Milestone Progress",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ))
      ]
    );
  }

  _alertSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
        width: min(maxAlertsWidth, adjustableWidth),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Alerts", style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w700))
            ),
            const SizedBox(height: 20),
            AlertCard(id: 1, text: "3 students have completed 0 tasks"),
            AlertCard(id: 2, text: "2 groups with overdue milestones"),
          ],
        )
    );
  }

  _projectInfoSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
        width: min(maxAlertsWidth, adjustableWidth),
        child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Project Info", style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w700))
              ),

              const SizedBox(height: 20),
              AlertCard(id: 1, text: "10 Total Groups in the project"),
              AlertCard(id: 1, text: "Average 4 Students Per Group"),
              AlertCard(id: 1, text: "December 5, 2023 Project Deadline"),
            ]
        )
    );
  }

  _projectStatsSection(double maxAlertsWidth, double adjustableWidth) {
    return SizedBox(
      width: adjustableWidth,
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("Project Stats", style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w700))
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
                direction: Axis.horizontal, spacing: 20,
                children: [
                  StatCard(statTitle: "", stat: "10", description: "Average Tasks Completed Per Student"),
                  StatCard(statTitle: "", stat: "7/10", description: "Average Teammate Rating"),
                ]
            )
          ),
        ]
      )
    );
  }
}
