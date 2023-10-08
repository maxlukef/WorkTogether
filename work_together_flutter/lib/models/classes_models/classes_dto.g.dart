// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassesDTO _$ClassesDTOFromJson(Map<String, dynamic> json) => ClassesDTO(
      json['id'] as int,
      json['professorID'] as int,
      json['name'] as String,
      json['description'] as String?,
    );

Map<String, dynamic> _$ClassesDTOToJson(ClassesDTO instance) =>
    <String, dynamic>{
      'id': instance.classID,
      'professorID': instance.professorID,
      'name': instance.name,
      'description': instance.description,
    };
