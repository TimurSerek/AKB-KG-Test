
import 'package:akb_kg_test/domain/entity/character.dart';
import 'package:json_annotation/json_annotation.dart';

part 'сharacter_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterResponse{
  final Info info;
  @JsonKey(name: 'results')
  final List<Character> characters;

  CharacterResponse({required this.info, required this.characters});

  factory CharacterResponse.fromJson(Map<String, dynamic> json) => _$CharacterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterResponseToJson(this);
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

