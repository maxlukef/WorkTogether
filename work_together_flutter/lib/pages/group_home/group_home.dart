import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/all_tasks/all_tasks.dart';
import 'package:work_together_flutter/pages/create_tasks/create_tasks.dart';
import 'package:work_together_flutter/pages/milestone%20description/milestone_description.dart';

import '../../global_components/custom_app_bar.dart';
import '../../global_components/milestone.dart';
import '../../global_components/task.dart';
import '../task description/task_description.dart';

class GroupHome extends StatelessWidget {
  const GroupHome({super.key, required this.groupName});
  final String groupName;

  @override
  Widget build(BuildContext context) {
    Milestone m1 = Milestone(
        "Milestone 1", "A milestone description.", "02/01/2023", 10, 10);

    Milestone m2 = Milestone("Milestone 2",
        "A different milestone description.", "02/14/2023", 12, 12);

    Milestone m3 = Milestone("Milestone 3", "Yet another milestone description",
        "02/22/2023", 7, 10);

    Milestone m4 = Milestone(
        "Milestone 4",
        "Build a chat server that supports multiple clients. Each client should be able to select a display name when joining so that they can be identified by that name. You will need to utilize multithreading to support multiple clients. Lorem ipsum dolor sit amet. Cum quasi facilis et voluptas temporibus quo incidunt accusamus? Qui error obcaecati sed adipisci voluptas est tempora molestiae. Vel quaerat quas id eligendi quibusdam ut molestiae natus ex quia provident sit eaque sunt. Cum similique quia et dolorem quia At mollitia maxime vel omnis sequi non omnis temporibus ea consequatur numquam.",
        "04/19/2023",
        2,
        4);

    List<Widget> milestones = [];
    milestones.add(createMilestoneTile(m1, context));
    milestones.add(createMilestoneTile(m2, context));
    milestones.add(createMilestoneTile(m3, context));
    milestones.add(createMilestoneTile(m4, context));

    Task t1 = Task(
        "Draft a home screen UI",
        "Create a rough blockout of the home screen.",
        "09/12/11",
        "Rory Donald");
    Task t2 = Task("Go outside", "Leave the abode", "09/12/11", "Rory Donald");
    Task t3 = Task(
        "Create a custom networking socket",
        "Create a socket to allow network connections.",
        "09/12/11",
        "Rory Donald");
    List<Task> tasks = [];

    tasks.add(t1);
    tasks.add(t2);
    tasks.add(t3);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomAppBar(title: groupName),
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: createMilestoneDueDate("Dec 22"),
                  ),
                  createProjectDueDate("Dec 31"),
                ],
              ),
            ),
            Center(child: createMilestoneProgressMeter(0.7)),
            createTaskSection(tasks, context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      // Bring user to create task page.
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const AllTasksPage();
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              children: milestones,
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

  Widget createTaskSection(List<Task> tasks, BuildContext context) {
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
                      milestone.name,
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
