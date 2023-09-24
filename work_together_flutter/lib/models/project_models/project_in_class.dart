import 'package:json_annotation/json_annotation.dart';
part 'project_in_class.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectInClass {
  @JsonKey()
  final int id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String description;
  @JsonKey()
  final String className;
  @JsonKey()
  final int classId;
  @JsonKey()
  final int minTeamSize;
  @JsonKey()
  final int maxTeamSize;
  @JsonKey()
  final DateTime deadline;
  @JsonKey()
  final DateTime teamFormationDeadline;

  ProjectInClass({
    required this.id,
    required this.name,
    required this.description,
    required this.className,
    required this.classId,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.deadline,
    required this.teamFormationDeadline,
  });

  factory ProjectInClass.fromJson(Map<String, dynamic> json) =>
      _$ProjectInClassFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectInClassToJson(this);
}
