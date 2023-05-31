import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';

class GroupHome extends StatelessWidget {
  const GroupHome({super.key, required this.groupName});
  final String groupName;

  @override
  Widget build(BuildContext context) {
    List<Widget> milestones = [];
    milestones.add(createMilestoneTile("Milestone 1", 10, 10, "02/01/2023"));
    milestones.add(createMilestoneTile("Milestone 2", 12, 12, "02/14/2023"));
    milestones.add(createMilestoneTile("Milestone 3", 7, 10, "02/22/2023"));
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
            createTaskSection([
              "Draft a home screen UI",
              "Create a custom networking socket",
              "Go outside"
            ]),
            // Create task and All tasks buttons.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      // Bring user to create task page.
                      onPressed: () {},
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
                      onPressed: () {},
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

  // tasks are currently strings, probably replace this with a more sophisticated structure later.
  Widget createTaskSection(List<String> tasks) {
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
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tasks[i],
                    style: const TextStyle(
                      fontSize: 12,
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

  Widget createMilestoneTile(String milestoneName, int tasksCompleted,
      int tasksTotal, String deadline) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
      child: Container(
        width: 200,
        height: 100,
        color: Colors.grey.shade200,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  milestoneName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (tasksCompleted == tasksTotal)
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
              "$tasksCompleted/$tasksTotal Total Tasks",
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
                  deadline,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
