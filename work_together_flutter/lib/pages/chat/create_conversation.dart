import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/models/chat_models/create_chat_dto.dart';
import 'package:work_together_flutter/models/classes_models/classes_dto.dart';

import '../../global_components/custom_app_bar.dart';
import '../../models/user.dart';

class CreateConversation extends StatefulWidget {
  const CreateConversation({super.key});

  @override
  State<CreateConversation> createState() => _CreateConversationState();
}

class _CreateConversationState extends State<CreateConversation> {
  TextEditingController conversationName = TextEditingController();

  // Class selections.
  List<ClassesDTO>? studentClasses;
  late List<MultiSelectItem<ClassesDTO>> classesDropdownList;
  List<ClassesDTO> selectedClasses = [];
  bool noClasses = false;

  // Student selections.
  List<User>? studentsInClass;
  List<User> selectedStudents = [];
  late List<MultiSelectItem<User>> studentsDropdownList;

  @override
  void initState() {
    super.initState();
    getUserClasses();
  }

  Future<void> getUserClasses() async {
    studentClasses = await HttpService().getCurrentUsersClasses();

    if (studentClasses == null) {
      studentClasses ??= [];
      noClasses = true;
    }

    List<MultiSelectItem<ClassesDTO>> dropDownOptions = [];

    for (ClassesDTO dto in studentClasses!) {
      dropDownOptions.add(MultiSelectItem(dto, dto.name));
    }

    classesDropdownList = dropDownOptions;
    setState(() {});
  }

  Future<void> getAllStudentsInClassSelections() async {
    studentsInClass = [];
    for (ClassesDTO dto in selectedClasses) {
      List<User> studentsInThisClass = await getStudentsInClass(dto.classID);
      studentsInClass!.addAll(studentsInThisClass);
    }
    removeDuplicatesAndCurrentUser();

    List<MultiSelectItem<User>> dropDownOptions = [];

    for (User student in studentsInClass!) {
      dropDownOptions.add(MultiSelectItem(student, student.name));
    }

    studentsDropdownList = dropDownOptions;
    setState(() {});
  }

  Future<List<User>> getStudentsInClass(int id) async {
    List<User>? students = await HttpService().getStudentsInClass(id);
    students ??= [];

    return students;
  }

  void removeDuplicatesAndCurrentUser() {
    studentsInClass!.removeWhere((student) => student.id == loggedUserId);
    Set<int> uniqueStudents = {};
    studentsInClass!.retainWhere((element) => uniqueStudents.add(element.id));
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
                ? const Column(
                    children: [
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
                                "Conversation Name.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      "Enter Conversation Name (Optional)",
                                ),
                                controller: conversationName,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Add users to chat. At least one student must be selected.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MultiSelectDialogField(
                                items: classesDropdownList,
                                title: const Text(
                                  "Select Classes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                buttonText: const Text(
                                  "Select Classes to Find Users",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) async {
                                  selectedClasses = results;
                                  selectedStudents = [];
                                  if (results.isNotEmpty) {
                                    await getAllStudentsInClassSelections();
                                  } else {
                                    studentsInClass = null;
                                    setState(() {});
                                  }
                                },
                                searchable: true,
                              ),
                            ),
                            if (studentsInClass != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MultiSelectDialogField(
                                  items: studentsDropdownList,
                                  title: const Text(
                                    "Select Users To Add",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  buttonText: const Text(
                                    "Add Users To Chat",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedStudents = results;
                                  },
                                  searchable: true,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () async {
                                    List<int> usersToAdd = [];
                                    for (User u in selectedStudents) {
                                      usersToAdd.add(u.id);
                                    }
                                    String name = "";
                                    if (conversationName.text.isNotEmpty) {
                                      name = conversationName.text;
                                    }
                                    if (usersToAdd.isNotEmpty) {
                                      CreateChatDTO dto =
                                          CreateChatDTO(name, usersToAdd);
                                      await HttpService()
                                          .createNewConversation(dto);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
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
