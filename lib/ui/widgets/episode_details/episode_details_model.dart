
import 'package:akb_kg_test/repository/episode_repository.dart';
import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/entity/episode.dart';
import '../../../shared/constants/app_strings.dart';

class EpisodeListItemData {
  final String name;
  final String airDate;
  final String episode;

  EpisodeListItemData({
    required this.name,
    required this.airDate,
    required this.episode,
  });
}

class EpisodeDetailsViewModel extends ChangeNotifier{
  final _episodeRepository = EpisodeRepository();
  final int episodeId;
  EpisodeListItemData? _episodeDetails;
  String? _errorMessage;

  EpisodeListItemData? get episodeDetails => _episodeDetails;
  String? get errorMessage => _errorMessage;

  EpisodeDetailsViewModel(this.episodeId);

  Future<void> getEpisodeDetails() async {
    try {
      final episodeDetailsResponse = await _episodeRepository.getEpisodeDetails(episodeId);
      _episodeDetails = _makeEpisodeListItemData(episodeDetailsResponse);
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

  EpisodeListItemData _makeEpisodeListItemData(Episode episode){
    return EpisodeListItemData(
      name: episode.name,
      airDate: episode.airDate,
      episode: episode.episode,
    );
  }
}