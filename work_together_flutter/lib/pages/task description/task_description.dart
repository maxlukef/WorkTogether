import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/date_time_converter.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/milestone_models/milestone.dart';
import '../../models/task_models/return_task_dto.dart';
import '../../models/team_dto.dart';
import '../../models/user_models/user.dart';
import '../create_tasks/create_tasks.dart';

class TaskDescriptionPage extends StatefulWidget {
  const TaskDescriptionPage(
      {super.key,
      required this.task,
      required this.team,
      required this.milestones});
  final ReturnTaskDTO task;
  final TeamDTO team;
  final List<Milestone> milestones;
  @override
  State<TaskDescriptionPage> createState() => _TaskDescriptionPageState();
}

class _TaskDescriptionPageState extends State<TaskDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    String assignedUsersText = "";
    for (User assignee in widget.task.assignees) {
      if (assignedUsersText.isEmpty) {
        assignedUsersText = assignedUsersText + assignee.name;
      } else {
        assignedUsersText = "$assignedUsersText, ${assignee.name}";
      }
    }
    String milestoneName = '';
    for (Milestone m in widget.milestones) {
      if (m.id == widget.task.parentMilestoneID!) {
        milestoneName = m.title;
      }
    }
    Widget assignedUsers = Flexible(
      child: Text(assignedUsersText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          )),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: widget.task.name,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 40.0),
              child: Row(
                children: [
                  const Text(
                    "Task Name: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.task.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 40.0),
              child: Row(
                children: [
                  const Text(
                    "Milestone Name: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      milestoneName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 40.0),
              child: Row(
                children: [
                  const Text(
                    "Assigned User(s): ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  assignedUsers
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
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
                  formatDatePretty(widget.task.dueDate),
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
            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Text(
              "Task Description: ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Wrap(children: [
              Text(
                widget.task.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ourLightColor()),
                      onPressed: () async {
                        if (widget.task.completed) {
                          await HttpService()
                              .markTaskAsIncomplete(widget.task.id);
                        } else {
                          await HttpService()
                              .markTaskAsComplete(widget.task.id);
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: widget.task.completed
                          ? const Text(
                              "Mark as Incomplete",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Mark as Complete",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ourLightColor()),
                      onPressed: () async {
                        await HttpService().deleteTask(widget.task.id);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        "Delete Task",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ourLightColor()),
                      // Bring user to create task page.
                      onPressed: () async {
                        final bool result = await Navigator.push(
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
                                isEditing: true,
                                editingTask: widget.task,
                              );
                            },
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                        if (result == true) {
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                      child: const Text(
                        "Edit Task",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
