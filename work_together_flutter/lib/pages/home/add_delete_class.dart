import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';

import '../../global_components/custom_app_bar.dart';
import '../../global_components/date_time_converter.dart';
import '../../http_request.dart';
import '../../models/classes_models/classes_dto.dart';
import '../professor_dashboard/project_edit_page.dart';

class AddDeleteClass extends StatefulWidget {
  AddDeleteClass({Key? key}) : super(key: key);

  String className = "";
  String classDescription = "";
  String projectName = "";
  String projectDescription = "";
  String projectDeadline = "";
  String formationDeadline = "";
  String minTeamSize = "";
  String maxTeamSize = "";

  @override
  _AddDeleteClassState createState() => _AddDeleteClassState();
}

class _AddDeleteClassState extends State<AddDeleteClass> {
  final _formKey = GlobalKey<FormState>();
  ClassesDTO selectedClass = ClassesDTO(0, 0, "", "");
  TextEditingController className = TextEditingController();
  TextEditingController classDescription = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController projectDescription = TextEditingController();
  TextEditingController projectDeadline = TextEditingController();
  TextEditingController formationDeadline = TextEditingController();
  TextEditingController minTeamSize = TextEditingController();
  TextEditingController maxTeamSize = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Manage Project"),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
          width: 675,
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Add Class",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700))),
                    TextFormField(
                        onSaved: (value) {
                          widget.className = value!;
                        },
                        controller: className,
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
                        controller: classDescription,
                        decoration: const InputDecoration(
                          hintText: 'Enter a class description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a class description';
                          }
                          return null;
                        }),
                    TextFormField(
                        onSaved: (value) {
                          widget.projectName = value!;
                        },
                        controller: projectName,
                        decoration: const InputDecoration(
                          hintText: 'Enter a project name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project name';
                          }
                          return null;
                        }),
                    TextFormField(
                        onSaved: (value) {
                          widget.projectDescription = value!;
                        },
                        controller: projectDescription,
                        decoration: const InputDecoration(
                          hintText: 'Enter a project description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project description';
                          }
                          return null;
                        }),
                    TextFormField(
                        onSaved: (value) {
                          widget.minTeamSize = value!;
                        },
                        controller: minTeamSize,
                        decoration: const InputDecoration(
                          hintText: 'Enter min team size',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter min team size';
                          }
                          return null;
                        }),
                    TextFormField(
                        onSaved: (value) {
                          widget.maxTeamSize = value!;
                        },
                        controller: maxTeamSize,
                        decoration: const InputDecoration(
                          hintText: 'Enter max team size',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter max team size';
                          }
                          return null;
                        }),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter Team Formation Deadline",
                        icon: Icon(Icons.calendar_today),
                      ),
                      onSaved: (value) {
                        widget.formationDeadline = value!;
                      },
                      controller: formationDeadline,
                      readOnly: true,
                      onTap: () async {
                        DateTime initialDate = DateTime.now();
                        initialDate = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat.yMd().format(pickedDate);
                          setState(() {
                            formationDeadline.text = formattedDate;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter Project Deadline",
                        icon: Icon(Icons.calendar_today),
                      ),
                      onSaved: (value) {
                        widget.projectDeadline = value!;
                      },
                      controller: projectDeadline,
                      readOnly: true,
                      onTap: () async {
                        DateTime initialDate = DateTime.now();
                        initialDate = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat.yMd().format(pickedDate);
                          setState(() {
                            projectDeadline.text = formattedDate;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ourLightColor()),
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              HttpService().addClass(
                                  widget.className, widget.classDescription,
                                  widget.projectName, widget.projectDescription,
                                  widget.projectDeadline, widget.formationDeadline,
                                  widget.minTeamSize, widget.maxTeamSize);

                              setState(() {
                                className.clear();
                                classDescription.clear();
                                projectName.clear();
                                projectDescription.clear();
                                projectDeadline.clear();
                                formationDeadline.clear();
                                minTeamSize.clear();
                                maxTeamSize.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Class added')));
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.black),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Delete Class",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700))),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          FutureBuilder(
                            future: HttpService().getCurrentUsersClasses(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ClassesDTO>?> snapshot) {
                              if (snapshot.hasData) {
                                List<ClassesDTO> classes = snapshot.data!;
                                selectedClass = classes[0];
                                return Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomDropdown(
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
                                      selectedClass = ClassesDTO(0, 0, "", "");
                                    });
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ourLightColor()),
                                onPressed: () {
                                  HttpService()
                                      .deleteClass(selectedClass.classID);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Class Deleted')));
                                },
                                child: const Text(
                                  'Delete Class',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ]))
                  ]))),
        ))));
  }
}
