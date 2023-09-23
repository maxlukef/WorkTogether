// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatInfo _$ChatInfoFromJson(Map<String, dynamic> json) => ChatInfo(
      json['id'] as int,
      json['name'] as String,
      (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatInfoToJson(ChatInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'users': instance.users.map((e) => e.toJson()).toList(),
    };
