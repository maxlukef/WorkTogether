import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/card_info.dart';

enum StudentStatus { fullTime, partTime, notApplicable }

enum EmploymentStatus { employed, unemployed, notApplicable }

class GroupSearchPage extends ConsumerStatefulWidget {
  const GroupSearchPage({
    Key? key,
    required this.userId,
    required this.classId,
  }) : super(key: key);

  final int userId;
  final int classId;

  @override
  ConsumerState<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends ConsumerState<GroupSearchPage> {
  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() => {});
    }

    final HttpService httpService = HttpService();

    List<CardInfo>? teamMates = [];
    List<CardInfo>? users = [];

    return Scaffold(
        appBar: const CustomAppBar(title: "Group Search"),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
            child: Column(children: [
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 5, top: 15, bottom: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("CS4400",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700)))),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 15, top: 15, bottom: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: const Icon(Icons.filter_alt_outlined),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const GroupSearchFilter(),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
              future: httpService.getTeam(widget.classId, widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CardInfo>> snapshot) {
                if (snapshot.hasData) {
                  teamMates = snapshot.data;
                }

                if (teamMates!.isNotEmpty) {
                  return Column(children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("My Team",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700)),
                        )),
                    MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                        itemCount: teamMates?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return StudentCard(
                            id: teamMates![index].id,
                            fullName: teamMates![index].name,
                            major: teamMates![index].major,
                            availableMornings:
                                teamMates![index].availableMornings,
                            availableAfternoons:
                                teamMates![index].availableAfternoons,
                            availableEvenings:
                                teamMates![index].availableEvenings,
                            skills: teamMates![index].skills,
                            expectedGrade: teamMates![index].expectedGrade,
                            weeklyHours: teamMates![index].weeklyHours,
                            interests: teamMates![index].interests,
                            notifyParent: refresh,
                          );
                        }),
                    const Padding(
                        padding: EdgeInsets.only(
                            left: 5, top: 5, bottom: 5, right: 5),
                        child: Divider(color: Colors.black)),
                  ]);
                }

                return const SizedBox.shrink();
              }),
          FutureBuilder(
              future: httpService.getUsers(widget.classId, widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CardInfo>> snapshot) {
                if (snapshot.hasData) {
                  users = snapshot.data;
                }

                return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    itemCount: users?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return StudentCard(
                        id: users![index].id,
                        fullName: users![index].name,
                        major: users![index].major,
                        availableMornings: users![index].availableMornings,
                        availableAfternoons: users![index].availableAfternoons,
                        availableEvenings: users![index].availableEvenings,
                        skills: users![index].skills,
                        expectedGrade: users![index].expectedGrade,
                        weeklyHours: users![index].weeklyHours,
                        interests: users![index].interests,
                        notifyParent: refresh,
                      );
                    });
              })
        ])));
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.blue,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class GroupSearchFilter extends ConsumerStatefulWidget {
  const GroupSearchFilter({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<GroupSearchFilter> createState() => _GroupSearchFilterState();
}

class _GroupSearchFilterState extends ConsumerState<GroupSearchFilter> {
  StudentStatus? _studentStatus = StudentStatus.notApplicable;
  EmploymentStatus? _employmentStatus = EmploymentStatus.notApplicable;
  bool isFilterByMeetingTimeChecked = false;

  var skillsFilterTextFieldController = TextEditingController();
  var interestsFilterTextFieldController = TextEditingController();
  var numberHoursFilterTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Filter By Meeting Times:",
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
                padding: const EdgeInsets.fromLTRB(40.0, 16.0, 2.0, 16.0),
                child: Checkbox(
                  checkColor: Colors.white,
                  // fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isFilterByMeetingTimeChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isFilterByMeetingTimeChecked = value!;
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(2.0, 16.0, 32.0, 16.0),
                child: Text(
                  "Filter by students with overlapping meeting times",
                  style: TextStyle(
                      fontSize: 14,
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
                  "Filter By Skills:",
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
                    controller: skillsFilterTextFieldController,
                    style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSaved: (e) {},
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFAFAFA),
                        hintText: "Type to add a skill to filter by",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFD9D9D9), width: 2.0))),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Filter By Interests:",
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
                    controller: interestsFilterTextFieldController,
                    style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSaved: (e) {},
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFAFAFA),
                        hintText: "Type to add an interest to filter by",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFD9D9D9), width: 2.0))),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Filter By Expected Hours:",
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
                    controller: numberHoursFilterTextFieldController,
                    style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SourceSansPro'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSaved: (e) {},
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFAFAFA),
                        hintText: "Type to filter by number of hours",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFD9D9D9), width: 2.0))),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Filter By Student Status:",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                            value: StudentStatus.notApplicable,
                            groupValue: _studentStatus,
                            onChanged: (StudentStatus? value) {
                              setState(() {
                                _studentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                              child: Text(
                            'N/A',
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'SourceSansPro'),
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                            value: StudentStatus.fullTime,
                            groupValue: _studentStatus,
                            onChanged: (StudentStatus? value) {
                              setState(() {
                                _studentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Full Time Student',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'SourceSansPro'),
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
                            value: StudentStatus.partTime,
                            groupValue: _studentStatus,
                            onChanged: (StudentStatus? value) {
                              setState(() {
                                _studentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                              child: Text(
                            'Part Time Student',
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'SourceSansPro'),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Filter By Employment Status:",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                            value: EmploymentStatus.notApplicable,
                            groupValue: _employmentStatus,
                            onChanged: (EmploymentStatus? value) {
                              setState(() {
                                _employmentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                              child: Text(
                            'N/A',
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'SourceSansPro'),
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Radio(
                            value: EmploymentStatus.employed,
                            groupValue: _employmentStatus,
                            onChanged: (EmploymentStatus? value) {
                              setState(() {
                                _employmentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Employed',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'SourceSansPro'),
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
                            value: EmploymentStatus.unemployed,
                            groupValue: _employmentStatus,
                            onChanged: (EmploymentStatus? value) {
                              setState(() {
                                _employmentStatus = value;
                              });
                            },
                          ),
                          const Expanded(
                              child: Text(
                            'Unemployed',
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'SourceSansPro'),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32.0, 0, 32.0),
                child: ElevatedButton(
                  onPressed: () => {Navigator.pop(context)},
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
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
