
import 'package:akb_kg_test/domain/entity/character.dart';
import 'package:akb_kg_test/domain/entity/episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EpisodeResponse{
  final Info info;
  @JsonKey(name: 'results')
  final List<Episode> episodes;

  EpisodeResponse({required this.info, required this.episodes});

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) => _$EpisodeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeResponseToJson(this);
}

class Info{
  int? count;
  int? pages;
  String? next;
  String? prev;

  Info(this.count, this.pages, this.next, this.prev);

  Info.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    pages = json['pages'];
    next = json['next'];
    prev = json['prev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['pages'] = pages;
    data['next'] = next;
    data['prev'] = prev;
    return data;
  }
}