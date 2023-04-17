import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:work_together_flutter/tab_navigations/components/pages.dart';
import 'package:work_together_flutter/tab_navigations/tab_navigator.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Text(
                    "Add Available Meeting Times",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro-Regular'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(330, 50),
                      backgroundColor: const Color(0xFF7AC8F5)),
                  child: const Text(
                    "+ Add A Time",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'SourceSansPro-Regular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Text(
                    "Expected Project Quality",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro-Regular'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Text(
                    "Relevant Skills",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro-Regular'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: TextFormField(
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSansPro-Regular'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (email) {},
                      decoration: const InputDecoration(
                          fillColor: Color(0xFFFAFAFA),
                          hintText: "Type to Add a Skill",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9), width: 5.0))),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Text(
                    "Expected Hours Weekly",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro-Regular'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: TextFormField(
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSansPro-Regular'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (email) {},
                      decoration: const InputDecoration(
                          fillColor: Color(0xFFFAFAFA),
                          hintText: "Type to Add Number of Hours",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9), width: 5.0))),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Text(
                    "Additional Notes",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro-Regular'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: TextFormField(
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSansPro-Regular'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (email) {},
                      decoration: const InputDecoration(
                          fillColor: Color(0xFFFAFAFA),
                          hintText: "Roadblocks, circumstances, or other notes",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9), width: 5.0))),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(330, 50),
                      backgroundColor: const Color(0xFF7AC8F5)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'SourceSansPro-Regular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
