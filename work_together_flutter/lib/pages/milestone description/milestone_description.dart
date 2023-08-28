import 'package:flutter/material.dart';
import 'package:work_together_flutter/models/milestone.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:work_together_flutter/pages/task%20description/task_description.dart';
import '../../global_components/custom_app_bar.dart';
import '../../models/task.dart';
import '../../global_components/tag.dart';

class MilestoneDescriptionPage extends StatefulWidget {
  const MilestoneDescriptionPage({super.key, required this.milestone});
  final Milestone milestone;
  @override
  State<MilestoneDescriptionPage> createState() =>
      _MilestoneDescriptionPageState();
}

class _MilestoneDescriptionPageState extends State<MilestoneDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    Task t1 = Task(
        "Draft a home screen UI",
        "Create a rough blockout of the home screen.",
        "09/12/11",
        "Rory Donald");
    Task t2 = Task("Go outside", "Leave the abode", "09/12/11", "Alex Childs");
    Task t3 = Task(
        "Create a custom networking socket",
        "Create a socket to allow network connections. Lorem ipsum dolor sit amet. Cum quasi facilis et voluptas temporibus quo incidunt accusamus? Qui error obcaecati sed adipisci voluptas est tempora molestiae. Vel quaerat quas id eligendi quibusdam ut molestiae natus ex quia provident sit eaque sunt. Cum similique quia et dolorem quia At mollitia maxime vel omnis sequi non omnis temporibus ea consequatur numquam.",
        "09/12/11",
        "Grayson Spencer");
    List<Task> tasks = [];

    tasks.add(t1);
    tasks.add(t2);
    tasks.add(t3);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: widget.milestone.name,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Text(
                  "Tasks Complete",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
          createTaskSection(tasks),
        ]),
      ),
    );
  }

  // tasks are currently strings, probably replace this with a more sophisticated structure later.
  Widget createTaskSection(List<Task> tasks) {
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
                      Tag(text: tasks[i].assignedUser),
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
