import 'package:flutter/material.dart';

class TaskDropDown extends StatefulWidget {
  const TaskDropDown({
    super.key,
    required this.dropdownValueSetter,
  });
  final ValueSetter<String> dropdownValueSetter;
  @override
  State<TaskDropDown> createState() => _TaskDropDownState();
}

class _TaskDropDownState extends State<TaskDropDown> {
  String dropdownValue = "No Users";
  List<String> students = ["Gary Makarov", "Lemony Grace", "Oliver Black"];

  @override
  Widget build(BuildContext context) {
    if (students.isNotEmpty && dropdownValue == "No Users") {
      dropdownValue = students.first;
    }
    // TODO: figure out how to deal with empty student lists.
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          widget.dropdownValueSetter(dropdownValue);
        });
      },
      items: students.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
