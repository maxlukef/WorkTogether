import 'package:json_annotation/json_annotation.dart';
part 'classes_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ClassesDTO {
  @JsonKey(name: "id")
  int classID;
  @JsonKey()
  int professorID;
  @JsonKey()
  String name;
  @JsonKey()
  String? description;

  ClassesDTO(this.classID, this.professorID, this.name, this.description);

  factory ClassesDTO.fromJson(Map<String, dynamic> json) =>
      _$ClassesDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ClassesDTOToJson(this);
}
