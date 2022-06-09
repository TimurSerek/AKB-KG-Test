// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeResponse _$EpisodeResponseFromJson(Map<String, dynamic> json) =>
    EpisodeResponse(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      episodes: (json['results'] as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EpisodeResponseToJson(EpisodeResponse instance) =>
    <String, dynamic>{
      'info': instance.info.toJson(),
      'results': instance.episodes.map((e) => e.toJson()).toList(),
    };
