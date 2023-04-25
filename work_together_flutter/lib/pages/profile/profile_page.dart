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

    return FutureBuilder<User?>(
        future: httpService.getUser(),
        builder: (context, snapshot) {
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    child: Text(
                      "B.S. Computer Science",
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'SourceSansPro'),
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
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Tag(text: "Camping"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: Tag(
                              text: "Hiking",
                            ),
                          ),
                        ],
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
    print("getting users");
    Uri uri = Uri.https('localhost:7277', 'api/Users/studentsbyclassID/1');
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
      List<dynamic> body = jsonDecode(res.body);

      List<User> users = body
          .map(
            (dynamic item) => User.fromJson(item),
          )
          .toList();

      return users.first;
    } else {
      throw "Unable to retrieve posts.";
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
  final String interests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.employmentStatus,
    required this.studentStatus,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,
      bio: json["bio"] as String,
      employmentStatus: json["employmentStatus"] as String,
      studentStatus: json["studentStatus"],
      interests: json["interests"] as String,
    );
  }
}
