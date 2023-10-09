// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResults _$LoginResultsFromJson(Map<String, dynamic> json) => LoginResults(
      authToken: json['token'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LoginResultsToJson(LoginResults instance) =>
    <String, dynamic>{
      'token': instance.authToken,
      'id': instance.id,
      'name': instance.name,
    };
