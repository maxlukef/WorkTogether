import 'package:json_annotation/json_annotation.dart';

import '../user_models/user.dart';
part 'return_task_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ReturnTaskDTO {
  @JsonKey()
  int id;
  @JsonKey()
  String name;
  @JsonKey()
  String description;
  @JsonKey()
  int teamID;
  @JsonKey()
  int? parentTaskID;
  @JsonKey()
  int? parentMilestoneID;
  @JsonKey()
  List<User> assignees;
  @JsonKey()
  String dueDate;
  @JsonKey()
  bool completed;

  ReturnTaskDTO(
      this.id,
      this.name,
      this.description,
      this.teamID,
      this.parentTaskID,
      this.parentMilestoneID,
      this.assignees,
      this.dueDate,
      this.completed);

  factory ReturnTaskDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturnTaskDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnTaskDTOToJson(this);

  bool containsStudentName(String name) {
    for (User student in assignees) {
      if (student.name == name) {
        return true;
      }
    }
    return false;
  }
}
