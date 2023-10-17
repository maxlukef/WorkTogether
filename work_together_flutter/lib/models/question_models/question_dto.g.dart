// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionDTO _$QuestionDTOFromJson(Map<String, dynamic> json) => QuestionDTO(
      json['id'] as int,
      json['prompt'] as String,
      json['type'] as String,
      json['questionnaireID'] as int,
    );

Map<String, dynamic> _$QuestionDTOToJson(QuestionDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'type': instance.type,
      'questionnaireID': instance.questionnaireID,
    };
