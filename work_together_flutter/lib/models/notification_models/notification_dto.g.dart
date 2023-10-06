// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDTO _$NotificationDTOFromJson(Map<String, dynamic> json) =>
    NotificationDTO(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isInvite: json['isInvite'] as bool,
      projectID: json['projectID'] as int,
      projectName: json['projectName'] as String,
      classID: json['classID'] as int,
      className: json['className'] as String,
      fromID: json['fromID'] as String,
      toID: json['toID'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      read: json['read'] as bool,
    );

Map<String, dynamic> _$NotificationDTOToJson(NotificationDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isInvite': instance.isInvite,
      'projectID': instance.projectID,
      'projectName': instance.projectName,
      'classID': instance.classID,
      'className': instance.className,
      'fromID': instance.fromID,
      'toID': instance.toID,
      'sentAt': instance.sentAt.toIso8601String(),
      'read': instance.read,
    };
