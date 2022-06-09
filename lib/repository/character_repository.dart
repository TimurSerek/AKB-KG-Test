import '../domain/api_client/character_api_client.dart';
import '../domain/entity/character.dart';
import '../domain/entity/сharacter_response.dart';

class CharacterRepository {
  final _characterApiClient = CharacterApiClient();

  Future<CharacterResponse> getInitialCharacters() async =>
      _characterApiClient.getInitialCharacters();

  Future<CharacterResponse> getNextCharacters(String nextPage) async =>
      _characterApiClient.getNextCharacters(nextPage);

  Future<Character> getCharacterDetails(int index) async =>
      _characterApiClient.getCharacterDetails(index);

  Future<CharacterResponse> loadFilteredCharactersBySpecies(String speccy) async =>
      _characterApiClient.loadFilteredCharactersBySpecies(speccy);

  Future<CharacterResponse> searchCharacterByName(String name) async =>
      _characterApiClient.searchCharacterByName(name);
}
