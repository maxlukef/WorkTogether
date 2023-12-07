import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/global_components/date_time_converter.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/pages/task%20description/task_description.dart';
import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/task_models/return_task_dto.dart';
import '../../models/user_models/user.dart';
import '../create_tasks/create_tasks.dart';

class MilestoneDescriptionPage extends StatefulWidget {
  const MilestoneDescriptionPage(
      {super.key,
      required this.milestone,
      required this.team,
      required this.allMilestones});
  final Milestone milestone;
  final TeamDTO team;
  final List<Milestone> allMilestones;
  @override
  State<MilestoneDescriptionPage> createState() =>
      _MilestoneDescriptionPageState();
}

class _MilestoneDescriptionPageState extends State<MilestoneDescriptionPage> {
  List<ReturnTaskDTO>? userTasks = [];

  bool useMilestoneTaskInfo = false;
  @override
  void initState() {
    super.initState();
    getUserTasksApiCall();
  }

  Future<void> getUserTasksApiCall() async {
    // user tasks
    userTasks =
        await HttpService().getAllUserMilestoneTasks(widget.milestone.id);
    // the group tasks.
    List<ReturnTaskDTO>? results =
        await HttpService().getAllMilestoneTasks(widget.milestone.id);

    // Display tasks from both user and group.
    if (userTasks != null && results != null) {
      userTasks!.addAll(results);
    } else {
      userTasks = [];
    }

    int totalTasks = 0;
    int completedTasks = 0;
    for (ReturnTaskDTO t in userTasks!) {
      totalTasks++;
      if (t.completed) {
        completedTasks++;
      }
    }

    widget.milestone.totalTasks = totalTasks;
    widget.milestone.tasksCompleted = completedTasks;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userTasks == null
        ? const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(
              title: widget.milestone.title,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 675,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 10.0,
                                        backgroundColor: Colors.grey.shade200,
                                        progressColor: Colors.green,
                                        percent: widget.milestone
                                            .percentOfTasksComplete(),
                                        center: Text(
                                          "${widget.milestone.tasksCompleted} / ${widget.milestone.totalTasks}",
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Tasks Complete",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Deadline: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      formatDatePretty(
                                          widget.milestone.deadline),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  "Description: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  widget.milestone.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              createTaskSection(userTasks!),
                            ]),
                      ),
                    ),
                  ),
                ),
                Padding(
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
                                      milestones: widget.allMilestones,
                                      studentsInGroup: widget.team.members,
                                      hasInitialMilestone: true,
                                      initialMilestoneValue: widget.milestone,
                                      isEditing: false,
                                    );
                                  },
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                              await getUserTasksApiCall();
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
                )
              ],
            ),
          );
  }

  Widget createTaskSection(List<ReturnTaskDTO> tasks) {
    List<Widget> taskWidgets = [];
    // Add header.
    taskWidgets.add(const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        "Tasks In Milestone",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));

    // Add dynamic tasks.
    for (int i = 0; i < tasks.length; i++) {
      taskWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: Material(
            color: Colors.grey.shade200,
            child: InkWell(
                // Bring user to relavant page regarding the task.
                onTap: () async {
                  final bool result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return TaskDescriptionPage(
                          team: widget.team,
                          milestones: widget.allMilestones,
                          task: tasks[i],
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  if (result == true) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                  await getUserTasksApiCall();
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
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        if (tasks[i].completed)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
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
}
