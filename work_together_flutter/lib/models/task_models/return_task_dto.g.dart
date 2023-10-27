// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnTaskDTO _$ReturnTaskDTOFromJson(Map<String, dynamic> json) =>
    ReturnTaskDTO(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['teamID'] as int,
      json['parentTaskID'] as int?,
      json['parentMilestoneID'] as int?,
      (json['assignees'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['dueDate'] as String,
      json['completed'] as bool,
    );

Map<String, dynamic> _$ReturnTaskDTOToJson(ReturnTaskDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'teamID': instance.teamID,
      'parentTaskID': instance.parentTaskID,
      'parentMilestoneID': instance.parentMilestoneID,
      'assignees': instance.assignees.map((e) => e.toJson()).toList(),
      'dueDate': instance.dueDate,
      'completed': instance.completed,
    };
