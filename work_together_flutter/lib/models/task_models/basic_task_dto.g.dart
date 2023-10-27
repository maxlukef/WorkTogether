// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicTaskDTO _$BasicTaskDTOFromJson(Map<String, dynamic> json) => BasicTaskDTO(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['teamID'] as int,
      json['parentTaskID'] as int?,
      json['parentMilestoneID'] as int?,
      (json['assignees'] as List<dynamic>).map((e) => e as int).toList(),
      json['dueDate'] as String,
      json['completed'] as bool,
    );

Map<String, dynamic> _$BasicTaskDTOToJson(BasicTaskDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'teamID': instance.teamID,
      'parentTaskID': instance.parentTaskID,
      'parentMilestoneID': instance.parentMilestoneID,
      'assignees': instance.assignees,
      'dueDate': instance.dueDate,
      'completed': instance.completed,
    };
