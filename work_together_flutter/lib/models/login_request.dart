import 'package:json_annotation/json_annotation.dart';
part 'login_request.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginRequest {
  @JsonKey()
  final String username;
  @JsonKey()
  final String password;

  LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
