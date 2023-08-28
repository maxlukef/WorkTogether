import 'package:json_annotation/json_annotation.dart';
part 'card_info.g.dart';

@JsonSerializable(explicitToJson: true)
class CardInfo {
  @JsonKey()
  final int id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String major;
  @JsonKey()
  final List<String> availableMornings;
  @JsonKey()
  final List<String> availableAfternoons;
  @JsonKey()
  final List<String> availableEvenings;
  @JsonKey()
  final List<String> skills;
  @JsonKey()
  final List<String> interests;
  @JsonKey()
  final String expectedGrade;
  @JsonKey()
  final String weeklyHours;

  CardInfo(
      {required this.id,
      required this.name,
      required this.major,
      required this.availableMornings,
      required this.availableAfternoons,
      required this.availableEvenings,
      required this.skills,
      required this.interests,
      required this.expectedGrade,
      required this.weeklyHours});

  factory CardInfo.fromJson(Map<String, dynamic> json) =>
      _$CardInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CardInfoToJson(this);
}
