// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskDTO _$CreateTaskDTOFromJson(Map<String, dynamic> json) =>
    CreateTaskDTO(
      json['name'] as String,
      json['description'] as String,
      json['teamID'] as int,
      json['parentTaskID'] as int?,
      json['parentMilestoneID'] as int?,
      (json['assignees'] as List<dynamic>).map((e) => e as int).toList(),
      json['dueDate'] as String,
      json['completed'] as bool,
    );

Map<String, dynamic> _$CreateTaskDTOToJson(CreateTaskDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'teamID': instance.teamID,
      'parentTaskID': instance.parentTaskID,
      'parentMilestoneID': instance.parentMilestoneID,
      'assignees': instance.assignees,
      'dueDate': instance.dueDate,
      'completed': instance.completed,
    };
