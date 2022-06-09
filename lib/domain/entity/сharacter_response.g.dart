// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'сharacter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterResponse _$CharacterResponseFromJson(Map<String, dynamic> json) =>
    CharacterResponse(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      characters: (json['results'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CharacterResponseToJson(CharacterResponse instance) =>
    <String, dynamic>{
      'info': instance.info.toJson(),
      'results': instance.characters.map((e) => e.toJson()).toList(),
    };
