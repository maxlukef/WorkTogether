import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/date_time_converter.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:work_together_flutter/models/task_models/return_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/pages/task%20description/task_description.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../create_tasks/create_tasks.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({
    Key? key,
    required this.team,
    required this.milestones,
  }) : super(key: key);
  final TeamDTO team;
  final List<Milestone> milestones;
  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  List<ReturnTaskDTO> groupTasks = [];
  List<ReturnTaskDTO> yourTasks = [];
  List<ReturnTaskDTO> completedTasks = [];
  bool initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    getUserTasks();
  }

  Future<void> getUserTasks() async {
    groupTasks = [];
    yourTasks = [];
    completedTasks = [];

    // Add user tasks.
    List<ReturnTaskDTO>? results =
        await HttpService().getAllUserGroupTasks(widget.team.id);

    if (results != null) {
      for (ReturnTaskDTO dto in results) {
        if (dto.completed) {
          completedTasks.add(dto);
        } else {
          yourTasks.add(dto);
        }
      }
    }

    // Add group tasks.
    results = await HttpService().getAllGroupTasks(widget.team.id);
    if (results != null) {
      for (ReturnTaskDTO dto in results) {
        if (dto.completed) {
          completedTasks.add(dto);
        } else {
          groupTasks.add(dto);
        }
      }
    }

    initialLoadComplete = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return !initialLoadComplete
        ? const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(title: "All Tasks"),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        createTaskInProgressSection(groupTasks, "Group Tasks"),
                        createTaskInProgressSection(yourTasks, "Your Tasks"),
                        createCompletedTaskSection(
                            completedTasks, "Completed Tasks"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ourLightColor()),
                                // Bring user to create task page.
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation1,
                                          Animation<double> animation2) {
                                        return CreateTaskPage(
                                          team: widget.team,
                                          milestones: widget.milestones,
                                          studentsInGroup: widget.team.members,
                                          hasInitialMilestone: false,
                                          isEditing: false,
                                        );
                                      },
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                  await getUserTasks();
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
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  // For tasks that have already been completed.
  Widget createCompletedTaskSection(
      List<ReturnTaskDTO> tasks, String headerText) {
    List<Widget> taskWidgets = [];

    // Add header.
    taskWidgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
      child: Text(
        headerText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));

    // Add dynamic tasks.
    for (int i = 0; i < tasks.length; i++) {
      taskWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 16, 4),
        child: SizedBox(
          height: 45,
          width: 675,
          child: Material(
            color: Colors.grey.shade200,
            child: InkWell(
                // Bring user to relavant page regarding the task.
                onTap: () async {
                  await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return TaskDescriptionPage(
                          team: widget.team,
                          milestones: widget.milestones,
                          task: tasks[i],
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  await getUserTasks();
                },
                child: Container(
                  color: ourVeryLightColor(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tasks[i].name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
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

  // For tasks that have not been completed.
  Widget createTaskInProgressSection(
      List<ReturnTaskDTO> tasks, String headerText) {
    List<Widget> taskWidgets = [];

    // Add header.
    taskWidgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
      child: Text(
        headerText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));

    // Add dynamic tasks.
    for (int i = 0; i < tasks.length; i++) {
      taskWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 16, 4),
        child: Center(
          child: SizedBox(
            height: 75,
            width: 675,
            child: Material(
              color: Colors.grey.shade200,
              child: InkWell(
                  // Bring user to relavant page regarding the task.
                  onTap: () async {
                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return TaskDescriptionPage(
                            team: widget.team,
                            milestones: widget.milestones,
                            task: tasks[i],
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                    await getUserTasks();
                  },
                  child: Container(
                    color: ourVeryLightColor(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tasks[i].name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                formatDatePretty(tasks[i].dueDate),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ));
    }

    return Column(
      children: taskWidgets,
    );
  }
}
