// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChatDTO _$CreateChatDTOFromJson(Map<String, dynamic> json) =>
    CreateChatDTO(
      json['name'] as String,
      (json['userIDs'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$CreateChatDTOToJson(CreateChatDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userIDs': instance.userIDs,
    };
