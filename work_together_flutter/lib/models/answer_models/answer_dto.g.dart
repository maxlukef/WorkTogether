// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerDTO _$AnswerDTOFromJson(Map<String, dynamic> json) => AnswerDTO(
      json['id'] as int,
      json['answerText'] as String,
      json['questionId'] as int,
      json['answererId'] as int,
      json['answererName'] as String,
    );

Map<String, dynamic> _$AnswerDTOToJson(AnswerDTO instance) => <String, dynamic>{
      'id': instance.id,
      'answerText': instance.answerText,
      'questionId': instance.questionId,
      'answererId': instance.answererId,
      'answererName': instance.answererName,
    };
