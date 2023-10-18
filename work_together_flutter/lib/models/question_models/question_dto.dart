import 'package:json_annotation/json_annotation.dart';
part 'question_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestionDTO {
  @JsonKey(name: "id")
  int id;
  @JsonKey()
  String prompt;
  @JsonKey()
  String type;
  @JsonKey()
  int questionnaireID;

  QuestionDTO(this.id, this.prompt, this.type, this.questionnaireID);

  factory QuestionDTO.fromJson(Map<String, dynamic> json) =>
      _$QuestionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDTOToJson(this);
}
