import 'package:json_annotation/json_annotation.dart';
part 'milestone.g.dart';

@JsonSerializable(explicitToJson: true)
class Milestone {
  @JsonKey()
  String name = "";
  @JsonKey()
  String description = "";
  @JsonKey()
  String deadline = "";
  @JsonKey()
  int tasksCompleted = 0;
  @JsonKey()
  int totalTasks = 0;

  Milestone(this.name, this.description, this.deadline, this.tasksCompleted,
      this.totalTasks);

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneToJson(this);
}
