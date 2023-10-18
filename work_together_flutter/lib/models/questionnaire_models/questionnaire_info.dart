import 'package:json_annotation/json_annotation.dart';
part 'questionnaire_info.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestionnaireInfo {
  @JsonKey()
  final int id;
  @JsonKey()
  final int projectId;

  QuestionnaireInfo({required this.id, required this.projectId});

  factory QuestionnaireInfo.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireInfoToJson(this);
}
