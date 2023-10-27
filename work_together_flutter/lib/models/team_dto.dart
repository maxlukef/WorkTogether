import 'package:json_annotation/json_annotation.dart';
import 'package:work_together_flutter/models/user_models/user.dart';
part 'team_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamDTO {
  @JsonKey()
  int id;
  @JsonKey()
  String name;
  @JsonKey()
  List<User> members;
  @JsonKey()
  bool complete;
  @JsonKey()
  int projectId;

  TeamDTO(this.id, this.name, this.members, this.complete, this.projectId);

  factory TeamDTO.fromJson(Map<String, dynamic> json) =>
      _$TeamDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TeamDTOToJson(this);
}
