import 'package:json_annotation/json_annotation.dart';
part 'create_task_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateTaskDTO {
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
  List<int> assignees;
  @JsonKey()
  String dueDate;
  @JsonKey()
  bool completed;

  CreateTaskDTO(this.name, this.description, this.teamID, this.parentTaskID,
      this.parentMilestoneID, this.assignees, this.dueDate, this.completed);

  factory CreateTaskDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskDTOToJson(this);
}
