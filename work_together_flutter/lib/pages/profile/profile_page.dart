import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:work_together_flutter/global_components/custom_app_bar.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import 'package:work_together_flutter/pages/profile/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService.getUser(),
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
          return const CircularProgressIndicator();
        });
  }

  Widget buildPage(BuildContext context, User userdata) {
    List<Widget> interestTags = [];

    for (String interest in userdata.interests) {
      interestTags.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 4.0, 0),
        child: Tag(
          text: interest,
        ),
      ));
    }

    return Scaffold(
        appBar: CustomAppBar(title: userdata.name),
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const Icon(
                Icons.account_circle,
                color: Colors.blue,
                size: 110.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                    child: Text(
                      "Bio:",
                      style:
                          TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
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
                      style:
                          TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
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
                      style:
                          TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
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
                      style:
                          TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
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
                      style:
                          TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Row(
                        children: interestTags,
                      )),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 32, 16),
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const EditProfilePage();
                            },
                          ));
                        },
                        child: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ))
              ]),
            ],
          ),
        ));
  }
}

class HttpService {
  Future<User> getUser() async {
    print("getting user");
    Uri uri = Uri.https('localhost:7277', 'api/Users/profile/1');
    print(uri);

    try {
      Response res = await get(uri);
    } catch (e) {
      print(e.toString());
    }

    print(await get(uri));
    var res = await get(uri);

    print("status code");
    print(res.statusCode);

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User profile = User.fromJson(body);

      return profile;
    } else {
      throw "Unable to retrieve user.";
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String bio;
  final String employmentStatus;
  final String studentStatus;
  final List<String> interests;
  final String major;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.employmentStatus,
    required this.studentStatus,
    required this.interests,
    required this.major,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,
      bio: json["bio"] as String,
      employmentStatus: json["employmentStatus"] as String,
      studentStatus: json["studentStatus"],
      interests: json["interests"].split(','),
      major: json["major"] as String,
    );
  }
}
