import 'package:flutter/material.dart';

enum ExpectedQuality { top1, A, B, C }

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  ExpectedQuality? _quality = ExpectedQuality.top1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Add Available Meeting Times",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                      ),
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
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Expected Project Quality",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: ExpectedQuality.top1,
                                  groupValue: _quality,
                                  onChanged: (ExpectedQuality? value) {
                                    setState(() {
                                      _quality = value;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'Top 1%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'SourceSansPro'),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: ExpectedQuality.A,
                                  groupValue: _quality,
                                  onChanged: (ExpectedQuality? value) {
                                    setState(() {
                                      _quality = value;
                                    });
                                  },
                                ),
                                const Expanded(
                                    child: Text(
                                  'A',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SourceSansPro'),
                                ))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: ExpectedQuality.B,
                                  groupValue: _quality,
                                  onChanged: (ExpectedQuality? value) {
                                    setState(() {
                                      _quality = value;
                                    });
                                  },
                                ),
                                const Expanded(
                                    child: Text(
                                  'B',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SourceSansPro'),
                                ))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  value: ExpectedQuality.C,
                                  groupValue: _quality,
                                  onChanged: (ExpectedQuality? value) {
                                    setState(() {
                                      _quality = value;
                                    });
                                  },
                                ),
                                const Expanded(
                                    child: Text(
                                  'C',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SourceSansPro'),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Relevant Skills",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 330,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            hintText: "Type to Add a Skill",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2.0))),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Expected Hours Weekly",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 330,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            hintText: "Type to Add Number of Hours",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2.0))),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Additional Notes",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 330,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            hintText:
                                "Roadblocks, circumstances, or other notes",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2.0))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(330, 50),
                          backgroundColor: const Color(0xFF7AC8F5)),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
