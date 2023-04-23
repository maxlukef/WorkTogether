import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';

import '../../global_components/tag.dart';
import '../../models/tag_list.dart';

enum ExpectedQuality { top1, A, B, C }

enum TimeOfDay { morning, afternoon, evening }

class QuestionnairePage extends ConsumerStatefulWidget {
  const QuestionnairePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  ExpectedQuality? _quality = ExpectedQuality.top1;

  @override
  Widget build(BuildContext context) {
    var formController = TextEditingController();
    List<String> tagList = ref.watch(tagListNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: "Questionnaire"),
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
                    onPressed: () => {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const QuestionnairePopup())
                    },
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
                        controller: formController,
                        style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (e) {
                          ref.read(tagListNotifierProvider.notifier).addTag(e);
                          formController.clear();
                        },
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
                  Wrap(runSpacing: 12, children: [
                    ...tagList.map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tag(text: e.toString()),
                          GestureDetector(
                            child: const Icon(Icons.remove_circle_outline),
                            onTap: () {
                              int index = tagList.indexOf(e);
                              ref
                                  .read(tagListNotifierProvider.notifier)
                                  .removeTag(index);
                            },
                          )
                        ],
                      ),
                    ),
                  ]),
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
                            color: Color(0xFF000000),
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
                            color: Color(0xFF000000),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: const Color(0xFF7AC8F5)),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'SourceSansPro',
                            fontWeight: FontWeight.w400,
                          ),
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

class QuestionnairePopup extends ConsumerStatefulWidget {
  const QuestionnairePopup({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<QuestionnairePopup> createState() => _QuestionnairePopupState();
}

class _QuestionnairePopupState extends ConsumerState<QuestionnairePopup> {
  TimeOfDay? _timeOfDay = TimeOfDay.morning;

  @override
  Widget build(BuildContext context) {
    ExpectedQuality? timeOfDay = ExpectedQuality.top1;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 0.0),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(130.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Add Time",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Time of Day",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Radio(
                      value: TimeOfDay.morning,
                      groupValue: _timeOfDay,
                      onChanged: (TimeOfDay? value) {
                        setState(() {
                          _timeOfDay = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Morning',
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    const Icon(Icons.alarm),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Radio(
                      value: TimeOfDay.afternoon,
                      groupValue: _timeOfDay,
                      onChanged: (TimeOfDay? value) {
                        setState(() {
                          _timeOfDay = value;
                        });
                      },
                    ),
                    const Expanded(
                        child: Text(
                      'Afternoon',
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'SourceSansPro'),
                    )),
                    const Icon(Icons.sunny),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Radio(
                      value: TimeOfDay.evening,
                      groupValue: _timeOfDay,
                      onChanged: (TimeOfDay? value) {
                        setState(() {
                          _timeOfDay = value;
                        });
                      },
                    ),
                    const Expanded(
                        child: Text(
                      'Evening',
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'SourceSansPro'),
                    )),
                    const Icon(Icons.mode_night),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Days of the Week",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 0,
            runSpacing: 20,
            children: [
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "M",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Tu",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "W",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Th",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "F",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Sa",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: const Color(0xFFFAFAFA),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Su",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Additional Notes",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 2.0, 32.0, 4.0),
                child: SizedBox(
                  width: 330,
                  height: 50,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Color(0xFF000000),
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
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: const Color(0xFF7AC8F5)),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
