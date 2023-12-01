import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:work_together_flutter/models/task_models/basic_task_dto.dart';
import 'package:work_together_flutter/models/task_models/create_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';
import 'package:work_together_flutter/models/user_models/user.dart';
import '../../global_components/custom_app_bar.dart';
import '../../global_components/date_time_converter.dart';
import '../../models/task_models/return_task_dto.dart';
import 'components/milestone_drop_down.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage(
      {Key? key,
      required this.studentsInGroup,
      required this.milestones,
      required this.team,
      required this.hasInitialMilestone,
      this.initialMilestoneValue,
      required this.isEditing,
      this.editingTask})
      : super(key: key);
  final TeamDTO team;
  final List<User> studentsInGroup;
  final List<Milestone> milestones;

  final bool hasInitialMilestone;
  final Milestone? initialMilestoneValue;

  final bool isEditing;
  final ReturnTaskDTO? editingTask;

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
    if (widget.isEditing) {
      initializeEditingValues();
    }
  }

  void initializeEditingValues() {
    taskName.text = widget.editingTask!.name;
    taskDescription.text = widget.editingTask!.description;
    DateTime initalDate = convertTime(widget.editingTask!.dueDate);
    taskDeadline.text = DateFormat.yMd().format(initalDate);
  }

  void setupMultiselect() {
    for (User student in widget.studentsInGroup) {
      studentsDropdownList.add(MultiSelectItem(student, student.name));
      if (widget.isEditing) {
        if (widget.editingTask!.containsStudentName(student.name)) {
          selectedStudents.add(student);
        }
      }
    }

    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return initialized == false
        ? const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(
              title: widget.isEditing ? "Edit Task" : "Create Task",
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 675,
                  child: Column(children: [
                    createTaskInputs(),
                  ]),
                ),
              ),
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
              maxLength: 20,
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
              initialValue: (widget.hasInitialMilestone || widget.isEditing),
              initialMilestone: widget.hasInitialMilestone
                  ? widget.initialMilestoneValue
                  : null,
              initialMilestoneID: widget.isEditing
                  ? widget.editingTask!.parentMilestoneID
                  : null,
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
              dialogHeight: 300,
              dialogWidth: 300,
              isDismissible: false,
              items: studentsDropdownList,
              initialValue: selectedStudents,
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
                DateTime initialDate = DateTime.now();
                if (widget.isEditing) {
                  initialDate = convertTime(widget.editingTask!.dueDate);
                }
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
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
                style:
                    ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
                // Send task to backend.
                onPressed: () async {
                  if (selectedMilestone != null &&
                      taskName.text.isNotEmpty &&
                      taskDeadline.text.isNotEmpty) {
                    if (widget.isEditing) {
                      ReturnTaskDTO initialDTO = widget.editingTask!;

                      List<int> assignedStudents = [];
                      for (User student in initialDTO.assignees) {
                        assignedStudents.add(student.id);
                      }

                      BasicTaskDTO dto = BasicTaskDTO(
                          initialDTO.id,
                          initialDTO.name,
                          initialDTO.description,
                          initialDTO.teamID,
                          initialDTO.parentTaskID,
                          initialDTO.parentMilestoneID,
                          assignedStudents,
                          initialDTO.dueDate,
                          initialDTO.completed);

                      await HttpService().editTask(dto);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
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
                      Navigator.of(context).pop(true);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1, 4, 12, 8),
                  child: widget.isEditing
                      ? const Text(
                          "Edit Task",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
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
