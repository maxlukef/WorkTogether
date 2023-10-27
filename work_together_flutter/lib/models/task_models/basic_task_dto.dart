import 'package:json_annotation/json_annotation.dart';
part 'basic_task_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class BasicTaskDTO {
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
  List<int> assignees;
  @JsonKey()
  String dueDate;
  @JsonKey()
  bool completed;

  BasicTaskDTO(
      this.id,
      this.name,
      this.description,
      this.teamID,
      this.parentTaskID,
      this.parentMilestoneID,
      this.assignees,
      this.dueDate,
      this.completed);

  factory BasicTaskDTO.fromJson(Map<String, dynamic> json) =>
      _$BasicTaskDTOFromJson(json);

  Map<String, dynamic> toJson() => _$BasicTaskDTOToJson(this);
}
