import 'dart:convert';

import 'package:http/http.dart';
import 'package:work_together_flutter/models/login_request.dart';
import 'package:work_together_flutter/models/login_results.dart';
import 'package:work_together_flutter/models/new_user.dart';

import 'main.dart';
import 'models/card_info.dart';
import 'models/user.dart';

class HttpService {
  var authHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $authToken'
  };

  var nonAuthHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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
    Uri uri = Uri.https('localhost:7277', 'api/Users/profile');
    var body = user.toJson();
    try {
      await post(uri, body: body, headers: authHeader);
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
    Response res;
    List<CardInfo> teamMates = [];
    try {
      res = await get(uri);
    } catch (e) {
      print(e);
      return teamMates;
    }

    // Occurs if no teammates exist
    if (res.statusCode == 404) {
      Uri uri = Uri.https('localhost:7277', 'api/Users/profile/$userId');

      Response res = await get(uri);

      int loggedInUserId;
      User loggedInUser;

      if (res.statusCode == 200) {
        dynamic body = jsonDecode(res.body);
        loggedInUser = User.fromJson(body);
        loggedInUserId = loggedInUser.id;
      } else {
        throw "Unable to retrieve user.";
      }

      Uri cardUri =
          Uri.https('localhost:7277', 'api/Answers/$classId/$loggedInUserId');

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
            id: loggedInUser.id,
            name: loggedInUser.name,
            major: loggedInUser.major,
            availableMornings: mornings,
            availableAfternoons: afternoons,
            availableEvenings: evenings,
            skills: skillsList,
            interests: loggedInUser.interests,
            expectedGrade: grade,
            weeklyHours: hours));
      }

      return teamMates;
    }

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode("[${res.body}]");

      for (var i = 0; i < body[0]["members"].length; i++) {
        var curMember = body[0]["members"][i];
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
    return teamMates;
  }

  inviteToTeam(int projectId, int inviterId, int inviteeId) async {
    Uri uri = Uri.https(
        "localhost:7277", "api/Teams/invite/$projectId/$inviterId/$inviteeId");
    await post(uri);
  }

  Future<bool> login(String email, String password) async {
    LoginRequest requestData =
        LoginRequest(username: email, password: password);
    String body = jsonEncode(requestData);
    Uri uri = Uri.https("localhost:7277", "login");
    Response res = await post(uri, body: body, headers: nonAuthHeader);

    if (res.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(res.body);
      LoginResults result = LoginResults.fromJson(temp);

      authToken = result.authToken;
      loggedUserId = result.id;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerUser(NewUser newUser) async {
    String body = newUser.toJson();
    Uri uri = Uri.https("localhost:7277", "register");
    Response res = await post(uri, body: body, headers: nonAuthHeader);

    if (res.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(res.body);
      LoginResults result = LoginResults.fromJson(temp);

      authToken = result.authToken;
      loggedUserId = result.id;
      return true;
    } else {
      return false;
    }
  }

  Future<CardInfo> getQuestionnaireAnswersByClassIdAndUserId(
      classId, userId) async {
    Uri uri = Uri.https('localhost:7277', 'api/Users/profile/$userId');

    Response res = await get(uri);

    int loggedInUserId;
    User loggedInUser;

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      loggedInUser = User.fromJson(body);
      loggedInUserId = loggedInUser.id;
    } else {
      throw "Unable to retrieve user.";
    }

    Uri cardUri =
        Uri.https('localhost:7277', 'api/Answers/$classId/$loggedInUserId');

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

      return (CardInfo(
          id: loggedInUser.id,
          name: loggedInUser.name,
          major: loggedInUser.major,
          availableMornings: mornings,
          availableAfternoons: afternoons,
          availableEvenings: evenings,
          skills: skillsList,
          interests: loggedInUser.interests,
          expectedGrade: grade,
          weeklyHours: hours));
    } else {
      throw "unable to get user questionnaire answers with $classId and $userId";
    }
  }
}
