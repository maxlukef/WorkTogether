import 'package:json_annotation/json_annotation.dart';
part 'answer_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnswerDTO {
  @JsonKey(name: "id")
  int id;
  @JsonKey()
  String answerText;
  @JsonKey()
  int questionId;
  @JsonKey()
  int answererId;
  @JsonKey()
  String answererName;

  AnswerDTO(this.id, this.answerText, this.questionId, this.answererId,
      this.answererName);

  factory AnswerDTO.fromJson(Map<String, dynamic> json) =>
      _$AnswerDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerDTOToJson(this);
}
