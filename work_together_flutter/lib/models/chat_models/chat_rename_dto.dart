import 'package:json_annotation/json_annotation.dart';
part 'chat_rename_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatRenameDTO {
  @JsonKey()
  int id;
  @JsonKey()
  String newName;

  ChatRenameDTO(this.id, this.newName);

  factory ChatRenameDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatRenameDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRenameDTOToJson(this);
}
