import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/pages/create_tasks/components/task_drop_down.dart';
import '../../global_components/custom_app_bar.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  List<List<String>> conversations = [];
  TextEditingController taskName = TextEditingController();
  TextEditingController taskLabel = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskDeadline = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const CustomAppBar(
        title: "Create Task",
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          createMilestoneHeader(
              "Milestone 1: Build a Chat Server", "04/19/2023"),
          createTaskInputs(taskName, taskLabel, taskDescription, taskDeadline),
        ]),
      ),
    );
  }

  Widget createMilestoneHeader(String milestoneName, String mileStoneDeadline) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            milestoneName,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Milestone Deadline: ",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                mileStoneDeadline,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget createTaskInputs(
    TextEditingController name,
    TextEditingController label,
    TextEditingController description,
    TextEditingController deadline,
  ) {
    // This will be used for the api call.
    String selectedUser = "No User";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Name:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Task Name",
              ),
              controller: name,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Assignee:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskDropDown(
              dropdownValueSetter: (String value) {
                selectedUser = value;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Label:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Task Label",
              ),
              controller: label,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Deadline:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Task Deadline",
                icon: Icon(Icons.calendar_today),
              ),
              controller: deadline,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  String formattedDate = DateFormat.yMd().format(pickedDate);
                  setState(() {
                    deadline.text = formattedDate;
                  });
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Task Description",
              ),
              controller: description,
              maxLines: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                // Send task to backend.
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(1, 4, 12, 8),
                  child: Text(
                    "Create Task",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
