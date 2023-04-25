import 'dart:convert';

import 'package:http/http.dart';

import 'main.dart';
import 'models/card_info.dart';
import 'models/user.dart';

class HttpService {
  Future<User> getUser(userId) async {
    Uri uri = Uri.https('localhost:7277', 'api/Users/profile/$userId');

    Response res = await get(uri);

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      User profile = User.fromJson(body);
      return profile;
    } else {
      throw "Unable to retrieve user.";
    }
  }

  putUser(User user) async {
    Uri uri = Uri.https('localhost:7277', 'api/Users/profile/${user.id}');
    var body = user.toJson();
    try {
      await put(uri, body: body, headers: {"Content-Type": "application/json"});
    } catch (e) {
      print(e);
    }
  }

  Future<List<CardInfo>> getUsers(classId, userId) async {
    Uri uri =
        Uri.https('localhost:7277', 'api/Users/studentsbyclassID/$classId');

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
        if (!teamIds.contains(users[i].id) && users[i].id != loggedUserId) {
          Uri cardUri = Uri.https(
              'localhost:7277', 'api/Answers/$classId/${users[i].id}');
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
                id: users[i].id,
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
    Uri uri = Uri.https(
        'localhost:7277', 'api/Teams/ByStudentAndProject/$classId/$userId');
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
    Uri uri = Uri.https(
        'localhost:7277', 'api/Teams/ByStudentAndProject/$classId/$userId');
    var res;
    List<CardInfo> teamMates = [];
    try {
      res = await get(uri);
    } catch (e) {
      print(e);
      return teamMates;
    }

    if (res.statusCode == 404) {
      return teamMates;
    }
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode("[${res.body}]");

      for (var i = 0; i < body[0]["members"].length; i++) {
        var curMember = body[0]["members"][i];
        if (curMember["id"] != userId) {
          Uri cardUri = Uri.https(
              'localhost:7277', 'api/Answers/$classId/${curMember["id"]}');
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
                id: curMember["id"],
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

  inviteToTeam(int projectId, int inviterId, int inviteeId) async {
    Uri uri = Uri.https(
        "localhost:7277", "api/Teams/invite/$projectId/$inviterId/$inviteeId");
    print(uri);
    Response res = await post(uri);
    print(res);
  }

  Future<int> getUserByEmail(String email) async {
    Uri uri = Uri.https("localhost:7277", "api/Users/email/$email");
    print(uri);
    Response res = await get(uri);

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      print(body);
      User profile = User.fromJson(body);
      print(profile.id);
      loggedUserId = profile.id;
      return profile.id;
    } else {
      throw "unable to get user with email $email";
    }
  }
}
