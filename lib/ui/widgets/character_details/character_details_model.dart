
import 'package:akb_kg_test/repository/character_repository.dart';
import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/entity/character.dart';
import '../../../shared/constants/app_strings.dart';

class CharacterListItemData {
  final String image;
  final String name;
  final String species;

  CharacterListItemData({
    required this.image,
    required this.name,
    required this.species,
  });
}

class CharacterDetailsViewModel extends ChangeNotifier{
  final _characterRepository = CharacterRepository();
  final int characterId;
  CharacterListItemData? _characterDetails;
  String? _errorMessage;

  CharacterListItemData? get characterDetails => _characterDetails;
  String? get errorMessage => _errorMessage;

  CharacterDetailsViewModel(this.characterId);
  
  Future<void> getCharacterDetails() async {
    try {
      final charactersDetailsResponse = await _characterRepository.getCharacterDetails(characterId);
      _characterDetails = _makeCharacterListItemData(charactersDetailsResponse);
      notifyListeners();
    } on ApiClientException catch(e) {
      _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClientException exception){
    switch(exception.type){
      case ApiClientExceptionType.network:
        _errorMessage = AppStrings.serverNotAvailable;
        break;
      case ApiClientExceptionType.other:
        _errorMessage = AppStrings.errorTryAgain;
        break;
    }
    notifyListeners();
  }

  CharacterListItemData _makeCharacterListItemData(Character character){
    return CharacterListItemData(
      image: character.image,
      name: character.name,
      species: character.species,
    );
  }
}