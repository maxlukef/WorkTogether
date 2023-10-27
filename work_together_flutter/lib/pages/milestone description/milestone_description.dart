import 'package:flutter/material.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/pages/task%20description/task_description.dart';
import '../../global_components/custom_app_bar.dart';
import '../../global_components/tag.dart';
import '../../http_request.dart';
import '../../models/task_models/return_task_dto.dart';
import '../../models/user_models/user.dart';

class MilestoneDescriptionPage extends StatefulWidget {
  const MilestoneDescriptionPage(
      {super.key, required this.milestone, required this.team});
  final Milestone milestone;
  final TeamDTO team;
  @override
  State<MilestoneDescriptionPage> createState() =>
      _MilestoneDescriptionPageState();
}

class _MilestoneDescriptionPageState extends State<MilestoneDescriptionPage> {
  List<ReturnTaskDTO>? userTasks = [];
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

    // Only want to display incomplete tasks from both user and group.
    if (userTasks != null && results != null) {
      userTasks!.addAll(results);
      userTasks!.removeWhere((element) => element.completed == true);
    } else {
      userTasks = [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userTasks == null
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(
              title: widget.milestone.title,
            ),
            body: SingleChildScrollView(
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
                              percent: widget.milestone.tasksCompleted /
                                  widget.milestone.totalTasks,
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
                                fontSize: 24, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                            widget.milestone.deadline,
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
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
          );
  }

  Widget createTaskSection(List<ReturnTaskDTO> tasks) {
    List<Widget> taskWidgets = [];
    Map<int, List<Widget>> assignedUsers = {};

    for (int i = 0; i < tasks.length; i++) {
      List<Widget> nameTags = [];

      for (User assignee in tasks[i].assignees) {
        nameTags.add(Tag(
          text: assignee.name,
        ));
      }

      assignedUsers[i] = nameTags;
    }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tasks[i].name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
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
