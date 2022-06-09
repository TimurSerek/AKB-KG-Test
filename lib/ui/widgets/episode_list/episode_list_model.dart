import 'dart:async';

import 'package:akb_kg_test/shared/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/entity/episode.dart';
import '../../../navigation/main_navigation.dart';
import '../../../repository/episode_repository.dart';

class EpisodeListItemData {
  final int id;
  final String name;
  final String airDate;
  final String episode;

  EpisodeListItemData({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
  });
}

class EpisodeListViewModel extends ChangeNotifier {
  final _episodeRepository = EpisodeRepository();
  final _episodes = <EpisodeListItemData>[];
  late String? nextPage;
  var isLoadingInProgress = false;
  String? _errorMessage;
  Timer? searchDebounce;

  List<EpisodeListItemData> get episodes => List.unmodifiable(_episodes);

  String? get errorMessage => _errorMessage;

  Future<void> loadInitialEpisodes() async {
    try {
      final episodesResponse =
          await _episodeRepository.getInitialEpisodes();
      _episodes.addAll(episodesResponse.episodes.map(_makeEpisodeListItemData).toList());
      nextPage = episodesResponse.info.next;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> _loadNextEpisodes() async {
    if (isLoadingInProgress || nextPage == null) return;
    isLoadingInProgress = true;

    try {
      final episodesResponse =
          await _episodeRepository.getNextEpisodes(nextPage!);
      _episodes.addAll(episodesResponse.episodes.map(_makeEpisodeListItemData).toList());
      nextPage = episodesResponse.info.next;
      isLoadingInProgress = false;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> searchEpisode(String name) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 250), () async{
      final query = name.isNotEmpty ? name : null;
      _episodes.clear();

      if(query == null){
        return loadInitialEpisodes();
      } else {
        try {
          final charactersResponse =
          await _episodeRepository.searchEpisodeByName(query);
          _episodes.addAll(charactersResponse.episodes.map(_makeEpisodeListItemData).toList());
          notifyListeners();
        } on ApiClientException catch (e) {
          _handleApiClientException(e);
        }
      }
    });
  }

  void onEpisodeTap(BuildContext context, int index) {
    final id = _episodes[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.episodeDetails, arguments: id);
  }

  void showNextEpisodes(int index) {
    if (index < _episodes.length - 1) return;
    _loadNextEpisodes();
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

  EpisodeListItemData _makeEpisodeListItemData(Episode episode){
    return EpisodeListItemData(
      id: episode.id,
      name: episode.name,
      airDate: episode.airDate,
      episode: episode.episode,
    );
  }
}
