import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:work_together_flutter/models/task_models/create_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/models/user_models/user.dart';
import '../../global_components/custom_app_bar.dart';
import 'components/milestone_drop_down.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage(
      {Key? key,
      required this.studentsInGroup,
      required this.milestones,
      required this.team})
      : super(key: key);
  final TeamDTO team;
  final List<User> studentsInGroup;
  final List<Milestone> milestones;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskDeadline = TextEditingController();

  // For submitting dto
  String dateForDTO = "";

  // Milestone selection.
  Milestone? selectedMilestone;

  // Student selections.
  List<User> selectedStudents = [];
  List<MultiSelectItem<User>> studentsDropdownList = [];
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    setupMultiselect();
  }

  void setupMultiselect() {
    for (User student in widget.studentsInGroup) {
      studentsDropdownList.add(MultiSelectItem(student, student.name));
    }
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return initialized == false
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(
              title: "Create Task",
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                createTaskInputs(),
              ]),
            ),
          );
  }

  Widget createMilestoneHeader(String milestoneName, String milestoneDeadline) {
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
                milestoneDeadline,
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

  Widget createTaskInputs() {
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
              controller: taskName,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Milestone",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MilestoneDropDown(
              milestones: widget.milestones,
              dropdownValueSetter: (Milestone value) {
                selectedMilestone = value;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Assignee(s):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MultiSelectDialogField(
              items: studentsDropdownList,
              title: const Text(
                "Select students",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              buttonText: const Text(
                "Select Users to Assign To Task",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) async {
                selectedStudents = results;
              },
              searchable: true,
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
              controller: taskDeadline,
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
                    taskDeadline.text = formattedDate;
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
              controller: taskDescription,
              maxLines: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                // Send task to backend.
                onPressed: () async {
                  if (selectedMilestone != null) {
                    List<int> studentIDs = [];
                    for (User student in selectedStudents) {
                      studentIDs.add(student.id);
                    }

                    CreateTaskDTO dto = CreateTaskDTO(
                        taskName.text,
                        taskDescription.text,
                        widget.team.id,
                        null,
                        selectedMilestone!.id,
                        studentIDs,
                        taskDeadline.text,
                        false);

                    await HttpService().createTask(dto);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
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
