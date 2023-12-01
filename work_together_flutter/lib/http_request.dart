import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
import 'package:work_together_flutter/models/chat_models/chat_message_dto.dart';
import 'package:work_together_flutter/models/chat_models/chat_rename_dto.dart';
import 'package:work_together_flutter/models/chat_models/create_chat_dto.dart';
import 'package:work_together_flutter/models/chat_models/send_message_dto.dart';
import 'package:work_together_flutter/models/classes_models/classes_dto.dart';
import 'package:work_together_flutter/models/login_models/login_request.dart';
import 'package:work_together_flutter/models/login_models/login_results.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';
import 'package:work_together_flutter/models/milestone_models/milestone_dto.dart';
import 'package:work_together_flutter/models/user_models/new_user.dart';
import 'package:work_together_flutter/models/task_models/basic_task_dto.dart';
import 'package:work_together_flutter/models/task_models/create_task_dto.dart';
import 'package:work_together_flutter/models/task_models/return_task_dto.dart';
import 'package:work_together_flutter/models/team_dto.dart';

import 'main.dart';
import 'models/answer_models/answer_dto.dart';
import 'models/card_info_models/card_info.dart';
import 'models/milestone_models/completion_info.dart';
import 'models/notification_models/notification_dto.dart';
import 'models/project_models/project_in_class.dart';
import 'models/question_models/question_dto.dart';
import 'models/questionnaire_models/questionnaire_info.dart';
import 'models/user_models/user.dart';

class HttpService {
  //String connectionString = 'localhost:7277';
  String connectionString = 'worktogether.site';

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
    Uri uri = Uri.https(connectionString, 'api/Users/profile/$userId');

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
    Uri uri = Uri.https(connectionString, 'api/Users/profile');
    var body = user.toJson();
    try {
      await post(uri, body: body, headers: authHeader);
    } catch (e) {
      print(e);
    }
  }

  Future<CardInfo> getLoggedUserCard(int projectId) async {
    Uri uri = Uri.https(connectionString, 'api/Users/profile/$loggedUserId');

    Response res = await get(uri);
    User loggedInUser;

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      loggedInUser = User.fromJson(body);
    } else {
      throw "Unable to retrieve user.";
    }

    Uri cardUri = Uri.https(connectionString,
        'api/Answers/GetCurrentUserAnswersByProjectId/$projectId');

    var cardRes = await get(cardUri, headers: authHeader);
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

      if (loggedInUser.interests.contains("")) {
        loggedInUser.interests.remove("");
      }

      return CardInfo(
          id: loggedInUser.id,
          name: loggedInUser.name,
          major: loggedInUser.major,
          availableMornings: mornings,
          availableAfternoons: afternoons,
          availableEvenings: evenings,
          skills: skillsList,
          interests: loggedInUser.interests,
          expectedGrade: grade,
          weeklyHours: hours);
    } else {
      throw "Could not retrieve logged user card";
    }
  }

  Future<List<CardInfo>> getUsers(int classId, int projectId) async {
    Uri uri =
        Uri.https(connectionString, 'api/Users/studentsbyclassID/$classId');

    List<CardInfo> cardInfo = [];

    var res = await get(uri);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<User> users = body
          .map(
            (dynamic item) => User.fromJson(item),
          )
          .toList();

      List<int> teamIds = await getTeamIds(projectId);

      for (var i = 0; i < users.length; i++) {
        if (!teamIds.contains(users[i].id) && users[i].id != loggedUserId) {
          Uri cardUri = Uri.https(connectionString,
              'api/Answers/GetAnswersByProjectIdAndUserId/$projectId/${users[i].id}');
          var cardRes = await get(cardUri, headers: authHeader);
          if (cardRes.statusCode == 200) {
            List<dynamic> cardBody = jsonDecode(cardRes.body);

            if (cardBody.isEmpty) {
              continue;
            }

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

            if (users[i].interests.contains("")) {
              users[i].interests.remove("");
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
          } else {
            throw "Could not get answers for iterated user";
          }
        }
      }

      return cardInfo;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<int>> getTeamIds(int projectId) async {
    Uri uri = Uri.https(connectionString, 'api/Teams/byproject/$projectId');
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

  Future<List<TeamDTO>> getTeamsInProject(int projectId) async {
    Uri uri =
        Uri.https(connectionString, 'api/Teams/allteamsinproject/$projectId');

    var res = await get(uri, headers: authHeader);
    List<TeamDTO> teams = [];
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      for (var i = 0; i < body.length; i++) {
        teams.add(TeamDTO.fromJson(body[i]));
      }
    }

    return teams;
  }

  Future<MilestoneDTO?> getNextMilestoneDue(int projectId) async {
    Uri uri = Uri.https(
        connectionString, 'api/Milestones/NextMilestoneDue/$projectId');
    Response res;
    MilestoneDTO milestone;
    res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      int iD = body[0]["id"];
      int pID = body[0]["projectID"];
      String title = body[0]["title"];
      String description = body[0]["description"];
      DateTime date = DateTime.parse((body[0]["deadline"]));

      milestone = MilestoneDTO(
          id: iD,
          projectId: pID,
          title: title,
          description: description,
          deadline: date);

      return milestone;
    } else {
      return null;
    }
  }

  Future<CompletionInfo?> getMilestoneCompletionRate(int id) async {
    Uri uri = Uri.https(connectionString, 'api/Milestones/numcomplete/$id');
    Response res;
    res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      CompletionInfo c =
          CompletionInfo(id, body[0]["complete"], body[0]["numteams"]);

      return c;
    } else {
      return null;
    }
  }

  Future<List<CardInfo>> getTeam(int projectId) async {
    Uri uri = Uri.https(connectionString, 'api/Teams/byproject/$projectId');
    Response res;
    List<CardInfo> teamMates = [];

    try {
      res = await get(uri, headers: authHeader);
    } catch (e) {
      print(e);
      return teamMates;
    }

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode("[${res.body}]");

      for (var i = 0; i < body[0]["members"].length; i++) {
        var curMember = body[0]["members"][i];
        if (curMember["id"] != loggedUserId) {
          Uri cardUri = Uri.https(connectionString,
              'api/Answers/GetAnswersByProjectIdAndUserId/$projectId/${curMember["id"]}');
          var cardRes = await get(cardUri, headers: authHeader);
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

            if (curMember["interests"].interests.contains("")) {
              curMember["interests"].interests.remove("");
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

  Future<bool> joinClassWithCode(String classCode) async {
    Uri uri = Uri.https(connectionString, "api/Classes/joinclass/$classCode");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  acceptInviteNotification(int notificationId) async {
    Uri uri =
        Uri.https(connectionString, "api/Teams/AcceptInvite/$notificationId");
    await post(uri, headers: authHeader);
  }

  Future<bool> login(String email, String password) async {
    LoginRequest requestData =
        LoginRequest(username: email, password: password);
    String body = jsonEncode(requestData);
    Uri uri = Uri.https(connectionString, "api/login");
    Response res = await post(uri, body: body, headers: nonAuthHeader);

    if (res.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(res.body);
      LoginResults result = LoginResults.fromJson(temp);

      authToken = result.authToken;
      loggedUserId = result.id;
      loggedUserName = result.name;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerUser(NewUser newUser) async {
    String body = newUser.toJson();
    Uri uri = Uri.https(connectionString, "api/register");
    Response res = await post(uri, body: body, headers: nonAuthHeader);

    if (res.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(res.body);
      LoginResults result = LoginResults.fromJson(temp);

      authToken = result.authToken;
      loggedUserId = result.id;
      loggedUserName = result.name;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createNewConversation(CreateChatDTO dto) async {
    String body = jsonEncode(dto);

    Uri uri = Uri.https(connectionString, "api/new");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> sendMessage(SendMessageDto dto) async {
    String body = jsonEncode(dto);

    Uri uri = Uri.https(connectionString, "api/send");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> renameChat(ChatRenameDTO dto) async {
    String body = jsonEncode(dto);

    Uri uri = Uri.https(connectionString, "api/rename");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> leaveChat(int chatID) async {
    Uri uri = Uri.https(connectionString, "api/leave/$chatID");
    Response res = await post(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<ChatInfo>?> getConversationInfo() async {
    Uri uri = Uri.https(connectionString, "api/currentuserchats");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ChatInfo> conversations;

      conversations = (json.decode(res.body) as List)
          .map((i) => ChatInfo.fromJson(i))
          .toList();
      return conversations;
    } else {
      return null;
    }
  }

  Future<TeamDTO?> getTeamByProjectId(int projectId) async {
    Uri uri = Uri.https(connectionString, "api/Teams/byproject/$projectId");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(res.body);
      TeamDTO team = TeamDTO.fromJson(temp);

      return team;
    } else {
      return null;
    }
  }

  Future<List<ReturnTaskDTO>?> getAllUserGroupTasks(int teamID) async {
    Uri uri =
        Uri.https(connectionString, "api/Tasks/AllUserGroupTasks/$teamID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ReturnTaskDTO> userGroupTasks;

      userGroupTasks = (json.decode(res.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();
      return userGroupTasks;
    } else {
      return null;
    }
  }

  Future<List<ReturnTaskDTO>?> getAllGroupTasks(int teamID) async {
    Uri uri = Uri.https(connectionString, "api/Tasks/AllGroupTasks/$teamID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ReturnTaskDTO> groupTasks;

      groupTasks = (json.decode(res.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();
      return groupTasks;
    } else {
      return null;
    }
  }

  Future<List<ReturnTaskDTO>?> getEveryMilestoneTask(int milestoneID) async {
    Uri uri =
        Uri.https(connectionString, "api/Tasks/AllMilestoneTasks/$milestoneID");
    Response res = await get(uri, headers: authHeader);

    Uri uri2 = Uri.https(
        connectionString, "api/Tasks/AllUserMilestoneTasks/$milestoneID");
    Response res2 = await get(uri2, headers: authHeader);

    if (res.statusCode == 200 && res2.statusCode == 200) {
      List<ReturnTaskDTO> milestoneTasks;
      List<ReturnTaskDTO> userMilestoneTasks;

      milestoneTasks = (json.decode(res.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();

      userMilestoneTasks = (json.decode(res2.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();

      milestoneTasks.addAll(userMilestoneTasks);
      return milestoneTasks;
    } else {
      return null;
    }
  }

  Future<List<Milestone>?> getMilestonesForProject(int projectID) async {
    Uri uri = Uri.https(
        connectionString, "api/Milestones/ProjectMilestones/$projectID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<MilestoneDTO> milestones = [];
      List<dynamic> milestoneBody = jsonDecode(res.body);

      for (dynamic milestone in milestoneBody) {
        int iD = milestone["id"];
        int pID = milestone["projectID"];
        String title = milestone["title"];
        String description = milestone["description"];
        DateTime date = DateTime.parse((milestone["deadline"]));

        MilestoneDTO milestoneToAdd = MilestoneDTO(
            id: iD,
            projectId: pID,
            title: title,
            description: description,
            deadline: date);

        milestones.add(milestoneToAdd);
      }

      List<Milestone> returnMilestones = [];
      DateFormat format = DateFormat("yyyy-MM-dd");

      for (MilestoneDTO dto in milestones) {
        List<ReturnTaskDTO>? tasks = await getEveryMilestoneTask(dto.id);
        tasks ??= [];

        int completedTasks = 0;
        for (ReturnTaskDTO task in tasks) {
          if (task.completed) {
            completedTasks++;
          }
        }

        // Convert milestones to the data structure used in the pages.
        // TODO: Add this field to the dto's in the future.
        bool completed = true;
        returnMilestones.add(Milestone(
            dto.id,
            dto.projectId,
            dto.title,
            dto.description,
            format.format(dto.deadline),
            completedTasks,
            tasks.length,
            completed));
      }
      return returnMilestones;
    } else {
      return null;
    }
  }

  Future<List<ReturnTaskDTO>?> getAllMilestoneTasks(int milestoneID) async {
    Uri uri =
        Uri.https(connectionString, "api/Tasks/AllMilestoneTasks/$milestoneID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ReturnTaskDTO> milestoneTasks;

      milestoneTasks = (json.decode(res.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();
      return milestoneTasks;
    } else {
      return null;
    }
  }

  Future<List<ReturnTaskDTO>?> getAllUserMilestoneTasks(int milestoneID) async {
    Uri uri = Uri.https(
        connectionString, "api/Tasks/AllUserMilestoneTasks/$milestoneID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ReturnTaskDTO> userMilestoneTasks;

      userMilestoneTasks = (json.decode(res.body) as List)
          .map((i) => ReturnTaskDTO.fromJson(i))
          .toList();
      return userMilestoneTasks;
    } else {
      return null;
    }
  }

  Future<bool> createTask(CreateTaskDTO dto) async {
    String body = jsonEncode(dto);

    Uri uri = Uri.https(connectionString, "api/Tasks/create");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> editTask(BasicTaskDTO dto) async {
    String body = jsonEncode(dto);

    Uri uri = Uri.https(connectionString, "api/Tasks/edit");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> assignToTask(int taskId, int userID) async {
    Uri uri = Uri.https(connectionString, "api/tasks/assign/$taskId/$userID");
    Response res = await post(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> unassignFromTask(int taskId, int userID) async {
    Uri uri = Uri.https(connectionString, "api/Tasks/unassign/$taskId/$userID");
    Response res = await post(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> markTaskAsComplete(int taskId) async {
    Uri uri = Uri.https(connectionString, "api/Tasks/markcomplete/$taskId");
    Response res = await post(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> markTaskAsIncomplete(int taskId) async {
    Uri uri = Uri.https(connectionString, "api/Tasks/markincomplete/$taskId");
    Response res = await post(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> deleteTask(int taskId) async {
    Uri uri = Uri.https(connectionString, "api/Tasks/$taskId");
    Response res = await delete(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<ChatMessage>?> getMessages(int chatID) async {
    Uri uri = Uri.https(connectionString, "api/messages/$chatID");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ChatMessage> conversations;

      conversations = (json.decode(res.body) as List)
          .map((i) => ChatMessage.fromJson(i))
          .toList();
      return conversations;
    } else {
      return null;
    }
  }

  Future<List<ClassesDTO>?> getCurrentUsersClasses() async {
    Uri uri = Uri.https(connectionString, "api/Classes/currentuserclasses");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<ClassesDTO> classes;

      classes = (json.decode(res.body) as List)
          .map((i) => ClassesDTO.fromJson(i))
          .toList();
      return classes;
    } else {
      return null;
    }
  }

  Future<bool> deleteNotification(int id) async {
    Uri uri =
        Uri.https(connectionString, "api/Notifications/DeleteNotification/$id");
    Response res = await delete(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> sendInviteNotificationToUser(
    NotificationDTO notificationDTO,
  ) async {
    String body = jsonEncode(notificationDTO);

    Uri uri =
        Uri.https(connectionString, "api/Notifications/PostForSingleUser");
    Response res = await post(uri, headers: authHeader, body: body);

    if (res.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<NotificationDTO>?> getCurrentUserNotifications() async {
    Uri uri = Uri.https(connectionString, "api/Notifications/GetForCurUser");
    Response res = await get(uri, headers: authHeader);

    List<NotificationDTO> notifications = [];

    if (res.statusCode == 200) {
      List<dynamic> notificationBody = jsonDecode(res.body);

      for (dynamic notification in notificationBody) {
        NotificationDTO notificationToAdd = NotificationDTO(
            id: notification["id"],
            title: notification["title"],
            description: notification["description"],
            isInvite: notification["isInvite"],
            projectID: notification["projectID"],
            projectName: notification["projectName"],
            classID: notification["classID"],
            className: notification["className"],
            fromID: notification["fromID"],
            fromName: notification["fromName"],
            toID: notification["toID"],
            toName: notification["toName"],
            sentAt: DateTime.parse((notification["sentAt"])),
            read: notification["read"]);

        notifications.add(notificationToAdd);
      }
      return notifications;
    } else {
      return null;
    }
  }

  Future<List<ProjectInClass>?> getCurrentUserProjectsAndClasses() async {
    Uri uri = Uri.https(connectionString, "api/Classes/currentuserclasses");
    Response classesRes = await get(uri, headers: authHeader);

    if (classesRes.statusCode == 200) {
      List<ClassesDTO> classes;
      List<ProjectInClass> projectsInClass = [];

      classes = (json.decode(classesRes.body) as List)
          .map((i) => ClassesDTO.fromJson(i))
          .toList();

      for (ClassesDTO classDto in classes) {
        int classId = classDto.classID;

        Uri uri = Uri.https(
            connectionString, 'api/Projects/GetProjectsByClassId/$classId');
        var projectsRes = await get(uri, headers: authHeader);

        if (projectsRes.statusCode == 200) {
          List<dynamic> projectBody = jsonDecode(projectsRes.body);

          for (dynamic project in projectBody) {
            ProjectInClass projectInClass = ProjectInClass(
                id: project["id"],
                name: project["name"],
                description: project["description"],
                className: classDto.name,
                classId: classDto.classID,
                minTeamSize: project["minTeamSize"],
                maxTeamSize: project["maxTeamSize"],
                deadline: DateTime.parse((project["deadline"])),
                teamFormationDeadline:
                    DateTime.parse((project["teamFormationDeadline"])));
            projectsInClass.add(projectInClass);
          }
        } else {
          return null;
        }
      }
      return projectsInClass;
    } else {
      return null;
    }
  }

  Future<List<User>?> getStudentsInClass(int id) async {
    Uri uri = Uri.https(connectionString, "api/Classes/getstudentsinclass/$id");
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<User> students;

      students =
          (json.decode(res.body) as List).map((i) => User.fromJson(i)).toList();
      return students;
    } else {
      return null;
    }
  }

  Future<List<AnswerDTO>> getProjectAnswers(int projectId) async {
    Uri uriAnswers = Uri.https(connectionString,
        'api/Answers/GetCurrentUserAnswersByProjectId/$projectId');

    List<AnswerDTO> answersToQuestionnaire;

    Response resAnswers = await get(uriAnswers, headers: authHeader);

    if (resAnswers.statusCode == 200) {
      answersToQuestionnaire = (json.decode(resAnswers.body) as List)
          .map((i) => AnswerDTO.fromJson(i))
          .toList();

      return answersToQuestionnaire;
    } else {
      throw "Unable to retrieve current user answers for project";
    }
  }

  Future<List<QuestionDTO>> getQuestionnaireQuestions(int projectId) async {
    Uri uri = Uri.https(connectionString,
        'api/Questionnaires/GetQuestionnaireByProjectId/$projectId');

    List<QuestionDTO> questionsToQuestionnaire;

    Response res = await get(uri, headers: authHeader);

    QuestionnaireInfo questionnaireInfo;

    if (res.statusCode == 200) {
      var questionnaireBody = jsonDecode(res.body);

      questionnaireInfo = QuestionnaireInfo(
          id: questionnaireBody["id"],
          projectId: questionnaireBody["projectID"]);

      Uri uriQuestions = Uri.https(connectionString,
          'api/Questions/GetQuestionsByQuestionnaireId/${questionnaireInfo.id}');

      Response resQuestions = await get(uriQuestions, headers: authHeader);

      if (resQuestions.statusCode == 200) {
        questionsToQuestionnaire = (json.decode(resQuestions.body) as List)
            .map((i) => QuestionDTO.fromJson(i))
            .toList();

        return questionsToQuestionnaire;
      } else {
        throw "Unable to retrieve Questions";
      }
    } else {
      throw "Unable to retrieve Questionnaire";
    }
  }

  Future<List<AnswerDTO>> getQuestionnaireAnswers(int projectId) async {
    Uri uri = Uri.https(connectionString,
        'api/Questionnaires/GetQuestionnaireByProjectId/$projectId');

    List<AnswerDTO> answersToQuestionnaire;

    Response res = await get(uri, headers: authHeader);

    QuestionnaireInfo questionnaireInfo;

    if (res.statusCode == 200) {
      var questionnaireBody = jsonDecode(res.body);

      questionnaireInfo = QuestionnaireInfo(
          id: questionnaireBody["id"],
          projectId: questionnaireBody["projectID"]);

      Uri uriAnswers = Uri.https(connectionString,
          'api/Answers/GetAnswersByQuestionnaireIdForCurrentUser/${questionnaireInfo.id}');

      Response resAnswers = await get(uriAnswers, headers: authHeader);

      if (resAnswers.statusCode == 200) {
        answersToQuestionnaire = (json.decode(resAnswers.body) as List)
            .map((i) => AnswerDTO.fromJson(i))
            .toList();

        return answersToQuestionnaire;
      } else {
        throw "Unable to retrieve Answers";
      }
    } else {
      throw "Unable to retrieve Questionnaire";
    }
  }

  Future<bool> postQuestionnaireAnswers(
      int projectId, List<AnswerDTO> answers) async {
    Uri uriQuestionnaire = Uri.https(connectionString,
        'api/Questionnaires/GetQuestionnaireByProjectId/$projectId');

    List<AnswerDTO> answersToQuestionnaire;

    Response resQuestionnaire =
        await get(uriQuestionnaire, headers: authHeader);

    QuestionnaireInfo questionnaireInfo;

    if (resQuestionnaire.statusCode == 200) {
      var questionnaireBody = jsonDecode(resQuestionnaire.body);

      questionnaireInfo = QuestionnaireInfo(
          id: questionnaireBody["id"],
          projectId: questionnaireBody["projectID"]);

      String body =
          jsonEncode(answers.map((i) => i.toJson()).toList()).toString();

      Uri uri = Uri.https(connectionString,
          'api/Answers/PostAnswersFromQuestionnaireForCurrentUser/${questionnaireInfo.id}');

      Response res = await post(uri, headers: authHeader, body: body);

      if (res.statusCode == 200) {
        return true;
      }

      return false;
    } else {
      throw "Unable to retrieve Questionnaire";
    }
  }

  Future<bool> putQuestionnaireAnswers(
      int projectId, List<AnswerDTO> answers) async {
    Uri uriQuestionnaire = Uri.https(connectionString,
        'api/Questionnaires/GetQuestionnaireByProjectId/$projectId');

    List<AnswerDTO> answersToQuestionnaire;

    Response resQuestionnaire =
        await get(uriQuestionnaire, headers: authHeader);

    QuestionnaireInfo questionnaireInfo;

    if (resQuestionnaire.statusCode == 200) {
      var questionnaireBody = jsonDecode(resQuestionnaire.body);

      questionnaireInfo = QuestionnaireInfo(
          id: questionnaireBody["id"],
          projectId: questionnaireBody["projectID"]);

      String body =
          jsonEncode(answers.map((i) => i.toJson()).toList()).toString();

      Uri uri = Uri.https(connectionString,
          'api/Answers/PutAnswersFromQuestionnaireForCurrentUser/${questionnaireInfo.id}');

      Response res = await put(uri, headers: authHeader, body: body);

      if (res.statusCode == 200) {
        return true;
      }

      return false;
    } else {
      throw "Unable to retrieve Questionnaire";
    }
  }

  Future<ClassesDTO> getClassByID(int classId) async {
    Uri ClassesURI = Uri.https(connectionString, 'api/Classes/$classId');
    ClassesDTO returnedClass;

    Response res = await get(ClassesURI, headers: authHeader);

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      returnedClass = ClassesDTO.fromJson(body);
      return returnedClass;
    } else {
      throw "Unable to retrieve class.";
    }
  }

  Future<String> getClassInviteCode(int classId) async {
    Uri uri = Uri.https(connectionString, 'api/Classes/GetInviteCode/$classId');
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw "Unable to retrieve class invite code.";
    }
  }

  Future<List<TeamDTO>> getTeamsForProject(int projectId) async {
    Uri uri =
        Uri.https(connectionString, 'api/Teams/allteamsinproject/$projectId');
    Response res = await get(uri, headers: authHeader);

    var body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      List<TeamDTO> allTeams = [];
      for (Map<String, dynamic> t in body) {
        allTeams.add(TeamDTO.fromJson(t));
      }

      return allTeams;
    } else {
      throw "Unable to retrieve class.";
    }
  }

  Future<List<User>> getStudentsInTeam(int teamId) async {
    Uri uri =
        Uri.https(connectionString, 'api/Teams/GetStudentsInTeam/$teamId');
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<User> students;

      students =
          (json.decode(res.body) as List).map((i) => User.fromJson(i)).toList();
      return students;
    } else {
      throw "Unable to retrieve class.";
    }
  }

  Future<List<String>> getAlerts(int projectId) async {
    Uri uri = Uri.https(connectionString, 'api/Alerts/GetAlerts/$projectId');
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      List<String> alerts = [];
      List<String> body = jsonDecode(res.body);

      return body;
    } else {
      throw "Unable to retrieve alerts.";
    }
  }

  Future<bool> isProfessor() async {
    Uri uri = Uri.https(connectionString, 'api/Users/isprofessor/');
    Response res = await get(uri, headers: authHeader);

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      return body;
    } else {
      throw "Unable to check if current user is professor";
    }
  }

  void deleteClass(int classId) async {
    Uri uri = Uri.https(connectionString, 'api/Classes/$classId');
    await delete(uri, headers: authHeader);
  }

  void addClass(String className, String description) async {
    Uri uri = Uri.https(connectionString, 'api/Classes/create');
    var body = jsonEncode({"name": className, "description": description});
    var response = await post(uri, headers: authHeader, body: body);
    print(response.statusCode);
  }
}
