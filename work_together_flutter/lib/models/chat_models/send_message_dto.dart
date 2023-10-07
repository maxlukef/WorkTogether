import 'package:json_annotation/json_annotation.dart';
part 'send_message_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SendMessageDto {
  @JsonKey()
  int chatID;
  @JsonKey()
  String message;

  SendMessageDto(this.chatID, this.message);

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);
}
