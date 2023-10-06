// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Milestone _$MilestoneFromJson(Map<String, dynamic> json) => Milestone(
      json['name'] as String,
      json['description'] as String,
      json['deadline'] as String,
      json['tasksCompleted'] as int,
      json['totalTasks'] as int,
    );

Map<String, dynamic> _$MilestoneToJson(Milestone instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'deadline': instance.deadline,
      'tasksCompleted': instance.tasksCompleted,
      'totalTasks': instance.totalTasks,
    };
