
import '../../configuration/configuration.dart';
import '../entity/character.dart';
import '../entity/сharacter_response.dart';
import 'network_client.dart';

class CharacterApiClient{
  final _networkClient = NetworkClient();

  Future<CharacterResponse> getInitialCharacters() async {
    CharacterResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = CharacterResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      Configuration.urlGetCharacter,
      parser,
    );
    return result;
  }

  Future<CharacterResponse> getNextCharacters(String nextPage) async {
    CharacterResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = CharacterResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      nextPage,
      parser,
    );
    return result;
  }

  Future<Character> getCharacterDetails(int index) async {
    Character parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = Character.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '${Configuration.urlGetCharacter}$index',
      parser,
    );
    return result;
  }

  Future<CharacterResponse> loadFilteredCharactersBySpecies(String speccy) async {
    CharacterResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = CharacterResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      Configuration.urlGetCharacter,
      parser,
      <String, dynamic>{
        'species': speccy
      }
    );
    return result;
  }

  Future<CharacterResponse> searchCharacterByName(String name) async {
    CharacterResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = CharacterResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
        Configuration.urlGetCharacter,
        parser,
        <String, dynamic>{
          'name': name
        }
    );
    return result;
  }
}