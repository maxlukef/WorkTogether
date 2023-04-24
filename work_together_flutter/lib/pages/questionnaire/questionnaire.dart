import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/models/meeting_time_list.dart';

import '../../global_components/tag.dart';
import '../../models/tag_list.dart';

enum ExpectedQuality { top1, A, B, C }

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
    List<MeetingTime> meetingTimeList =
        ref.watch(meetingTimeListNotifierProvider);

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
                  ...meetingTimeList.map(
                    (meetingTime) {
                      IconData? selectedTime;

                      switch (meetingTime.timeOfDay) {
                        case "Morning":
                          selectedTime = Icons.alarm;
                          break;
                        case "Afternoon":
                          selectedTime = Icons.sunny;
                          break;
                        case "Evening":
                          selectedTime = Icons.mode_night;
                          break;
                      }

                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF7AC8F5))),
                        child: SizedBox(
                          width: 330,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(selectedTime),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(meetingTime.timeOfDay),
                              ),
                              const Spacer(),
                              Row(
                                children: meetingTime.daysOfWeek
                                    .map((day) => Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFF11DC5C),
                                                      width: 2)),
                                              child: Text(
                                                day,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'SourceSansPro',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )),
                                        ))
                                    .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: const Icon(Icons.delete_outline),
                                  onTap: () {
                                    ref
                                        .read(meetingTimeListNotifierProvider
                                            .notifier)
                                        .removeMeetingTime(meetingTimeList
                                            .indexOf(meetingTime));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
  final List<String> daysOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  String? _timeOfDay = "Morning";
  List<String>? _selectedDaysOfWeek = [];
  String? note;

  @override
  Widget build(BuildContext context) {
    List<MeetingTime> meetingTimeList =
        ref.watch(meetingTimeListNotifierProvider);

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
                      value: "Morning",
                      groupValue: _timeOfDay,
                      onChanged: (String? value) {
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
                      value: "Afternoon",
                      groupValue: _timeOfDay,
                      onChanged: (String? value) {
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
                      value: "Evening",
                      groupValue: _timeOfDay,
                      onChanged: (String? value) {
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
            children: daysOfWeek.map(
              (day) {
                bool isSelected = false;
                if (_selectedDaysOfWeek!.contains(day)) {
                  isSelected = true;
                }
                return GestureDetector(
                  onTap: () {
                    if (!_selectedDaysOfWeek!.contains(day)) {
                      _selectedDaysOfWeek!.add(day);
                      setState(() {});
                    } else {
                      _selectedDaysOfWeek!
                          .removeWhere((element) => element == day);
                      setState(() {});
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF11DC5C)
                                    : Colors.grey,
                                width: 2)),
                        child: Text(
                          day,
                          style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF11DC5C)
                                  : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'SourceSansPro'),
                        ),
                      )),
                );
              },
            ).toList(),
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
                    onSaved: (e) {
                      note = e;
                    },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFAFAFA),
                        hintText: "Type to Add a note",
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
                  onPressed: () => {
                    ref
                        .read(meetingTimeListNotifierProvider.notifier)
                        .addMeetingTime(MeetingTime(
                            _timeOfDay!, _selectedDaysOfWeek!, note)),
                    Navigator.pop(context)
                  },
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
