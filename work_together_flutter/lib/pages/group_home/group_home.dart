import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/project_models/project_in_class.dart';
import 'package:work_together_flutter/models/task_models/return_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/pages/all_tasks/all_tasks.dart';
import 'package:work_together_flutter/pages/create_tasks/create_tasks.dart';
import 'package:work_together_flutter/pages/milestone%20description/milestone_description.dart';

import '../../global_components/custom_app_bar.dart';
import '../../models/milestone_models/milestone.dart';
import '../task description/task_description.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({super.key, required this.project});
  final ProjectInClass project;

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  List<ReturnTaskDTO>? userTasks;
  TeamDTO? team;
  List<Milestone>? milestones;
  List<Widget> milestoneWidgets = [];

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    getUserTasksApiCall();
    getProjectMilestones();
  }

  Future<void> getUserTasksApiCall() async {
    team = await getTeam();
    if (team != null) {
      userTasks = await HttpService().getAllUserGroupTasks(team!.id);
      userTasks ??= [];
      userTasks!.removeWhere((element) => element.completed == true);
      setState(() {});
    }
  }

  Future<void> getProjectMilestones() async {
    milestones = await HttpService().getMilestonesForProject(widget.project.id);
    milestones ??= [];
    milestoneWidgets = [];
    setState(() {});
  }

  Future<TeamDTO?> getTeam() async {
    TeamDTO? t = await HttpService().getTeamByProjectId(widget.project.id);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    String formattedProjectDeadline = format.format(widget.project.deadline);

    Milestone? currentMilestone;

    if (milestones != null) {
      for (Milestone m in milestones!) {
        milestoneWidgets.add(createMilestoneTile(m, context));
      }
      if (milestones!.isNotEmpty) {
        currentMilestone = milestones!.last;
      }
    }

    return (userTasks == null || team == null || milestones == null)
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(title: team!.name),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: currentMilestone == null
                                ? createMilestoneDueDate("No active milestone")
                                : createMilestoneDueDate(
                                    currentMilestone.deadline),
                          ),
                          createProjectDueDate(formattedProjectDeadline),
                        ]),
                      ],
                    ),
                  ),
                  Center(
                      child: currentMilestone == null
                          ? createMilestoneProgressMeter(0)
                          : createMilestoneProgressMeter(
                              currentMilestone.percentOfTasksComplete())),
                  createTaskSection(userTasks!, context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            // Bring user to create task page.
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CreateTaskPage(
                                    team: team!,
                                    milestones: milestones!,
                                    studentsInGroup: team!.members,
                                  );
                                },
                              ));
                              await setup();
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                              child: Text(
                                "Create Task",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            // Bring user to create task page.
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AllTasksPage(
                                    milestones: milestones!,
                                    team: team!,
                                  );
                                },
                              ));
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                              child: Text(
                                "All Tasks",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
                    child: Text(
                      "Milestones",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: milestoneWidgets,
                  ),
                ],
              ),
            ),
          );
  }

  Widget createMilestoneDueDate(String dueDate) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Next Milestone Due",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Text(
          dueDate,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget createProjectDueDate(String dueDate) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Project Deadline",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Text(
          dueDate,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Expects a value between [0, 1].
  Widget createMilestoneProgressMeter(double percentComplete) {
    // Conversion to a 1-5 scale of completion.
    int numFilledCircles = ((percentComplete * 10) / 2).floor();
    List<Widget> circles = [];

    // Add the 5 circles
    for (int i = 0; i < 5; i++) {
      // Default color is grey, represents uncompleted progress.
      Color circleColor = Colors.grey.shade400;

      // Fill the completed progress circles when applicable.
      if (numFilledCircles > 0) {
        circleColor = Colors.lightGreen;
        numFilledCircles--;
      }

      circles.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Milestone Progress",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: circles),
        ],
      ),
    );
  }

  Widget createTaskSection(List<ReturnTaskDTO> tasks, BuildContext context) {
    List<Widget> taskWidgets = [];

    // Add header.
    taskWidgets.add(const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
      child: Text(
        "Your Upcoming Tasks",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));

    // Add dynamic tasks.
    for (int i = 0; i < tasks.length; i++) {
      taskWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 16, 4),
        child: SizedBox(
          height: 35,
          width: double.infinity,
          child: Material(
            color: Colors.grey.shade200,
            child: InkWell(
                // Bring user to relavant page regarding the task.
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TaskDescriptionPage(
                        task: tasks[i],
                      );
                    },
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tasks[i].name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                )),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: taskWidgets,
    );
  }

  Widget createMilestoneTile(Milestone milestone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
      child: Container(
        width: 200,
        height: 100,
        color: Colors.grey.shade200,
        child: Material(
          color: Colors.grey.shade200,
          child: InkWell(
            // Brings user to relavant milestone page.
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MilestoneDescriptionPage(
                    milestone: milestone,
                    team: team!,
                  );
                },
              ));
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      milestone.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (milestone.tasksCompleted == milestone.totalTasks)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  "${milestone.tasksCompleted}/${milestone.totalTasks} Total Tasks",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                        "Deadline:",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      milestone.deadline,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
