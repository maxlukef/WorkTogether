import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  @JsonKey()
  String name = "";
  @JsonKey()
  String description = "";
  @JsonKey()
  String assignedUser = "";
  @JsonKey()
  String dueDate = "";

  Task(this.name, this.description, this.dueDate, this.assignedUser);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
