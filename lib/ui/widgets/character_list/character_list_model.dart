import 'dart:async';

import 'package:akb_kg_test/domain/entity/character.dart';
import 'package:akb_kg_test/shared/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/entity/сharacter_response.dart';
import '../../../navigation/main_navigation.dart';
import '../../../repository/character_repository.dart';

class CharacterListItemData {
  final int id;
  final String image;
  final String name;
  final String status;
  final String species;

  CharacterListItemData({
    required this.id,
    required this.image,
    required this.name,
    required this.status,
    required this.species,
  });
}

class CharacterListViewModel extends ChangeNotifier {
  final _characterRepository = CharacterRepository();
  final _characters = <CharacterListItemData>[];
  late String? nextPage;
  var isLoadingInProgress = false;
  String? _errorMessage;
  String? _speccy;
  Timer? searchDebounce;

  List<CharacterListItemData> get characters => List.unmodifiable(_characters);

  String? get errorMessage => _errorMessage;

  Future<void> loadInitialCharacters() async {
    try {
      final charactersResponse =
          await _characterRepository.getInitialCharacters();
      _characters.clear();
      _speccy = null;
      _characters.addAll(charactersResponse.characters
          .map(_makeCharacterListItemData)
          .toList());
      nextPage = charactersResponse.info.next;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> _loadNextCharacters() async {
    if (isLoadingInProgress || nextPage == null) return;
    isLoadingInProgress = true;

    try {
      final charactersResponse =
          await _characterRepository.getNextCharacters(nextPage!);
      _characters.addAll(charactersResponse.characters
          .map(_makeCharacterListItemData)
          .toList());
      nextPage = charactersResponse.info.next;
      isLoadingInProgress = false;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> loadFilteredCharactersBySpecies() async {
    if (_speccy == null) return;
    isLoadingInProgress = true;

    try {
      final charactersResponse =
          await _characterRepository.loadFilteredCharactersBySpecies(_speccy!);
      _characters.clear();
      _characters.addAll(charactersResponse.characters.map(_makeCharacterListItemData).toList());
      isLoadingInProgress = false;
      _speccy = null;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

 Future<void> searchCharacter(String name) async {
   searchDebounce?.cancel();
   searchDebounce = Timer(const Duration(milliseconds: 250), () async{
     final query = name.isNotEmpty ? name : null;
     _speccy = null;
     _characters.clear();

     if(query == null){
       return loadInitialCharacters();
     } else {
       try {
         final charactersResponse =
             await _characterRepository.searchCharacterByName(query);
         _characters.addAll(charactersResponse.characters.map(_makeCharacterListItemData).toList());
         notifyListeners();
       } on ApiClientException catch (e) {
         _handleApiClientException(e);
       }
     }
   });
  }

  void addRemoveSpeccy(String speccy, bool isSelected) {
    if (isSelected) {
      _speccy = speccy;
    } else {
      _speccy = null;
    }
  }

  void onCharacterTap(BuildContext context, int index) {
    final id = _characters[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.characterDetails, arguments: id);
  }

  void showNextCharacters(int index) {
    if (index < _characters.length - 1) return;
    _loadNextCharacters();
  }

  void _handleApiClientException(ApiClientException exception) {
    switch (exception.type) {
      case ApiClientExceptionType.network:
        _errorMessage = AppStrings.serverNotAvailable;
        break;
      case ApiClientExceptionType.other:
        _errorMessage = AppStrings.errorTryAgain;
        break;
    }
  }

  CharacterListItemData _makeCharacterListItemData(Character character) {
    return CharacterListItemData(
      id: character.id,
      image: character.image,
      name: character.name,
      status: character.status,
      species: character.species,
    );
  }
}
