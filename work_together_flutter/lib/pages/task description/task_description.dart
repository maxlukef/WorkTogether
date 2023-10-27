import 'package:flutter/material.dart';
import '../../global_components/custom_app_bar.dart';
import '../../models/task_models/return_task_dto.dart';
import '../../models/user_models/user.dart';

class TaskDescriptionPage extends StatefulWidget {
  const TaskDescriptionPage({super.key, required this.task});
  final ReturnTaskDTO task;

  @override
  State<TaskDescriptionPage> createState() => _TaskDescriptionPageState();
}

class _TaskDescriptionPageState extends State<TaskDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    List<Text> assignedUsers = [];
    for (User assignee in widget.task.assignees) {
      assignedUsers.add(Text(
        assignee.name,
        style: const TextStyle(fontSize: 16, color: Colors.blue),
      ));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const CustomAppBar(
        title: "Task Description",
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Row(
              children: [
                const Text(
                  "Assigned User(s): ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(children: assignedUsers)
              ],
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
                  widget.task.dueDate,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
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
                    ),
                  ),
                )
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
          )
        ]),
      ),
    );
  }
}
