import 'package:flutter/material.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/classes_models/classes_dto.dart';

import '../../global_components/custom_app_bar.dart';
import '../../models/user_models/user.dart';

class CreateConversation extends StatefulWidget {
  const CreateConversation({super.key});

  @override
  State<CreateConversation> createState() => _CreateConversationState();
}

class _CreateConversationState extends State<CreateConversation> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskLabel = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskDeadline = TextEditingController();

  // Class selections.
  List<ClassesDTO>? studentClasses;
  late List<DropdownMenuItem<ClassesDTO>> classesDropdownList;
  ClassesDTO? selectedClass;
  bool noClasses = false;

  // Student selections.
  List<User>? studentsInClass;
  User? selectedStudent;
  late List<DropdownMenuItem<User>> studentsDropdownList;

  @override
  void initState() {
    super.initState();
    getUserClasses();
  }

  Future<void> getUserClasses() async {
    studentClasses = await HttpService().getCurrentUsersClasses();

    studentClasses ??= [];
    noClasses = true;

    // Initialize to the first class.
    if (studentClasses!.isNotEmpty) {
      selectedClass = studentClasses!.first;
      await getStudentsInClass(selectedClass!.classID);
    }
    List<DropdownMenuItem<ClassesDTO>> dropDownOptions = [];

    for (ClassesDTO dto in studentClasses!) {
      dropDownOptions.add(DropdownMenuItem<ClassesDTO>(
        value: dto,
        child: Text(dto.name),
      ));
    }

    classesDropdownList = dropDownOptions;
    setState(() {});
  }

  Future<void> getStudentsInClass(int id) async {
    studentsInClass =
        await HttpService().getStudentsInClass(selectedClass!.classID);

    studentsInClass ??= [];

    // Initialize to the first class.
    if (studentsInClass!.isNotEmpty) {
      selectedStudent = studentsInClass!.first;
    }

    List<DropdownMenuItem<User>> dropDownOptions = [];

    for (User student in studentsInClass!) {
      dropDownOptions.add(DropdownMenuItem<User>(
        value: student,
        child: Text(student.name),
      ));
    }

    studentsDropdownList = dropDownOptions;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return studentClasses == null
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(
              title: "Create Conversation",
            ),
            body: noClasses == true
                ? Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "You are not registered to any classes, and cannot create a new conversation.",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Conversation Name:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Conversation Name",
                                ),
                                controller: taskName,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select Class:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<ClassesDTO>(
                                items: classesDropdownList,
                                value: selectedClass,
                                onChanged: (newSelection) async {
                                  selectedClass = newSelection;
                                  await getStudentsInClass(
                                      selectedClass!.classID);
                                },
                              ),
                            ),
                            if (studentsInClass != null)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Select Student:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (studentsInClass != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<User>(
                                  items: studentsDropdownList,
                                  value: selectedStudent,
                                  onChanged: (newSelection) async {
                                    selectedStudent = newSelection;
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  // Send task to backend.
                                  onPressed: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(1, 4, 12, 8),
                                    child: Text(
                                      "Create Conversation",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
          );
  }
}
