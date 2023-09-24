import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/group_home/group_home.dart';
import 'package:work_together_flutter/pages/questionnaire/questionnaire.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../main.dart';
import '../../models/project_models/project_in_class.dart';

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

            print(classesAndProjects.length);

            // Hashmap of class names to a list of projects
            final Map<String, List<ProjectInClass>> classesToProjects =
                HashMap();

            for (ProjectInClass classesAndProject in classesAndProjects) {
              // print(classesAndProject.name);
              classesToProjects.putIfAbsent(
                  classesAndProject.className, () => <ProjectInClass>[]);
              classesToProjects[classesAndProject.className]
                  ?.add(classesAndProject);
            }

            classesToProjects.forEach((key, value) {
              value.forEach((element) {
                print(element.name);
              });
            });

            return buildPage(context, classesToProjects);
          }
          return const CircularProgressIndicator();
        });

    // return Scaffold(
    //     appBar: const CustomAppBar(title: "Home"),
    //     backgroundColor: const Color(0xFFFFFFFF),
    //     body: FutureBuilder<List<ClassesDTO>?>(
    //         future: httpService.getCurrentUsersClasses(),
    //         builder: (BuildContext context,
    //             AsyncSnapshot<List<ClassesDTO>?> snapshot) {
    //           return Column();
    //         }));
  }

  Widget buildPage(BuildContext context,
      Map<String, List<ProjectInClass>> classesToProjects) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Classes & Projects"),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
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
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
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
                                        fontFamily: 'SourceSansPro-SemiBold'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...?classesToProjects[classNameKey]
                          ?.map((projectNameValue) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                if (projectNameValue.teamFormationDeadline
                                    .isAfter(DateTime.now())) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return QuestionnairePage(
                                          classId: projectNameValue.classId,
                                          userId: loggedUserId);
                                    },
                                  ));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const GroupHome(
                                        groupName: 'Task Force 141',
                                      );
                                    },
                                  ));
                                }
                              },
                              child: SizedBox(
                                width: 300,
                                height: 230,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0, 15.0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                Icons.calendar_month_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              "${projectNameValue.deadline.year}/${projectNameValue.deadline.month}/${projectNameValue.deadline.day}",
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SourceSansPro'),
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
                                                fontFamily: 'SourceSansPro'),
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
    );
  }
}
