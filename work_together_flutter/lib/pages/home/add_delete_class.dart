import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/classes_models/classes_dto.dart';
import '../professor_dashboard/project_edit_page.dart';

class AddDeleteClass extends StatefulWidget {
  @override
  _AddDeleteClassState createState() => _AddDeleteClassState();
}

class _AddDeleteClassState extends State<AddDeleteClass> {

  final _formKey = GlobalKey<FormState>();
  String selectedClass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: CustomAppBar(title: "Manage Project"),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(width: 675, child: Padding(padding: EdgeInsets.only(left:20, right:20),
              child: Form(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Add Class", style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w700))),
                TextFormField(
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
                Align(alignment: Alignment.centerLeft, child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: const Text('Submit'),
                )),
                const SizedBox(height: 20),
                const Divider(color: Colors.black),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Delete Class", style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700))),
                Align(alignment: Alignment.centerLeft, child: Row(children: [FutureBuilder(
                  future: HttpService().getCurrentUsersClasses(),
                  builder: (BuildContext context, AsyncSnapshot<List<ClassesDTO>?> snapshot) {
                    if (snapshot.hasData) {
                      List<ClassesDTO> classes = snapshot.data!;
                      selectedClass = classes[0].name;
                      return CustomDropdown(
                          title: "New Group",
                          items: classes.map((e) => e.name).toList(),
                          selectedItem: selectedClass,
                          onChanged: (String newValue) {
                            selectedClass = newValue;
                          });
                    } else {
                      return CustomDropdown(
                          title: "New Group",
                          items: const ["Loading..."],
                          selectedItem: "Loading...",
                          onChanged: (String newValue) {
                            selectedClass = newValue;
                          }
                      );
                    }
                  },
                ),
                SizedBox(width: 20),
                Align(alignment: Alignment.center, child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: const Text('Delete Class'),
                ))
              ]
          )),
              ]
            )
          ))
        )
      ))
    );
  }
}