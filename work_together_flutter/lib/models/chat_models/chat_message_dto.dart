import 'package:json_annotation/json_annotation.dart';
part 'chat_message_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatMessage {
  @JsonKey()
  int senderID;
  @JsonKey()
  String senderName;
  @JsonKey()
  String content;
  @JsonKey()
  String sent;

  ChatMessage(this.senderID, this.senderName, this.content, this.sent);

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
