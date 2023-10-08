// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_in_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectInClass _$ProjectInClassFromJson(Map<String, dynamic> json) =>
    ProjectInClass(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      className: json['className'] as String,
      classId: json['classId'] as int,
      minTeamSize: json['minTeamSize'] as int,
      maxTeamSize: json['maxTeamSize'] as int,
      deadline: DateTime.parse(json['deadline'] as String),
      teamFormationDeadline:
          DateTime.parse(json['teamFormationDeadline'] as String),
    );

Map<String, dynamic> _$ProjectInClassToJson(ProjectInClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'className': instance.className,
      'classId': instance.classId,
      'minTeamSize': instance.minTeamSize,
      'maxTeamSize': instance.maxTeamSize,
      'deadline': instance.deadline.toIso8601String(),
      'teamFormationDeadline': instance.teamFormationDeadline.toIso8601String(),
    };
