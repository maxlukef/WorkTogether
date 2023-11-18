import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/group_home/group_home.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpService.getCurrentUserProjectsAndClasses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
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
                    ...classesToProjects.keys.map((classNameKey) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  elevation: 10,
                                  color: const Color(0xFFf2f2f2),
                                  clipBehavior: Clip.hardEdge,
                                  child: LimitedBox(
                                    maxWidth: 360,
                                    maxHeight: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          32.0, 16.0, 32.0, 16.0),
                                      child: Text(
                                        classNameKey,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                                'SourceSansPro-SemiBold'),
                                      ),
                                    ),
                                  ),
                                ),
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
                            } else if (projectNameValue.teamFormationDeadline
                                    .isBefore(DateTime.now()) &&
                                projectNameValue.deadline
                                    .isBefore(DateTime.now())) {
                              projectPhase = "Project Complete";
                            } else {
                              projectPhase = "Project In Progress";
                            }

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  50.0, 0.0, 0.0, 0.0),
                              child: Card(
                                elevation: 10,
                                color: const Color(0xFFf2f2f2),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () async {
                                    await httpService.getClassByID(projectNameValue.classId).then((value) async {
                                      if (value != null &&
                                          loggedUserId == value.professorID) {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                          builder: (context) {
                                            return Dashboard(
                                                projectId: projectNameValue.id,
                                                projectName: projectNameValue
                                                    .name,
                                                classId: projectNameValue
                                                    .classId);
                                          },
                                        ));
                                      }
                                      else
                                      if (projectNameValue.teamFormationDeadline
                                          .isAfter(DateTime.now())) {
                                        await httpService
                                            .getProjectAnswers(
                                            projectNameValue.id)
                                            .then((value) =>
                                        {
                                          if (value.isNotEmpty)
                                            {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder:
                                                      (BuildContext
                                                  context,
                                                      Animation<
                                                          double>
                                                      animation1,
                                                      Animation<
                                                          double>
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
                                              )
                                            }
                                          else
                                            {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder:
                                                      (BuildContext
                                                  context,
                                                      Animation<
                                                          double>
                                                      animation1,
                                                      Animation<
                                                          double>
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
                                              )
                                            }
                                        });
                                      } else {
                                        Navigator.push(
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
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    width: 300,
                                    height: 260,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 15.0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                4.0, 4.0, 4.0, 0.0),
                                            child: Text(
                                              'Project:',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'SourceSansPro-SemiBold',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4.0, 4.0, 4.0, 0.0),
                                            child: Text(
                                              projectNameValue.name,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'SourceSansPro-SemiBold',
                                              ),
                                            ),
                                          ),
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 4.0, 0.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                ),
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
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                4.0, 8.0, 4.0, 0.0),
                                            child: Text(
                                              'Team Formation Deadline:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'SourceSansPro',
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                "${projectNameValue.teamFormationDeadline.year}/${projectNameValue.teamFormationDeadline.month}/${projectNameValue.teamFormationDeadline.day}",
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        'SourceSansPro'),
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
                    })
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
