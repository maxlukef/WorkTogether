import 'package:json_annotation/json_annotation.dart';
import 'package:work_together_flutter/models/user.dart';
part 'chat_info_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatInfo {
  @JsonKey()
  int id;
  @JsonKey()
  String name;
  @JsonKey()
  List<User> users;

  ChatInfo(this.id, this.name, this.users);

  factory ChatInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatInfoToJson(this);
}
