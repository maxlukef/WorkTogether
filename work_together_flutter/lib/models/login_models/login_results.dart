import 'package:json_annotation/json_annotation.dart';
part 'login_results.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResults {
  @JsonKey(name: "token")
  final String authToken;
  @JsonKey()
  final int id;

  LoginResults({required this.authToken, required this.id});

  factory LoginResults.fromJson(Map<String, dynamic> json) =>
      _$LoginResultsFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultsToJson(this);
}
