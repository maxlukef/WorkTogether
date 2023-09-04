// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardInfo _$CardInfoFromJson(Map<String, dynamic> json) => CardInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      major: json['major'] as String,
      availableMornings: (json['availableMornings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availableAfternoons: (json['availableAfternoons'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availableEvenings: (json['availableEvenings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      expectedGrade: json['expectedGrade'] as String,
      weeklyHours: json['weeklyHours'] as String,
    );

Map<String, dynamic> _$CardInfoToJson(CardInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'major': instance.major,
      'availableMornings': instance.availableMornings,
      'availableAfternoons': instance.availableAfternoons,
      'availableEvenings': instance.availableEvenings,
      'skills': instance.skills,
      'interests': instance.interests,
      'expectedGrade': instance.expectedGrade,
      'weeklyHours': instance.weeklyHours,
    };
