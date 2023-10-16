import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/models/answer_models/answer_dto.dart';
import 'package:work_together_flutter/provider/meeting_time_list.dart';

import '../../global_components/tag.dart';
import '../../http_request.dart';
import '../../models/card_info_models/card_info.dart';
import '../../provider/skill_list.dart';
import '../group_search/group_search_page.dart';

enum ExpectedQuality { A, B, C }

class QuestionnairePage extends ConsumerStatefulWidget {
  const QuestionnairePage(
      {Key? key,
      required this.loggedUserId,
      required this.classId,
      required this.className,
      required this.projectId,
      required this.projectName})
      : super(key: key);

  final int loggedUserId;
  final int classId;
  final String className;
  final int projectId;
  final String projectName;

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  ExpectedQuality? _quality;
  CardInfo? loggedUser;

  var skillsTextFieldController = TextEditingController();
  var numberHoursTextFieldController = TextEditingController();

  var times;
  var cur;
  var skills;
  var concatenatedMeetingTimes;

  List<String> mornings = [];
  List<String> afternoons = [];
  List<String> evenings = [];

  final HttpService httpService = HttpService();

  late List<AnswerDTO> answers;

  late List<String> skillList;

  late List<MeetingTime> meetingTimeList;

  FocusNode skillsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await httpService
          .getQuestionnaireAnswers(widget.projectId)
          .then((loggedUserAnswers) => {
                answers = loggedUserAnswers,
                for (int i = 0; i < loggedUserAnswers.length; i++)
                  {
                    if (i == 0)
                      {
                        meetingTimeList.clear(),
                        times = loggedUserAnswers[i].answerText.split('`'),
                        for (var j = 0; j < times.length; j++)
                          {
                            cur = times[j].split(':'),
                            if (cur[0] == 'Morning')
                              {mornings = cur[1].split(',')}
                            else if (cur[0] == 'Afternoon')
                              {afternoons = cur[1].split(',')}
                            else if (cur[0] == 'Evening')
                              {evenings = cur[1].split(',')}
                          },
                        if (mornings.isNotEmpty)
                          {
                            meetingTimeList
                                .add(MeetingTime("Morning", mornings, "NA"))
                          },
                        if (afternoons.isNotEmpty)
                          {
                            meetingTimeList.add(
                                MeetingTime("Afternoon", afternoons, "NA")),
                          },
                        if (evenings.isNotEmpty)
                          {
                            meetingTimeList
                                .add(MeetingTime("Evening", evenings, "NA"))
                          }
                      }
                    else if (i == 1)
                      {
                        if (loggedUserAnswers[i].answerText == 'A')
                          {_quality = ExpectedQuality.A}
                        else if (loggedUserAnswers[i].answerText == 'B')
                          {_quality = ExpectedQuality.B}
                        else if (loggedUserAnswers[i].answerText == 'C')
                          {_quality = ExpectedQuality.C}
                      }
                    else if (i == 2)
                      {
                        skills = loggedUserAnswers[i].answerText.split(','),
                        skillList.clear(),
                        skillList.addAll(skills),
                      }
                    else if (i == 3)
                      {
                        numberHoursTextFieldController.text =
                            loggedUserAnswers[i].answerText,
                      }
                    else if (i == 4)
                      {
                        // Answer is not in use
                      }
                  }
              });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    skillList = ref.watch(skillListNotifierProvider);
    meetingTimeList = ref.watch(meetingTimeListNotifierProvider);

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
                                  child:
                                      const Icon(Icons.remove_circle_outline),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 2.0, 2.0, 4.0),
                        child: SizedBox(
                          width: 280,
                          height: 50,
                          child: TextFormField(
                            controller: skillsTextFieldController,
                            style: const TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansPro'),
                            keyboardType: TextInputType.emailAddress,
                            focusNode: skillsFocusNode,
                            onFieldSubmitted: (e) {
                              ref
                                  .read(skillListNotifierProvider.notifier)
                                  .addSkill(e);
                              skillsTextFieldController.clear();
                              skillsFocusNode.requestFocus();
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 4.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              setState(() {
                                ref
                                    .read(skillListNotifierProvider.notifier)
                                    .addSkill(skillsTextFieldController.text);
                                skillsTextFieldController.clear();
                                skillsFocusNode.requestFocus();
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Wrap(
                        children: [
                          ...skillList.map(
                            (skill) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                                child: Wrap(
                                  children: [
                                    Tag(text: skill.toString()),
                                    GestureDetector(
                                      child: const Icon(
                                          Icons.remove_circle_outline),
                                      onTap: () {
                                        setState(() {
                                          ref
                                              .read(skillListNotifierProvider)
                                              .remove(skill);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      )),
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
                        controller: numberHoursTextFieldController,
                        style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SourceSansPro'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSaved: (hours) {},
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                      child: ElevatedButton(
                        onPressed: () async => {
                          for (int i = 0; i < answers.length; i++)
                            {
                              if (i == 0)
                                {
                                  concatenatedMeetingTimes = "",
                                  for (int i = 0;
                                      i < meetingTimeList.length;
                                      i++)
                                    {
                                      if (meetingTimeList[i].timeOfDay ==
                                          "Morning")
                                        {
                                          concatenatedMeetingTimes +=
                                              "Morning:",
                                          concatenatedMeetingTimes +=
                                              meetingTimeList[i]
                                                  .daysOfWeek
                                                  .join(','),
                                          concatenatedMeetingTimes += '`'
                                        }
                                      else if (meetingTimeList[i].timeOfDay ==
                                          "Afternoon")
                                        {
                                          concatenatedMeetingTimes +=
                                              "Afternoon:",
                                          concatenatedMeetingTimes +=
                                              meetingTimeList[i]
                                                  .daysOfWeek
                                                  .join(','),
                                          concatenatedMeetingTimes += '`'
                                        }
                                      else if (meetingTimeList[i].timeOfDay ==
                                          "Evening")
                                        {
                                          concatenatedMeetingTimes +=
                                              "Evening:",
                                          concatenatedMeetingTimes +=
                                              meetingTimeList[i]
                                                  .daysOfWeek
                                                  .join(','),
                                          concatenatedMeetingTimes += '`'
                                        }
                                    },
                                  answers[i].answerText =
                                      concatenatedMeetingTimes
                                }
                              else if (i == 1)
                                {
                                  if (_quality == ExpectedQuality.A)
                                    {answers[i].answerText = "A"}
                                  else if (_quality == ExpectedQuality.B)
                                    {answers[i].answerText = "B"}
                                  else if (_quality == ExpectedQuality.C)
                                    {answers[i].answerText = "C"}
                                }
                              else if (i == 2)
                                {answers[i].answerText = skillList.join(',')}
                              else if (i == 3)
                                {
                                  answers[i].answerText =
                                      numberHoursTextFieldController.text
                                }
                              else if (i == 4)
                                {
                                  // Answer is not in use
                                }
                            },
                          await httpService
                              .putQuestionnaireAnswers(
                                  widget.projectId, answers)
                              .then((loggedUserAnswers) => {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return GroupSearchPage(
                                            userId: widget.loggedUserId,
                                            classId: widget.classId,
                                            className: widget.className,
                                            projectId: widget.projectId,
                                            projectName: widget.projectName);
                                      },
                                    ))
                                  })
                        },
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
            ),
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
  final List<String> daysOfWeek = ['M', 'T', 'W', 'Th', 'F', 'Sa', 'Su'];

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
