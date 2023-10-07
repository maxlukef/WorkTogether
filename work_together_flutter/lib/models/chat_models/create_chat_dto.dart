import 'package:json_annotation/json_annotation.dart';
part 'create_chat_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateChatDTO {
  @JsonKey()
  String name;
  @JsonKey()
  List<int> userIDs;

  CreateChatDTO(this.name, this.userIDs);

  factory CreateChatDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateChatDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatDTOToJson(this);
}
