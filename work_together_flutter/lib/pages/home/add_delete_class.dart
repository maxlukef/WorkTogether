import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/classes_models/classes_dto.dart';
import '../professor_dashboard/project_edit_page.dart';

class AddDeleteClass extends StatefulWidget {
  AddDeleteClass({Key? key}) : super(key: key);

  String className = "";
  String classDescription = "";

  @override
  _AddDeleteClassState createState() => _AddDeleteClassState();
}

class _AddDeleteClassState extends State<AddDeleteClass> {
  final _formKey = GlobalKey<FormState>();
  ClassesDTO selectedClass = ClassesDTO(0, 0, "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Manage Project"),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
                    width: 675,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _formKey,
                          child: Column(children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Add Class",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700))),
                        TextFormField(
                            onSaved: (value) {
                              widget.className = value!;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter a class name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a class name';
                              }
                              return null;
                            }),
                        TextFormField(
                            onSaved: (value) {
                              widget.classDescription = value!;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter a class description',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a class description';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  print(widget.className);
                                  print(widget.classDescription);
                                  HttpService().addClass(widget.className,
                                      widget.classDescription);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Class added')));
                                }
                              },
                              child: const Text('Submit'),
                            )),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Delete Class",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700))),
                        Align(alignment: Alignment.centerLeft, child: Column(children: [
                          FutureBuilder(
                                future: HttpService().getCurrentUsersClasses(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ClassesDTO>?> snapshot) {
                                  if (snapshot.hasData) {
                                    List<ClassesDTO> classes = snapshot.data!;
                                    selectedClass = classes[0];
                                    return Align(alignment: Alignment.centerLeft, child: CustomDropdown(
                                        title: "Class To Delete",
                                        items:
                                            classes.map((e) => e.name).toList(),
                                        selectedItem: selectedClass.name,
                                        onChanged: (String newValue) {
                                          selectedClass = classes.firstWhere(
                                              (element) =>
                                                  element.name == newValue);
                                        }));
                                  } else {
                                    return CustomDropdown(
                                        title: "Class To Delete",
                                        items: const ["Loading..."],
                                        selectedItem: "Loading...",
                                        onChanged: (String newValue) {
                                          selectedClass =
                                              ClassesDTO(0, 0, "", "");
                                        });
                                  }
                                },
                              ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                HttpService()
                                    .deleteClass(selectedClass.classID);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Class Deleted')));
                              },
                              child: const Text('Delete Class'),
                            )
                          )
                        ]))
                      ]))),
                    ))));
  }
}
