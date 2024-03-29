import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/pages/login/login_page.dart';
import 'package:work_together_flutter/pages/profile/edit_profile_page.dart';
import 'package:work_together_flutter/provider/interest_list.dart';

import '../../http_request.dart';
import '../../models/user_models/user.dart';
import '../../provider/filter_choices.dart';
import '../../provider/meeting_time_list.dart';
import '../../provider/skill_list.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late List<String> skillList = ref.watch(skillListNotifierProvider);
  late List<String> interestsList = ref.watch(interestListNotifierProvider);
  late List<MeetingTime> meetingTimeList =
      ref.watch(meetingTimeListNotifierProvider);
  late FilterChoices filterChoices = ref.watch(filterChoicesNotifierProvider);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService.getUser(loggedUserId),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("An error has occurred while loading page."),
              ],
            );
          } else if (snapshot.hasData) {
            User u = snapshot.data!;

            return buildPage(context, u);
          }
          return const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          );
        });
  }

  Widget buildPage(BuildContext context, User userdata) {
    List<Widget> interestTags = [];

    for (String interest in userdata.interests) {
      if (interest != "") {
        interestTags.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0),
          child: Tag(
            text: interest,
          ),
        ));
      }
    }

    return Scaffold(
        appBar: const CustomAppBar(title: "User Profile"),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  color: ourLightPrimaryColor(),
                  size: 110.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    userdata.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Bio:",
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Text(
                        userdata.bio,
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Major:",
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Text(
                        userdata.major,
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Student Status:",
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Row(
                        children: [
                          Tag(
                            text: userdata.studentStatus,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Employment Status:",
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Row(
                        children: [
                          Tag(
                            text: userdata.employmentStatus,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                      child: Text(
                        "Interests:",
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'SourceSansPro'),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                        child: Wrap(
                          children: interestTags,
                        )),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          onPressed: () async {
                            skillList.clear();
                            interestsList.clear();
                            meetingTimeList.clear();
                            filterChoices.resetFilterFields();
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          heroTag: "Edit Page",
                          child: const Icon(
                            Icons.logout_outlined,
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 32, 16),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation1,
                                    Animation<double> animation2) {
                                  return EditProfilePage(user: userdata);
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            ).whenComplete(() => setState(() => {}));
                          },
                          child: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )),
                ]),
              ],
            ),
          ),
        ));
  }
}
