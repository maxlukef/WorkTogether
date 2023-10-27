// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamDTO _$TeamDTOFromJson(Map<String, dynamic> json) => TeamDTO(
      json['id'] as int,
      json['name'] as String,
      (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['complete'] as bool,
      json['projectId'] as int,
    );

Map<String, dynamic> _$TeamDTOToJson(TeamDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'members': instance.members.map((e) => e.toJson()).toList(),
      'complete': instance.complete,
      'projectId': instance.projectId,
    };
