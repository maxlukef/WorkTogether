import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/all_tasks/components/task.dart';

import '../../global_components/custom_app_bar.dart';
import '../../global_components/tag.dart';
import '../create_tasks/create_tasks.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  @override
  Widget build(BuildContext context) {
    List<Task> groupTasks = [
      Task("Draft a home screen UI", "02/14/2023", "Rory Donald"),
      Task("Create a custom socket", "04/23/2023", "Rory Donald"),
      Task("Develop client side API", "03/09/2023", "Alex Childs"),
    ];
    List<Task> yourTasks = [
      Task("Create a custom socket", "04/23/2023", "Rory Donald"),
      Task("Draft a home screen UI", "02/14/2023", "Rory Donald"),
      Task("Create a custom socket", "04/23/2023", "Rory Donald"),
    ];
    List<Task> completedTasks = [
      Task("Complete Client side networking", "02/14/2023", "Rory Donald"),
      Task("Create a super user", "04/23/2023", "Alex Childs"),
    ];

    return Scaffold(
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
                      createTaskInProgressSection(groupTasks, "Group Tasks"),
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
                                return const CreateTaskPage();
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
  Widget createCompletedTaskSection(List<Task> tasks, String headerText) {
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
                        tasks[i].taskText,
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
  Widget createTaskInProgressSection(List<Task> tasks, String headerText) {
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
                            tasks[i].taskText,
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
                      Tag(
                        text: tasks[i].assignedUser,
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
