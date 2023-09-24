import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/pages/group_home/group_home.dart';
import 'package:work_together_flutter/pages/questionnaire/questionnaire.dart';

import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../main.dart';
import '../../models/classes_models/classes_dto.dart';
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

            return buildPage(context, classesAndProjects);
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

  Widget buildPage(
      BuildContext context, List<ProjectInClass> classesAndProjects) {
    return Scaffold();
  }
}
