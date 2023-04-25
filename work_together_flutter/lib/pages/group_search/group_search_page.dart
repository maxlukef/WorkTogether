import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';

class GroupSearchPage extends StatelessWidget {
  const GroupSearchPage({
    Key? key, required this.userId, required this.classId,
  }) : super(key: key);

  final int userId;
  final int classId;

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    Image profilePic = Image.asset('images/sample_profile.jpg');
    List<CardInfo>? teamMates = [];
    List<CardInfo>? users = [];
    List<int>? teamIds = [];

    return SingleChildScrollView(child: Column(children: [
      const Padding(
          padding: EdgeInsets.only(left: 30, top: 15, bottom: 20),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("CS4480",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)))),
      FutureBuilder(
        future: httpService.getTeam(classId, userId),
        builder:
        (BuildContext context, AsyncSnapshot<List<CardInfo>> snapshot) {
          if (snapshot.hasData) {
            teamMates = snapshot.data;
          }

          if(teamMates!.isNotEmpty) {
            return Column(children: [MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                itemCount: teamMates?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StudentCard(
                    profilePic: profilePic,
                    fullName: teamMates![index].name,
                    major: teamMates![index].major,
                    availableMornings: teamMates![index].availableMornings,
                    availableAfternoons: teamMates![index].availableAfternoons,
                    availableEvenings: teamMates![index].availableEvenings,
                    skills: teamMates![index].skills,
                    expectedGrade: teamMates![index].expectedGrade,
                    weeklyHours: teamMates![index].weeklyHours,
                    interests: teamMates![index].interests,
                  );
                }
            ),
              const Divider(color: Colors.black),
            ]);
          }

          return const SizedBox.shrink();
        }
      ),

      FutureBuilder(
          future: httpService.getUsers(classId, userId),
          builder:
              (BuildContext context, AsyncSnapshot<List<CardInfo>> snapshot) {
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
                      profilePic: profilePic,
                      fullName: users![index].name,
                      major: users![index].major,
                      availableMornings: users![index].availableMornings,
                      availableAfternoons: users![index].availableAfternoons,
                      availableEvenings: users![index].availableEvenings,
                      skills: users![index].skills,
                      expectedGrade: users![index].expectedGrade,
                      weeklyHours: users![index].weeklyHours,
                      interests: users![index].interests,
                    );
                  }
            );
          })
    ]));
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

class HttpService {
  Future<List<CardInfo>> getUsers(classId, userId) async {
    Uri uri = Uri.https('localhost:7277', 'api/Users/studentsbyclassID/$classId');

    var res = await get(uri);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<User> users = body
          .map(
            (dynamic item) => User.fromJson(item),
          )
          .toList();

      List<CardInfo> cardInfo = [];
      List<int> teamIds = await getTeamIds(classId, userId);

      for (var i = 0; i < users.length; i++) {
        if(!teamIds.contains(users[i].id) && users[i].id != userId){
          Uri cardUri =
          Uri.https('localhost:7277', 'api/Answers/$classId/${users[i].id}');
          var cardRes = await get(cardUri);
          if (cardRes.statusCode == 200) {
            List<dynamic> cardBody = jsonDecode(cardRes.body);

            List<String> mornings = [];
            List<String> afternoons = [];
            List<String> evenings = [];
            List<String> skillsList = cardBody[2]["answerText"].split(',');
            String grade = cardBody[1]["answerText"];
            String hours = cardBody[3]["answerText"];

            var times = cardBody[0]["answerText"].split('`');

            for (var j = 0; j < times.length; j++) {
              var cur = times[j].split(':');
              if (cur[0] == 'Morning') {
                mornings = cur[1].split(',');
              } else if (cur[0] == 'Afternoon') {
                afternoons = cur[1].split(',');
              } else if (cur[0] == 'Evening') {
                evenings = cur[1].split(',');
              }
            }

            cardInfo.add(CardInfo(
                name: users[i].name,
                major: users[i].major,
                availableMornings: mornings,
                availableAfternoons: afternoons,
                availableEvenings: evenings,
                skills: skillsList,
                interests: users[i].interests,
                expectedGrade: grade,
                weeklyHours: hours));
          }
        }
      }

      return cardInfo;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<int>> getTeamIds(classId, userId) async {
    Uri uri = Uri.https('localhost:7277', 'api/Teams/ByStudentAndProject/$classId/$userId');
    var res = await get(uri);
    List<int> teamIds = [];
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode("[${res.body}]");

      for (var i = 0; i < body[0]["members"].length; i++) {
        teamIds.add(body[0]["members"][i]["id"]);
      }
    }

    return teamIds;
  }

  Future<List<CardInfo>> getTeam(classId, userId) async {
    Uri uri = Uri.https('localhost:7277', 'api/Teams/ByStudentAndProject/$classId/$userId');
    var res = await get(uri);
    List<CardInfo> teamMates = [];
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode("[${res.body}]");

      for(var i = 0; i < body[0]["members"].length; i++) {
        var curMember = body[0]["members"][i];
        if(curMember["id"] != userId) {
          Uri cardUri =
          Uri.https('localhost:7277', 'api/Answers/$classId/${curMember["id"]}');
          var cardRes = await get(cardUri);
          if (cardRes.statusCode == 200) {
            List<dynamic> cardBody = jsonDecode(cardRes.body);

            List<String> mornings = [];
            List<String> afternoons = [];
            List<String> evenings = [];
            List<String> skillsList = cardBody[2]["answerText"].split(',');
            String grade = cardBody[1]["answerText"];
            String hours = cardBody[3]["answerText"];

            var times = cardBody[0]["answerText"].split('`');

            for (var j = 0; j < times.length; j++) {
              var cur = times[j].split(':');
              if (cur[0] == 'Morning') {
                mornings = cur[1].split(',');
              } else if (cur[0] == 'Afternoon') {
                afternoons = cur[1].split(',');
              } else if (cur[0] == 'Evening') {
                evenings = cur[1].split(',');
              }
            }

            teamMates.add(CardInfo(
                name: curMember["name"],
                major: curMember["major"],
                availableMornings: mornings,
                availableAfternoons: afternoons,
                availableEvenings: evenings,
                skills: skillsList,
                interests: curMember["interests"].split(","),
                expectedGrade: grade,
                weeklyHours: hours));
          }
        }
      }
    }
    return teamMates;
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String bio;
  final String major;
  final String employmentStatus;
  final String studentStatus;
  final List<String> interests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.major,
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
      major: json["major"] as String,
      employmentStatus: json["employmentStatus"] as String,
      studentStatus: json["studentStatus"],
      interests: json["interests"].split(','),
    );
  }
}

class CardInfo {
  final String name;
  final String major;
  final List<String> availableMornings;
  final List<String> availableAfternoons;
  final List<String> availableEvenings;
  final List<String> skills;
  final List<String> interests;
  final String expectedGrade;
  final String weeklyHours;

  CardInfo(
      {required this.name,
      required this.major,
      required this.availableMornings,
      required this.availableAfternoons,
      required this.availableEvenings,
      required this.skills,
      required this.interests,
      required this.expectedGrade,
      required this.weeklyHours});
}
