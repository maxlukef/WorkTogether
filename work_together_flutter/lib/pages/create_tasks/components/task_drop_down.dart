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
  late String dropdownValue;
  List<String>? students;

  @override
  void initState() {
    super.initState();
    getUsersApiCall();
  }

  Future<void> getUsersApiCall() async {
    // Replace this with the api call to get the student names.
    // await Future.delayed(const Duration(seconds: 4));

    students = ["Gary Makarov", "Lemony Grace", "Oliver Black"];

    // Initialize to the first student.
    dropdownValue = students!.first;

    // Callback to sync the initial value to the parent widget.
    widget.dropdownValueSetter(dropdownValue);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (students == null) {
      return const Tooltip(
        message: "Loading Students.",
        child: CircularProgressIndicator(),
      );
    }

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
        dropdownValue = value!;
        widget.dropdownValueSetter(dropdownValue);
        setState(() {});
      },
      items: students!.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
