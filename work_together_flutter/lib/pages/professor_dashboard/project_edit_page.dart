import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/team_dto.dart';
import '../../models/user_models/user.dart';

class ProjectEditPage extends StatefulWidget {
  ProjectEditPage({
    required this.projectId,
    required this.classId,
    Key? key}) : super(key: key);

  int projectId;
  int classId;
  String inviteCode = "";

  @override
  _projectEditPageState createState() => _projectEditPageState();
}

class _projectEditPageState extends State<ProjectEditPage> {
  @override
  Widget build(BuildContext context) {

    String oldGroupDropdownValue = "";
    String newGroupDropdownValue = "";
    String studentDropdownValue = "";

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    double dropDownWidth = 400;
    double screenPadding = min(screenWidth - dropDownWidth, screenWidth / 4);

    return Scaffold(
      appBar: const CustomAppBar(title: "Manage Project"),
      body: SingleChildScrollView(
          child: Center(
              child: Column(children: [

        Padding(
          padding: EdgeInsets.only(left: screenPadding / 2, right: screenPadding / 2),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Move Students", style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w700))),
              Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 20,
                children: [
                  FutureBuilder(
                    future: getStudentsInProject(widget.projectId),
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.length > 0) {
                        List<String> students = snapshot.data!;
                        studentDropdownValue = students[0];
                        return CustomDropdown(
                            title: "Student",
                            items: students,
                            selectedItem: studentDropdownValue,
                            onChanged: (String newValue) {
                              studentDropdownValue = newValue;
                            });
                      } else {
                        return CustomDropdown(
                            title: "Student",
                            items: const ["Loading..."],
                            selectedItem: "Loading...",
                            onChanged: (String newValue) {
                              studentDropdownValue = newValue;
                            }
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: getGroupsInProject(widget.projectId),
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.length > 0) {
                        List<String> groups = snapshot.data!;
                        oldGroupDropdownValue = groups[0];
                        return CustomDropdown(
                            title: "Old Group",
                            items: groups,
                            selectedItem: oldGroupDropdownValue,
                            onChanged: (String newValue) {
                              oldGroupDropdownValue = newValue;
                            });
                      } else {
                        return CustomDropdown(
                          title: "Old Group",
                          items: const ["Loading..."],
                          selectedItem: "Loading...",
                          onChanged: (String newValue) {
                            oldGroupDropdownValue = newValue;
                          }
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: getGroupsInProject(widget.projectId),
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.length > 0) {
                        List<String> groups = snapshot.data!;
                        newGroupDropdownValue = groups[0];
                        return CustomDropdown(
                            title: "New Group",
                            items: groups,
                            selectedItem: newGroupDropdownValue,
                            onChanged: (String newValue) {
                              newGroupDropdownValue = newValue;
                            });
                      } else {
                        return CustomDropdown(
                            title: "New Group",
                            items: const ["Loading..."],
                            selectedItem: "Loading...",
                            onChanged: (String newValue) {
                              newGroupDropdownValue = newValue;
                            }
                        );
                      }
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    moveStudent(studentDropdownValue, oldGroupDropdownValue, newGroupDropdownValue);
                  },
                  child: const Text('Move'),
                ),
              ),
              const Divider(color: Colors.black),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Class Invite Code", style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w700)),
              ),
              Row(
                children: [
                  FutureBuilder(
                    future: HttpService().getClassInviteCode(widget.classId),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        widget.inviteCode = snapshot.data!.substring(1, snapshot.data!.length - 1);
                        return Text(widget.inviteCode);
                      } else {
                        return const Text("Loading...");
                      }
                    },
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.inviteCode)).then((value) {
                        final snackBar = SnackBar(
                          content: const Text('Copied to Clipboard'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: ""));
                            },
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: const Text('Copy'),
                  )
                ]
              ),
              const SizedBox(width: 50),
            ]
          )
        ),
      ]))),
    );
  }

  Future<List<String>> getStudentsInProject(int id) async {
    List<User>? students = await HttpService().getStudentsInClass(widget.classId);
    List<String> studentsNames = [];
    for(User s in students!) {
      print(s.name);
      studentsNames.add(s.name);
    }
    return studentsNames;
  }

  Future<List<String>> getGroupsInProject(int id) async {
    List<String> teamNames = [];
    List<TeamDTO> teams = await HttpService().getTeamsForProject(id);
    for(TeamDTO t in teams) {
      print(t.name);
      teamNames.add(t.name);
    }
    print("yo");
    return teamNames;
  }

  void moveStudent(String student, String oldGroup, String newGroup) {
    print("Moving $student from $oldGroup to $newGroup");
  }
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {required this.title,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      super.key});

  final String title;
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String dropdownValue = 'John Coder';
  List<String> groupList = ['John Coder', 'Jane Coder', 'Jack Coder'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title, style: const TextStyle(fontSize: 16)),
            ),
            DropdownMenu<String>(
              width: 400,
              initialSelection: widget.selectedItem,
              onSelected: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  widget.onChanged(value);
                });
              },
              dropdownMenuEntries:
              widget.items.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ]
        )
      )
    );
  }
}
