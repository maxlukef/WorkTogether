// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      json['senderID'] as int,
      json['senderName'] as String,
      json['content'] as String,
      json['sent'] as String,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'senderID': instance.senderID,
      'senderName': instance.senderName,
      'content': instance.content,
      'sent': instance.sent,
    };
