import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class GroupSearchPage extends StatelessWidget {
  const GroupSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    Image profilePic = Image.asset('images/sample_profile.jpg');
    String major = "Computer Science";
    List<String> availableMornings = ['M', 'Tu', 'Th'];
    List<String> availableAfternoons = ['F', 'Sa'];
    List<String> availableEvenings = [];
    List<String> skills = ['Backend', 'Javascript', 'Python', 'Django'];
    String expectedGrade = "A";
    int weeklyHours = 10;
    List<User>? users = [];

    return FutureBuilder(
      future: httpService.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          users = snapshot.data;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text("CS4480", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
              MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              itemCount: users?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // return Tile(
                //   index: index,
                //   extent: (index % 5 + 1) * 100
                // );
                return StudentCard(
                  profilePic: profilePic,
                  fullName: users![index].name,
                  major: users![index].major,
                  availableMornings: availableMornings,
                  availableAfternoons: availableAfternoons,
                  availableEvenings: availableEvenings,
                  skills: skills,
                  expectedGrade: expectedGrade,
                  weeklyHours: weeklyHours,
                  interests: users![index].interests,
                );
              }),
              SizedBox(height: 10)
            ]
          )
        );


      }
    );
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
  Future<List<User>> getUsers() async {
    Uri uri = Uri.https('localhost:7277', 'api/Users/studentsbyclassID/1');

    try {
      Response res = await get(uri);
    } catch (e) {
      print(e.toString());
    }

    var res = await get(uri);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<User> users = body
      .map(
          (dynamic item) => User.fromJson(item),
      )
      .toList();

      return users;
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
  final int weeklyHours;

  CardInfo({
    required this.name,
    required this.major,
    required this.availableMornings,
    required this.availableAfternoons,
    required this.availableEvenings,
    required this.skills,
    required this.interests,
    required this.expectedGrade,
    required this.weeklyHours
  });
}