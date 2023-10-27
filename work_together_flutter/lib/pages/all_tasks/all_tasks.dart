import 'package:flutter/material.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:work_together_flutter/models/task_models/return_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';

import '../../global_components/custom_app_bar.dart';
import '../../global_components/tag.dart';
import '../../http_request.dart';
import '../../models/user_models/user.dart';
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
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(title: "All Tasks"),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          createTaskInProgressSection(
                              groupTasks, "Group Tasks"),
                          createTaskInProgressSection(yourTasks, "Your Tasks"),
                          createCompletedTaskSection(
                              completedTasks, "Completed Tasks"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              // Bring user to create task page.
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return CreateTaskPage(
                                        team: widget.team,
                                        milestones: widget.milestones,
                                        studentsInGroup: widget.team.members);
                                  },
                                ));
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
          height: 35,
          width: double.infinity,
          child: Material(
            color: Colors.grey.shade200,
            child: InkWell(
                // Bring user to relavant page regarding the task.
                onTap: () {},
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
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
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
    Map<int, List<Widget>> assignedUsers = {};

    // Add header.
    taskWidgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
      child: Text(
        headerText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));

    for (int i = 0; i < tasks.length; i++) {
      List<Widget> nameTags = [];

      for (User assignee in tasks[i].assignees) {
        nameTags.add(Tag(
          text: assignee.name,
        ));
      }

      assignedUsers[i] = nameTags;
    }

    // Add dynamic tasks.
    for (int i = 0; i < tasks.length; i++) {
      taskWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 16, 4),
        child: SizedBox(
          height: 75,
          width: double.infinity,
          child: Material(
            color: Colors.grey.shade200,
            child: InkWell(
                // Bring user to relavant page regarding the task.
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            tasks[i].name,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                tasks[i].dueDate,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: assignedUsers[i]!,
                      ),
                    ],
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
