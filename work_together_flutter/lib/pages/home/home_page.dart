import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/pages/group_home/group_home.dart';
import 'package:work_together_flutter/pages/home/add_delete_class.dart';
import 'package:work_together_flutter/pages/questionnaire/questionnaire.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../main.dart';
import '../../models/project_models/project_in_class.dart';
import '../group_search/group_search_page.dart';
import '../professor_dashboard/dashboard.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final HttpService httpService = HttpService();
  final courseJoinTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpService.getCurrentUserProjectsAndClasses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("An error has occurred while loading page."),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            List<ProjectInClass> classesAndProjects = snapshot.data!;

            // Hashmap of class names to a list of projects
            final Map<String, List<ProjectInClass>> classesToProjects =
                HashMap();

            for (ProjectInClass classesAndProject in classesAndProjects) {
              classesToProjects.putIfAbsent(
                  classesAndProject.className, () => <ProjectInClass>[]);
              classesToProjects[classesAndProject.className]
                  ?.add(classesAndProject);
            }

            return buildPage(context, classesToProjects);
          }
          return const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          );
        });
  }

  Widget buildPage(BuildContext context,
      Map<String, List<ProjectInClass>> classesToProjects) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Classes & Projects"),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 675,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: TextFormField(
                              controller: courseJoinTextController,
                              style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SourceSansPro'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (hours) async {
                                if (await HttpService().joinClassWithCode(
                                    courseJoinTextController.text)) {
                                  setState(() {
                                    courseJoinTextController.text = "";
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFFAFAFA),
                                  hintText: "Type code to join class",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFD9D9D9),
                                          width: 2.0))),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 4.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: ourLightColor()),
                              onPressed: () async {
                                if (await HttpService().joinClassWithCode(
                                    courseJoinTextController.text)) {
                                  setState(() {
                                    courseJoinTextController.text = "";
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ourLightColor()),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation1,
                                    Animation<double> animation2) {
                                  return AddDeleteClass();
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );

                            setState(() {});
                          },
                          child: const Text(
                            "Add/Delete Class",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    ...classesToProjects.keys.map((classNameKey) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 15, bottom: 20),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(classNameKey,
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700)))),
                              ),
                            ],
                          ),
                          ...?classesToProjects[classNameKey]
                              ?.map((projectNameValue) {
                            String projectPhase = "";

                            if (projectNameValue.teamFormationDeadline
                                    .isAfter(DateTime.now()) &&
                                projectNameValue.deadline
                                    .isAfter(DateTime.now())) {
                              projectPhase = "Team Formation";
                            } else if (projectNameValue.deadline
                                    .isBefore(DateTime.now()) &&
                                projectNameValue.deadline
                                    .isBefore(DateTime.now())) {
                              projectPhase = "Project Complete";
                            } else {
                              projectPhase = "Project In Progress";
                            }

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 20.0),
                              child: Card(
                                elevation: 10,
                                color: const Color(0xFFf2f2f2),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () async {
                                    await httpService
                                        .getClassByID(projectNameValue.classId)
                                        .then((value) async {
                                      if (value != null &&
                                          loggedUserId == value.professorID) {
                                        await Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return Dashboard(
                                                projectId: projectNameValue.id,
                                                projectName:
                                                    projectNameValue.name,
                                                classId:
                                                    projectNameValue.classId);
                                          },
                                        ));
                                        setState(() {});
                                      } else if (projectNameValue
                                          .teamFormationDeadline
                                          .isAfter(DateTime.now())) {
                                        await httpService
                                            .getProjectAnswers(
                                                projectNameValue.id)
                                            .then((value) async => {
                                                  if (value.isNotEmpty)
                                                    {
                                                      await Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (BuildContext
                                                                  context,
                                                              Animation<double>
                                                                  animation1,
                                                              Animation<double>
                                                                  animation2) {
                                                            return GroupSearchPage(
                                                                userId:
                                                                    loggedUserId,
                                                                classId:
                                                                    projectNameValue
                                                                        .classId,
                                                                className:
                                                                    projectNameValue
                                                                        .className,
                                                                projectId:
                                                                    projectNameValue
                                                                        .id,
                                                                projectName:
                                                                    projectNameValue
                                                                        .name);
                                                          },
                                                          transitionDuration:
                                                              Duration.zero,
                                                          reverseTransitionDuration:
                                                              Duration.zero,
                                                        ),
                                                      ),
                                                      setState(() {})
                                                    }
                                                  else
                                                    {
                                                      await Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (BuildContext
                                                                  context,
                                                              Animation<double>
                                                                  animation1,
                                                              Animation<double>
                                                                  animation2) {
                                                            return QuestionnairePage(
                                                              loggedUserId:
                                                                  loggedUserId,
                                                              classId:
                                                                  projectNameValue
                                                                      .classId,
                                                              className:
                                                                  projectNameValue
                                                                      .className,
                                                              projectId:
                                                                  projectNameValue
                                                                      .id,
                                                              projectName:
                                                                  projectNameValue
                                                                      .name,
                                                            );
                                                          },
                                                          transitionDuration:
                                                              Duration.zero,
                                                          reverseTransitionDuration:
                                                              Duration.zero,
                                                        ),
                                                      ),
                                                      setState(() {})
                                                    }
                                                });
                                      } else {
                                        await Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation1,
                                                Animation<double> animation2) {
                                              return GroupHome(
                                                project: projectNameValue,
                                              );
                                            },
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                        setState(() {});
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    width: 675,
                                    height: 260,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0, 0.0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 675,
                                            height: 100,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color:
                                                      ourLightPrimaryColor()),
                                            ),
                                          ),
                                          // const Padding(
                                          //   padding: EdgeInsets.fromLTRB(
                                          //       4.0, 4.0, 4.0, 0.0),
                                          //   child: Text(
                                          //     'Project:',
                                          //     style: TextStyle(
                                          //       fontSize: 24,
                                          //       fontWeight: FontWeight.w400,
                                          //       fontFamily:
                                          //           'SourceSansPro-SemiBold',
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4.0, 15.0, 4.0, 0.0),
                                            child: Text(
                                              "Project: ${projectNameValue.name}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'SourceSansPro-SemiBold',
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    4.0, 4.0, 4.0, 0.0),
                                                child: Text(
                                                  'Deadline:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'SourceSansPro',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4.0, 8.0, 4.0, 0.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${projectNameValue.deadline.year}/${projectNameValue.deadline.month}/${projectNameValue.deadline.day}",
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'SourceSansPro'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    4.0, 8.0, 4.0, 0.0),
                                                child: Text(
                                                  "Phase:",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'SourceSansPro',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4.0, 8.0, 4.0, 0.0),
                                                child: Text(
                                                  projectPhase,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SourceSansPro',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      );
                    }),
                    const SizedBox(height: 50),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
