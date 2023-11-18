import 'dart:math';

import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';

class ProjectEditPage extends StatefulWidget {
  ProjectEditPage({required this.id, Key? key}) : super(key: key);

  int id;

  @override
  _projectEditPageState createState() => _projectEditPageState();
}

class _projectEditPageState extends State<ProjectEditPage> {
  @override
  Widget build(BuildContext context) {
    List<String> students = getStudentsInProject(widget.id);
    List<String> groups = getGroupsInProject(widget.id);

    String studentDropdownValue = students[0];
    String oldGroupDropdownValue = groups[0];
    String newGroupDropdownValue = groups[0];

    CustomDropdown studentDropdown = CustomDropdown(
        title: "Student",
        items: students,
        selectedItem: studentDropdownValue,
        onChanged: (String newValue) {
          oldGroupDropdownValue = newValue;
        });
    CustomDropdown oldGroupDropdown = CustomDropdown(
        title: "Old Group",
        items: groups,
        selectedItem: oldGroupDropdownValue,
        onChanged: (String newValue) {
          oldGroupDropdownValue = newValue;
        });
    CustomDropdown newGroupDropdown = CustomDropdown(
        title: "New Group",
        items: groups,
        selectedItem: newGroupDropdownValue,
        onChanged: (String newValue) {
          newGroupDropdownValue = newValue;
        });

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
                  child: Text("Move Students", style: TextStyle(fontSize: 24))),
              Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 20,
                children: [
                  studentDropdown,
                  oldGroupDropdown,
                  newGroupDropdown,
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
            ]
          )
        ),
      ]))),
    );
  }

  List<String> getStudentsInProject(int id) {
    return ["John Coder", "Jane Coder", "Jack Coder"];
  }

  List<String> getGroupsInProject(int id) {
    return ["WorkTogether", "Chef'd", "Habit@t"];
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
